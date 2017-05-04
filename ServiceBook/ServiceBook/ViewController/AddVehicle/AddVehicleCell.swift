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
        
        self.txtNotes.layer.borderWidth = 1.0
        self.txtNotes.layer.cornerRadius = 5.0
        self.txtNotes.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1).cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
