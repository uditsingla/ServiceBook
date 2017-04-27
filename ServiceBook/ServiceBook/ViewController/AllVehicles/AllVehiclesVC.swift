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
    self.arrAllVehicles.removeAllObjects()
    self.arrAllVehicles.addObjects(from: arrVehicles as [AnyObject])
    tableAllVehicles.reloadData()
    }
    
    
    func vehicleDeleted()
    {
        allvehiclePrsenter.getAllVehicles()
    }
    
}


class AllVehiclesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

     let allvehiclePrsenter  = AllVehiclesPresenter()
     var arrAllVehicles = NSMutableArray()
    
    @IBOutlet weak var tableAllVehicles: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        allvehiclePrsenter.attachView(self)
        
        tableAllVehicles.setNeedsLayout()
        tableAllVehicles.estimatedRowHeight = 45
        tableAllVehicles.rowHeight = UITableViewAutomaticDimension
        tableAllVehicles.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        allvehiclePrsenter.getAllVehicles()
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
        return arrAllVehicles.count
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                        
            print("\(indexPath.row)")
            let objVehicle = arrAllVehicles.object(at: indexPath.row) as! AllVehiclesI
            allvehiclePrsenter.deleteVehicle(vehicleID: objVehicle.vehicleID)
            //tableAllVehicles.deleteRows(at: [indexPath], with: .fade)
        }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllVehiclesCell", for: indexPath) as! AllVehiclesCell
        
        let vehicleObj :  AllVehiclesI = arrAllVehicles.object(at: indexPath.row) as! AllVehiclesI
        
        cell.lblVehicleNo.text = "Vehicle no : \(vehicleObj.vehicleNo!)"
        cell.lblServiceDue.text = "Service due date : \(AppSharedInstance.sharedInstance.getFormattedStr(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, dateObj: vehicleObj.serviceDueDate!) as String)"
        cell.lblVehicleName.text = "Vehicle name : \(vehicleObj.vehicleName!)"
        cell.lblVehicleType.text = vehicleObj.vehicleType!
        cell.lblNotes.text = "Notes : \(vehicleObj.notes!)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
    }
    

    
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
