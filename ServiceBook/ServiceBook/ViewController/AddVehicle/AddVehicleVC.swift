//
//  AddVehicleVC.swift
//  ServiceBook
//
//  Created by Apple on 21/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit
import UserNotifications

extension AddVehicleVC : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}

extension AddVehicleVC : AddVehicleView
{
    func startLoading()
    {
//        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//        loadingNotification.mode = MBProgressHUDMode.indeterminate
//        loadingNotification.label.text = "Loading"
    }
    func finishLoading()
    {
//        MBProgressHUD.hide(for: self.view, animated: true)
        
    }
    
    func newVehicleAdded(isSuccess : Bool)
    {
        print("Vehicle has been added succesfully")
        
        objVehicle.resetData()
        tableAddVehicle.reloadData()
        
        self.setLocalNotification()
    }
    

}

class AddVehicleVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var viewDatePicker: UIView!
    
    @IBOutlet weak var pickerDate: UIDatePicker!
    
    var dtLastService : Date?
    var dtServiceDueDate : Date?
    
    let objVehicle : AllVehiclesI = AllVehiclesI()

    let addvehiclePrsenter  = AddVehiclePresenter()
    
    @IBOutlet weak var tableAddVehicle: UITableView!
    
    var dictData  = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addvehiclePrsenter.attachView(self)
        
        tableAddVehicle.setNeedsLayout()        
        tableAddVehicle.estimatedRowHeight = 370
        tableAddVehicle.rowHeight = UITableViewAutomaticDimension
        tableAddVehicle.tableFooterView = UIView()
        
        viewDatePicker.isHidden = true
        
        pickerDate.addTarget(self, action: #selector(selectDate), for: UIControlEvents.valueChanged)
        UNUserNotificationCenter.current().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Date Picker Delegates
    func selectDate()
    {
        dtLastService = pickerDate.date
        print(pickerDate.date)
    }
    
    // MARK: - Custom Functions    
    
    func getServiceDueDate() -> String {
        
        let averageDayRun  = Float(objVehicle.serviceRequiredAfter!)/Float(objVehicle.averageRun!)
        
        let noOfDays = Float(objVehicle.serviceRequiredAfter!)/averageDayRun
        
        let currentCalendar = NSCalendar.current
        
        dtServiceDueDate = currentCalendar.date(byAdding: Calendar.Component.day, value: Int(noOfDays), to: dtLastService!)
        
        let strDueDate = AppSharedInstance.sharedInstance.getFormattedStr(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, dateObj: dtServiceDueDate!)
        
        print("Service due on : \(strDueDate)")

        return strDueDate
        
    }
    
    func setLocalNotification()
    {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Service Required"
        notificationContent.subtitle = "Get Ready"
        notificationContent.body = "You should go to see a workshop"
        
        
        let date = Date(timeIntervalSinceNow: 10)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: false)
        
        
        // Add Trigger W.R.T Time
//        let notificationTriggerTest = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
//        
//        // Create Notification Request
//        let notificationRequestTest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTriggerTest)
       
         let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    //MARK: - Clk Functions

    @IBAction func clkDone(_ sender: Any) {
        
        let dateFormater : DateFormatter = DateFormatter()
        
        dateFormater.dateFormat = AppSharedInstance.sharedInstance.myDateFormatter
        
        
        let srtDate = AppSharedInstance.sharedInstance.getFormattedStr(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, dateObj: dtLastService!)
        
        
        objVehicle.lastServiceDate = dateFormater.date(from: srtDate)
        
        tableAddVehicle.reloadData()
        
        viewDatePicker.isHidden = true
    }
    
    @IBAction func clkCancel(_ sender: Any) {
        
        viewDatePicker.isHidden = true
    }
    @IBAction func clkSave(_ sender: Any) {
        
//        let indexPath = NSIndexPath(forRow:0, inSection:0)
        let indexPath = IndexPath(row: 0, section: 0)
        let cell : AddVehicleCell = tableAddVehicle.cellForRow(at: indexPath) as! AddVehicleCell
        
        print(cell.txtVehicleName.text! as String)
        
        getServiceDueDate()
        
        //Populate Objects
        objVehicle.vehicleID = UUID().uuidString
        objVehicle.vehicleName = cell.txtVehicleName.text
        objVehicle.vehicleType = cell.txtVehicleType.text
        
        if let myNumber = NumberFormatter().number(from: cell.txtServiceRequired.text!) {
            objVehicle.serviceRequiredAfter = myNumber.intValue
        }
        
        objVehicle.serviceDueDate = dtServiceDueDate
        
        if let myAverageRun = NumberFormatter().number(from: cell.txtWeeklyRun.text!) {
            objVehicle.averageRun = myAverageRun.intValue
        }
        
        objVehicle.vehicleNo = cell.txtVehicleNo.text
        objVehicle.notes = cell.txtNotes.text
        
        
        addvehiclePrsenter.addVehicle(objVehicle: objVehicle)

    }
    
    
    
    @IBAction func clkEdit(_ sender: Any) {
        
        
    }
    
     // MARK: - Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 1
    }
           
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddVehicleCell", for: indexPath) as! AddVehicleCell
        
        cell.txtVehicleName.text = objVehicle.vehicleName!
        cell.txtVehicleType.text = objVehicle.vehicleType!
        
        if(objVehicle.serviceRequiredAfter != nil)
        {
        cell.txtServiceRequired.text = objVehicle.serviceRequiredAfter!.description
        }
        else
        {
            cell.txtServiceRequired.text = ""
        }
        if(dtLastService != nil)
        {
        let srtDate = AppSharedInstance.sharedInstance.getFormattedStr(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, dateObj: dtLastService!)
        cell.txtLastServiceDate.text = srtDate
        }
        else
        {
            cell.txtServiceRequired.text = ""
        }
        
        if(objVehicle.averageRun != nil)
        {
        cell.txtWeeklyRun.text = objVehicle.averageRun!.description
        }
        else
        {
            cell.txtServiceRequired.text = ""
        }
        cell.txtVehicleNo.text = objVehicle.vehicleNo!
        cell.txtNotes.text = objVehicle.notes
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
      
    }

    // MARK: - TextView delegates
    func textViewDidEndEditing(_ textView: UITextView)
    {
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            dictData["notes"] = textView.text
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - TextField delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.tag == 4)
        {
            textField.resignFirstResponder()
            viewDatePicker.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let nextTage = textField.tag
        switch nextTage {
        case 1:
            objVehicle.vehicleName = textField.text
            break
        case 2:
            objVehicle.vehicleType = textField.text
            break
        case 3:

            if let myNumber = NumberFormatter().number(from: textField.text!) {
                objVehicle.serviceRequiredAfter = myNumber.intValue
            }
            
            return
            
        case 5:
            if let myNumber = NumberFormatter().number(from: textField.text!) {
                objVehicle.averageRun = myNumber.intValue
            }
            break
        case 6:
            objVehicle.vehicleNo = textField.text
            break
        default: break
            
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTage = textField.tag+1
        
        switch nextTage {
        case 2:
            objVehicle.vehicleName = textField.text
            break
        case 3:
             objVehicle.vehicleType = textField.text
            break
        case 4:
            textField.resignFirstResponder()
            viewDatePicker.isHidden = false
            if let myNumber = NumberFormatter().number(from: textField.text!) {
             objVehicle.serviceRequiredAfter = myNumber.intValue
            }
            return true
            
        case 6:
            if let myNumber = NumberFormatter().number(from: textField.text!) {
                objVehicle.averageRun = myNumber.intValue
            }
            break
        case 7:
             objVehicle.vehicleNo = textField.text
            break
        default: break
            
        }
        
        
        // Try to find next responder
        let nextResponder=textField.superview?.superview?.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            
                nextResponder?.becomeFirstResponder()
        
            
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
