//
//  AddVehicleVC.swift
//  ServiceBook
//
//  Created by Apple on 21/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit


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
        
        tableAddVehicle.setNeedsLayout()        
        tableAddVehicle.estimatedRowHeight = 380
        tableAddVehicle.rowHeight = UITableViewAutomaticDimension
        tableAddVehicle.tableFooterView = UIView()
        
        viewDatePicker.isHidden = true
        
        pickerDate.addTarget(self, action: #selector(selectDate), for: UIControlEvents.valueChanged)
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
        
        let averageDayRun  = Float(objVehicle.serviceRequiredAfter)/Float(objVehicle.averageRun!)
        
        let noOfDays = Float(objVehicle.serviceRequiredAfter)/averageDayRun
        
        let currentCalendar = NSCalendar.current
        
        dtServiceDueDate = currentCalendar.date(byAdding: Calendar.Component.day, value: Int(noOfDays), to: dtLastService!)
        
        let strDueDate = AppSharedInstance.sharedInstance.getFormattedStr(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, dateObj: dtServiceDueDate!)
        
        print("Service due on : \(strDueDate)")

        return strDueDate
        
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
        
        getServiceDueDate()
        objVehicle.vehicleID = UUID().uuidString
        objVehicle.serviceDueDate = dtServiceDueDate
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
    
    
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    //    {
    //        return UITableViewAutomaticDimension;
    //    }
    //
    //
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    //    {
    //        return UITableViewAutomaticDimension;
    //    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddVehicleCell", for: indexPath) as! AddVehicleCell
        
        let ov = objVehicle
        
        cell.txtVehicleName.text = ov.vehicleName!
        cell.txtVehicleType.text = ov.vehicleType!
        cell.txtServiceRequired.text = ov.serviceRequiredAfter.description
        
        if(dtLastService != nil)
        {
        let srtDate = AppSharedInstance.sharedInstance.getFormattedStr(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, dateObj: dtLastService!)
        cell.txtLastServiceDate.text = srtDate
        }
        
        cell.txtWeeklyRun.text = ov.averageRun!.description
        cell.txtVehicleNo.text = ov.vehicleNo!
        cell.txtNotes.text = ov.notes
        
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
            viewDatePicker.isHidden = false
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
            break
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
