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
        
        addvehiclePrsenter.setLocalNotification(vehicleObj : objVehicle, notificationDate: objVehicle.serviceDueDate!)
        
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
         addvehiclePrsenter.setLocalNotification(vehicleObj : objVehicle, notificationDate: objVehicle.serviceDueDate!)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

}

class AddVehicleVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var slectedPickerRow : Int?
    var previousPickerRow : Int?
    
    @IBOutlet weak var viewPicker: UIView!
    
    
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
            pickerDate.setDate(objVehicle.lastServiceDate!, animated: true)
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
        viewPicker.isHidden = true
        
        pickerDate.addTarget(self, action: #selector(selectDate), for: UIControlEvents.valueChanged)
        //UNUserNotificationCenter.current().delegate = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if(!isRecordEdit)
        {
        objVehicle.resetData()
        dtLastService = nil
        tableAddVehicle.reloadData()
        }
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
    
    @IBAction func clkPickerCancel(_ sender: Any) {
        
        if(previousPickerRow != nil)
        {
            slectedPickerRow = previousPickerRow
        }
        
        viewPicker.isHidden = true

    }
    
    @IBAction func clkPickerDone(_ sender: Any) {
        
        if(slectedPickerRow == nil)
        {
            slectedPickerRow = 0
        }
        
        
        var strVehicleType : String?
        switch slectedPickerRow! {
        case 0:
            strVehicleType = "Bicycle"
            break
        case 1:
            strVehicleType = "Bike"

            break
        case 2:
            strVehicleType = "Auto"

            break
        case 3:
            strVehicleType = "Car/Jeep"

            break
        case 4:
            strVehicleType = "Bus/Truck"

            break
        case 5:
            strVehicleType = "Plane"

            break
        case 6:
            strVehicleType = "Helicopter"

            break
            
        default:
            break
        }
        
        objVehicle.vehicleType = strVehicleType!
        viewPicker.isHidden = true
        tableAddVehicle.reloadData()
    }
    
    @IBAction func clkDone(_ sender: Any) {
        
        let dateFormater : DateFormatter = DateFormatter()
        
        dateFormater.dateFormat = AppSharedInstance.sharedInstance.myDateFormatter
        
        
        if(dtLastService == nil)
        {
            dtLastService = pickerDate.date
        }
            
        let srtDate = AppSharedInstance.sharedInstance.getFormattedStr(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, dateObj: dtLastService!)        
        
        objVehicle.lastServiceDate = dateFormater.date(from: srtDate)
        
        tableAddVehicle.reloadData()
        
        viewDatePicker.isHidden = true
    }
    
    @IBAction func clkCancel(_ sender: Any) {
        
        viewDatePicker.isHidden = true
        viewPicker.isHidden = true
        
    }
    @IBAction func clkSave(_ sender: Any) {
        
//        let indexPath = NSIndexPath(forRow:0, inSection:0)
        let indexPath = IndexPath(row: 0, section: 0)
        let cell : AddVehicleCell = tableAddVehicle.cellForRow(at: indexPath) as! AddVehicleCell
        
        print(cell.txtVehicleName.text! as String)
        
        
        
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
        
        if(cell.txtNotes.text == "Notes")
        {
            objVehicle.notes = "No notes available"
        }
        else{
            objVehicle.notes = cell.txtNotes.text
        }

        addvehiclePrsenter.getServiceDueDate(objVehicle : objVehicle)
        print("Service Due Date : \(objVehicle.serviceDueDate)")
        
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
        
        if(objVehicle.notes == "")
        {
            cell.txtNotes.text = "Notes"
            cell.txtNotes.textColor = UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1)
        }
        else
        {
            cell.txtNotes.text = objVehicle.notes
            cell.txtNotes.textColor = UIColor.black
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
      
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        
        let myView = UIView.init(frame: CGRect(x : 0, y : 0, width : pickerView.bounds.width - 30, height: 60))
        
        let myImageView = UIImageView.init(frame: CGRect(x : self.view.frame.size.width/2 - 30, y : 0, width : 50, height: 50))
        
        switch row {
        case 0:
            myImageView.image = UIImage(named:"bicycle.png")
        case 1:
            myImageView.image = UIImage(named:"bike.png")
        case 2:
            myImageView.image = UIImage(named:"auto.png")
        case 3:
            myImageView.image = UIImage(named:"car.png")
        case 4:
            myImageView.image = UIImage(named:"bus.png")
        case 5:
            myImageView.image = UIImage(named:"plane.png")
        case 6:
            myImageView.image = UIImage(named:"heli.png")
        default:
            myImageView.image = nil
        }
        //        let myLabel = UILabel(frame: CGRectMake(60, 0, pickerView.bounds.width - 90, 60 ))
        //        myLabel.font = UIFont(name:some font, size: 18)
        //        myLabel.text = rowString
        //
        //        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        // do something with selected row
        slectedPickerRow = row
    }

    // MARK: - TextView delegates
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        
        if(textView.text == "Notes")
        {
            textView.text = ""
        }
//        if(objVehicle.notes = "Notes")
//        let indexPath = IndexPath(row: 0, section: 0)
//        let cell : AddVehicleCell = tableAddVehicle.cellForRow(at: indexPath) as! AddVehicleCell
//        cell.txtNotes.text = ""
//        cell.txtNotes.textColor = UIColor.black
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if(textView.text == "")
        {
            textView.text = "Notes"
        }
        textView.resignFirstResponder()
    }
    
    
    public func textViewDidChange(_ textView: UITextView)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell : AddVehicleCell = tableAddVehicle.cellForRow(at: indexPath) as! AddVehicleCell
        
        if(cell.txtNotes.text.characters.count == 0)
        {
            cell.txtNotes.textColor = UIColor.lightGray
            cell.txtNotes.text = "Notes"
            cell.txtNotes.resignFirstResponder()
        }
        else
        {
            cell.txtNotes.textColor = UIColor.black
        }
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
     if(textField.tag ==  2)
    {
        self.view.endEditing(true)
        
        viewPicker.isHidden = false
        
        return false
    }
    else if(textField.tag ==  4)
    {
        self.view.endEditing(true)
        
        viewDatePicker.isHidden = false
        
        return false
    }
    else
    {
        viewDatePicker.isHidden = true
        viewPicker.isHidden = true
    }
    return true
}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTage = textField.tag+1
        
        switch nextTage {
        case 2:
            textField.resignFirstResponder()
            viewPicker.isHidden = false
            return true
            
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
