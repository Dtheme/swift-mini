//
//  AgentInfoSectionHeader.swift
//  03-RainbowSix
//
//  Created by dzw on 2019/5/16.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class AgentInfoSectionHeader: UIView {

    @IBOutlet weak var didSelectSectionBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessImage: UIImageView!
    
    var didSelect : ((_ sender: UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func updateView(title:String,isFold:Bool) {
        self.titleLabel.text = title
        self.didSelectSectionBtn.isSelected = isFold
        self.updateImage()
    }
    
    @IBAction func didSelectSection(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print("\(sender.isSelected)")
//        self.updateImage()
        self.didSelect!(sender)
    }
    
    func updateImage() {
        if self.didSelectSectionBtn.isSelected{
            accessImage.image = UIImage.init(named: "right")
        }else{
            accessImage.image = UIImage.init(named: "down")
        }
    }
    
}
