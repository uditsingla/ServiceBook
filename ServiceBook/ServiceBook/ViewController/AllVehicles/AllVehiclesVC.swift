//
//  AllVehiclesVC.swift
//  ServiceBook
//
//  Created by Apple on 21/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit
import UserNotifications


extension AllVehiclesVC : AllVehicleView
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
    
   func allVehiclesReceives(arrVehicles : NSMutableArray)
   {
    
    print("\(arrVehicles)")
    self.arrAllVehicles.removeAllObjects()
    self.arrAllVehicles.addObjects(from: arrVehicles as [AnyObject])
    tableAllVehicles.reloadData()
    }
    
    
    func vehicleDeleted()
    {
        AppSharedInstance.sharedInstance.removeNotification(arrNotificationID: [objVehicle.vehicleID])
        
        allvehiclePrsenter.getAllVehicles()
    }
    
}


class AllVehiclesVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

     let allvehiclePrsenter  = AllVehiclesPresenter()
     var arrAllVehicles =  NSMutableArray()
    var objVehicle : AllVehiclesI = AllVehiclesI()
    
    
    var gadgets = [Gadget]()
    var gadgetToUpdate: Gadget?

    @IBOutlet weak var tableAllVehicles: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        allvehiclePrsenter.attachView(self)
        
        tableAllVehicles.setNeedsLayout()
        tableAllVehicles.estimatedRowHeight = 45
        tableAllVehicles.rowHeight = UITableViewAutomaticDimension
        tableAllVehicles.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        //print("Date is : %@",AppSharedInstance.sharedInstance.getReadableDateFromTimeStamp(timeStamp: 1860172200))
    }
    
    func getAllRecords(){
        FIRFireStoreService.shared.read(from: .gadgets, returning: Gadget.self) { (gags) in
            self.gadgets = gags
            print(self.gadgets.count)
        }
    }
    
    
    @objc func methodOfReceivedNotification(notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            
            print("*********************************")
            print("** ALL vehicle VC Notification **")
            print("*********************************")
            print(dict)
            print("*********************************")
            
            let allVehicleObj = AllVehiclesI()
            
            let strDate = AppSharedInstance.sharedInstance.getServiceDueDate(objVehicle: allVehicleObj)
            let newDueDatetObj = AppSharedInstance.sharedInstance.getFormattedDate(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, stringObj: strDate)
            
            //allVehicleObj.vehicleID = dict["id"] as? String ?? ""
            allVehicleObj.vehicleType = dict["type"] as? String ?? ""
            allVehicleObj.vehicleName = dict["name"] as? String ?? ""
            allVehicleObj.vehicleNo = dict["no"] as? String ?? ""
            allVehicleObj.serviceRequiredAfter = dict["serviceReqAfter"] as? Int
            allVehicleObj.averageRun = dict["averageRun"] as? Int ?? 0
            allVehicleObj.notes = dict["notes"] as? String ?? ""
            allVehicleObj.lastServiceDate = dict["serviceDueDate"] as? Date ?? Date()
            allVehicleObj.serviceDueDate = newDueDatetObj
            
            allvehiclePrsenter.addNewVehicle(objVehicle: allVehicleObj)
            
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        allvehiclePrsenter.getAllVehicles()
        getAllRecords()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return gadgets.count
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                        
            print("\(indexPath.row)")
            objVehicle = arrAllVehicles.object(at: indexPath.row) as! AllVehiclesI
            allvehiclePrsenter.deleteVehicle(vehicleID: objVehicle.vehicleID)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllVehiclesCell", for: indexPath) as! AllVehiclesCell
        
        let vehicleObj :  AllVehiclesI = arrAllVehicles.object(at: indexPath.row) as! AllVehiclesI
        
        
        let attributeText = AppSharedInstance.sharedInstance.getFormattedStr(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, dateObj: vehicleObj.serviceDueDate!) as String
        let mainText = "Service Due Date : \(attributeText)"
        let range = (mainText as NSString).range(of: attributeText)
        let attributedString = NSMutableAttributedString(string:mainText)
        
        attributedString.addAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Italic", size: 15)!,
                                        NSAttributedStringKey.foregroundColor: UIColor.red], range: range)
        
        
        let attributeTextNotes = "\(vehicleObj.notes!.capitalized)"
        let mainTextNotes = "Notes : \(attributeTextNotes)"
        let rangeNotes = (mainTextNotes as NSString).range(of: attributeTextNotes)
        let attributedStringNotes = NSMutableAttributedString(string:mainTextNotes)
        attributedStringNotes.addAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Italic", size: 15)!], range:  rangeNotes)
        
        
        cell.lblServiceDue.attributedText = attributedString
        cell.lblVehicleNo.text = "Vehicle No : \(vehicleObj.vehicleNo!)"
        cell.lblVehicleName.text = "Vehicle Name : \(vehicleObj.vehicleName!)"
        cell.imgVehicleType.image = UIImage(named: getImage(vehicleType: (vehicleObj.vehicleType)!))
        //cell.lblVehicleType.text = vehicleObj.vehicleType!
        cell.lblNotes.attributedText = attributedStringNotes
        
        return cell
        
    }
    
    func getImage(vehicleType : String) -> String {
        
        var strImageName : String?
        switch vehicleType
        {
        case "Bicycle":
            strImageName =  "bicycle.png"
            break
        case "Bike":
            strImageName = "bike.png"
            break
        case "Auto":
            strImageName = "auto.png"
            break
        case "Car/Jeep":
            strImageName = "car.png"
            break
        case "Bus/Truck":
            strImageName =  "bus.png"
            break
        case "Plane":
            strImageName =  "plane.png"
            break
        case "Helicopter":
            strImageName =  "heli.png"
            break
        default:
            strImageName = ""
        }
        return strImageName!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let vehicleObj :  AllVehiclesI = arrAllVehicles.object(at: indexPath.row) as! AllVehiclesI
        
        let addVehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "AddVehicleVC") as! AddVehicleVC
        
        addVehicleVC.objVehicle = vehicleObj
        addVehicleVC.isRecordEdit = true
        addVehicleVC.gadgetToUpdate = gadgetToUpdate
        
        
        self.navigationController?.pushViewController(addVehicleVC, animated: true)

    }
    
    //MARK : UIPickerView
    // MARK: UIPickerViewDataSource
    
    

    
    // MARK: - Custom Functions
    
    
    //MARK: - Clk Functions
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
