//
//  FinanceTableViewCell.swift
//  VTaKDPhi
//
//  Created by Zuri Wong on 11/2/18.
//  Copyright © 2018 Zuri Wong. All rights reserved.
//

import UIKit

class FinanceTableViewCell: UITableViewCell {
    
//    var infoPassed = DueStruct(name: "", cost: 0.00, dueDate: "", late: true, description: "")
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var lateSegmentControl: UISegmentedControl!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//
//        nameLabel.text = infoPassed.name
//        costLabel.text = "\(infoPassed.cost)"
//        switch infoPassed.late {
//        case true:
//            lateSegmentControl.selectedSegmentIndex = 1
//        default:
//            lateSegmentControl.selectedSegmentIndex = 0
//        }
//        dueDateLabel.text = infoPassed.dueDate
//        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
