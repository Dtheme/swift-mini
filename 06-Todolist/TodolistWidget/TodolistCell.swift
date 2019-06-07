//
//  TodolistCell.swift
//  TodolistWidget
//
//  Created by dzw on 2019/6/4.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class TodolistCell: UITableViewCell {

    @IBOutlet weak var checkMarkBtn: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var PlaceHolderLabel: UILabel!
    
    var didSelectCheckMark : ((_ phoneNumber: UIButton) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        checkMarkBtn.layer.cornerRadius = checkMarkBtn.frame.width/2
        checkMarkBtn.layer.borderWidth = 1
        checkMarkBtn.layer.borderColor = UIColor.black.cgColor
        checkMarkBtn.layer.masksToBounds = true

    }

    @IBAction private func checkMarkAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.didSelectCheckMark!(sender)
        if sender.isSelected {
            PlaceHolderLabel.text = "👏"
            checkMarkBtn.backgroundColor = UIColor(red:72.0/255.0, green:179.0/255.0, blue:252.0/255.0, alpha:255.0/255.0)
        }else{
            PlaceHolderLabel.text = "💪"
            checkMarkBtn.backgroundColor = UIColor.clear
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
