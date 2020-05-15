//
//  AllVehiclesCell.swift
//  ServiceBook
//
//  Created by Apple on 21/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit

class AllVehiclesCell: UITableViewCell {
    
    @IBOutlet weak var lblVehicleNo: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var lblServiceDue: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var imgVehicleType: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setData(gadgetObj: Gadget) {
        let attributeText = AppSharedInstance.sharedInstance.getReadableDateFromTimeStamp(timeStamp: gadgetObj.serviceDueDate!)
        
        let mainText = "Service Due Date : \(attributeText!)"
        let range = (mainText as NSString).range(of: attributeText!)
        let attributedString = NSMutableAttributedString(string:mainText)
        
        attributedString.addAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Italic", size: 15)!,
                                        NSAttributedStringKey.foregroundColor: UIColor.red], range: range)
        
        
        let attributeTextNotes = "\(gadgetObj.notes!.capitalized)"
        let mainTextNotes = "Notes : \(attributeTextNotes)"
        let rangeNotes = (mainTextNotes as NSString).range(of: attributeTextNotes)
        let attributedStringNotes = NSMutableAttributedString(string:mainTextNotes)
        attributedStringNotes.addAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Italic", size: 15)!], range:  rangeNotes)
        
        self.lblServiceDue.attributedText = attributedString
        self.lblVehicleNo.text = "Vehicle No : \(gadgetObj.vehicleNo!)"
        self.lblVehicleName.text = "Vehicle Name : \(gadgetObj.vehicleName!)"
        self.imgVehicleType.image = UIImage(named: getImage(vehicleType: (gadgetObj.vehicleType)!))
        self.lblNotes.attributedText = attributedStringNotes
        
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
        case "Other":
            strImageName = "other.png"
        default:
            strImageName = "other.png"
        }
        return strImageName!
    }
    
}
