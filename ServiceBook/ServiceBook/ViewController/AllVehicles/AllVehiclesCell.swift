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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
