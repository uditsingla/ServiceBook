//
//  AddVehicleCell.swift
//  ServiceBook
//
//  Created by Apple on 24/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit

class AddVehicleCell: UITableViewCell {

    @IBOutlet weak var txtVehicleName: UITextField!
    @IBOutlet weak var txtVehicleType: UITextField!    
    @IBOutlet weak var txtServiceRequired: UITextField!
    @IBOutlet weak var txtLastServiceDate: UITextField!
    @IBOutlet weak var txtWeeklyRun: UITextField!
    @IBOutlet weak var txtVehicleNo: UITextField!
    @IBOutlet weak var txtNotes: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
