//
//  TravelledListDataTableViewCell.swift
//  SolulabTestProject
//
//  Created by Suraj on 05/01/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit

class TravelledListDataTableViewCell: UITableViewCell {

    @IBOutlet weak var travelledDistanceOnTime: UILabel!
    @IBOutlet weak var travelledDistanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
