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
        print("Vehicle has been added succesfully")
        
        addvehiclePrsenter.setLocalNotification(strUniqueID : strUniqueID!, notificationDate: objVehicle.serviceDueDate!)
        
        objVehicle.resetData()
        
        dtLastService = nil
        
        tableAddVehicle.reloadData()
        
        
    }
    
    func vehicleInfoUpdated(isSuccess : Bool)
    {
        print("Vehicle info has been added updated succesfully")

        //remove Existing notification
        addvehiclePrsenter.removeNotification(arrNotificationID: [objVehicle.vehicleID])

        
        //add New Local Notification
         addvehiclePrsenter.setLocalNotification(strUniqueID : objVehicle.vehicleID, notificationDate: objVehicle.serviceDueDate!)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

}

class AddVehicleVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate  {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var contraintTopViewHeight: NSLayoutConstraint!
    
     @IBOutlet weak var viewTopBar: UIView!
    
    @IBOutlet weak var viewDatePicker: UIView!
    
    @IBOutlet weak var pickerDate: UIDatePicker!
    
    var isRecordEdit : Bool = false
    
    var dtLastService : Date?
    //var dtServiceDueDate : Date?
    
    var objVehicle : AllVehiclesI = AllVehiclesI()

    let addvehiclePrsenter  = AddVehiclePresenter()
    
    @IBOutlet weak var tableAddVehicle: UITableView!
    
    var dictData  = NSMutableDictionary()
    
    var strUniqueID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        addvehiclePrsenter.attachView(self)
        
        if(isRecordEdit)
        {            
            lblHeading.text = "Update Info"
            btnBack.isHidden = false
        }
        else
        {
            lblHeading.text = "Add Vehicle"
            btnBack.isHidden = true
        }
        
        tableAddVehicle.setNeedsLayout()        
        tableAddVehicle.estimatedRowHeight = 370
        tableAddVehicle.rowHeight = UITableViewAutomaticDimension
        tableAddVehicle.tableFooterView = UIView()
        
        viewDatePicker.isHidden = true
        
        pickerDate.addTarget(self, action: #selector(selectDate), for: UIControlEvents.valueChanged)
        //UNUserNotificationCenter.current().delegate = self
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
    
    
    
    //MARK: - Clk Functions

    @IBAction func clkBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
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
        
        addvehiclePrsenter.getServiceDueDate(objVehicle : objVehicle)
        
        //Populate Objects
        if(!isRecordEdit)
        {
            strUniqueID = UUID().uuidString
            objVehicle.vehicleID = strUniqueID!
        }
        
        
        // print("Uniuqe id : \(strUniqueID!)")
        
        
        objVehicle.vehicleName = cell.txtVehicleName.text
        objVehicle.vehicleType = cell.txtVehicleType.text
        
        if let myNumber = NumberFormatter().number(from: cell.txtServiceRequired.text!) {
            objVehicle.serviceRequiredAfter = myNumber.intValue
        }
        
        //objVehicle.serviceDueDate = dtServiceDueDate
        
        if let myAverageRun = NumberFormatter().number(from: cell.txtWeeklyRun.text!) {
            objVehicle.averageRun = myAverageRun.intValue
        }
        
        objVehicle.vehicleNo = cell.txtVehicleNo.text
        objVehicle.notes = cell.txtNotes.text
        

        if(isRecordEdit)
        {
            //Edit Existing record
            addvehiclePrsenter.editVehicalInfo(objVehicle : objVehicle)
        }
        else
        {
            //Add New Record
             addvehiclePrsenter.addVehicle(objVehicle: objVehicle)
        }
       
        
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
        
        if(isRecordEdit)
        {
            dtLastService = objVehicle.lastServiceDate
        }
        
        if(dtLastService != nil)
        {
            let srtDate = AppSharedInstance.sharedInstance.getFormattedStr(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, dateObj: dtLastService!)
            
            cell.txtLastServiceDate.text = srtDate
        }
        else
        {
            cell.txtLastServiceDate.text = ""
        }
        
        if(objVehicle.averageRun != nil)
        {
        cell.txtWeeklyRun.text = objVehicle.averageRun!.description
        }
        else
        {
            cell.txtWeeklyRun.text = ""
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
           self.view.endEditing(true)
            
           viewDatePicker.isHidden = false
        }
        else
        {
            viewDatePicker.isHidden = true
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
            break

            
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
    
func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
{
    if(textField.tag ==  4)
    {
        self.view.endEditing(true)
        
        viewDatePicker.isHidden = false
        return false
    }
    else
    {
        viewDatePicker.isHidden = true
    }
    return true
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
