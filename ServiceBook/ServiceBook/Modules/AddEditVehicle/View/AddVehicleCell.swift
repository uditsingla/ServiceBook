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
        
        self.txtNotes.layer.borderWidth = 0.6
        self.txtNotes.layer.cornerRadius = 4.0
        self.txtNotes.layer.borderColor = UIColor.darkGray.cgColor
        self.txtNotes.textColor = UIColor.darkGray
        self.txtNotes.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 5)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
