//
//  ABDetailCell.swift
//  02-AddressBook
//
//  Created by dzw on 2019/5/14.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class ABDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        infoLabel.sizeToFit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
