//
//  HistoryVC.swift
//  ServiceBook
//
//  Created by Apple on 04/05/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit

extension HistoryVC : HistoryView
{
    func startLoading()
    {
        
    }
    func finishLoading()
    {
        
    }
    
    func allVehiclesReceives(arrVehicles : NSMutableArray)
    {
        arrAllVehicles.removeAllObjects()
        arrAllVehicles = arrVehicles
        tableAllVehicles.reloadData()
    }
    
    func vehicleDeleted()
    {        
        historyPrsenter.getAllVehicles()
    }
}


class HistoryVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    let historyPrsenter  = HistoryPresenter()
    var arrAllVehicles =  NSMutableArray()
    var objVehicle : AllVehiclesI = AllVehiclesI()
    
    @IBOutlet weak var tableAllVehicles: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        historyPrsenter.attachView(self)
        
        tableAllVehicles.setNeedsLayout()
        tableAllVehicles.estimatedRowHeight = 45
        tableAllVehicles.rowHeight = UITableViewAutomaticDimension
        tableAllVehicles.tableFooterView = UIView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        historyPrsenter.getAllVehicles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Functions
    
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
            objVehicle = arrAllVehicles.object(at: indexPath.row) as! AllVehiclesI
            historyPrsenter.deleteVehicle(vehicleID: objVehicle.vehicleID)
            //tableAllVehicles.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllVehiclesCell", for: indexPath) as! AllVehiclesCell
        
        let vehicleObj :  AllVehiclesI = arrAllVehicles.object(at: indexPath.row) as! AllVehiclesI
        
        
        let attributeText = AppSharedInstance.sharedInstance.getFormattedStr(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, dateObj: vehicleObj.serviceDueDate!) as String
        let mainText = "Service Date : \(attributeText)"
        let range = (mainText as NSString).range(of: attributeText)
        let attributedString = NSMutableAttributedString(string:mainText)
        attributedString.addAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Italic", size: 15)!,
                                        NSAttributedStringKey.foregroundColor: UIColor(red: 0.0/255.0, green: 149.0/255.0, blue: 157.0/255.0, alpha: 1)], range: range)
        
        
        let attributeTextNotes = "\(vehicleObj.notes!.capitalized)"
        let mainTextNotes = "Notes : \(attributeTextNotes)"
        let rangeNotes = (mainTextNotes as NSString).range(of: attributeTextNotes)
        let attributedStringNotes = NSMutableAttributedString(string:mainTextNotes)
        attributedStringNotes.addAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Italic", size: 15)!], range:  rangeNotes)
        
        
        
        cell.lblVehicleNo.text = "Vehicle No : \(vehicleObj.vehicleNo!)"
        cell.lblServiceDue.attributedText = attributedString
        cell.lblVehicleName.text = "Vehicle Name : \(vehicleObj.vehicleName!)"
        cell.imgVehicleType.image = UIImage(named: getImage(vehicleType: (vehicleObj.vehicleType)!))
        //cell.lblVehicleType.text = vehicleObj.vehicleType!
        cell.lblNotes.attributedText = attributedStringNotes
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let vehicleObj :  AllVehiclesI = arrAllVehicles.object(at: indexPath.row) as! AllVehiclesI
        
        let addVehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "AddVehicleVC") as! AddVehicleVC
        
        addVehicleVC.objVehicle = vehicleObj
        addVehicleVC.isRecordEdit = true
        
        self.navigationController?.pushViewController(addVehicleVC, animated: true)
        
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
