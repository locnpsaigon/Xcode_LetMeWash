//
//  ServiceViewCell.swift
//  LetMeWash
//
//  Created by Nguyen Phuoc Loc on 12/28/17.
//  Copyright © 2017 Nguyen Phuoc Loc. All rights reserved.
//

import UIKit

class ServiceViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
