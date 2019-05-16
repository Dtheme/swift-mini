//
//  ABdetailHeaderView.swift
//  02-AddressBook
//
//  Created by dzw on 2019/5/14.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class ABdetailHeaderView: UIView {
    
    
    var nameLabel: UILabel!
    var msgButton: UIButton!
    var callButton: UIButton!
    var headerImageView: UIImageView!
    var callAction : (()->Void)?
    var msgAction : (()->Void)?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func call(_ sender: Any) {
        self.callAction!()
    }
    
    @objc func msg(_ sender: Any) {
        self.msgAction!()
    }
    
    public func updateView(model:Person) {
        nameLabel.text = String(format: "%@ %@ %@", model.givenName!,model.middleName!,model.familyName!)
    }

}

//MARK: -  private
extension ABdetailHeaderView {

    //使用纯代码创建View
    func configView()  {
        
        headerImageView = UIImageView.init(frame: CGRect.init(x: UIScreen.main.bounds.size.width/2-32, y: 10, width: 64, height: 64))
        headerImageView.image = UIImage.init(named: "header_placeholder")
        self.addSubview(headerImageView)
        
        nameLabel = UILabel.init(frame: CGRect.init(x: 0, y: headerImageView.frame.maxY+10, width: UIScreen.main.bounds.size.width, height: 30))
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.text = "John Appleseed"
        self.addSubview(nameLabel)

        callButton = UIButton.init(frame: CGRect.init(x: 100, y: nameLabel.frame.maxY+10, width: 44, height: 44))
        callButton.setImage(UIImage.init(named: "call"), for: .normal)
        callButton.backgroundColor = UIColor(red:21.0/255.0, green:126.0/255.0, blue:251.0/255.0, alpha:255.0/255.0)
        callButton.tintColor = UIColor.white
        callButton.addTarget(self, action: #selector(call(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(callButton)

        msgButton = UIButton.init(frame: CGRect.init(x: UIScreen.main.bounds.size.width-100-44, y: nameLabel.frame.maxY+10, width: 44, height: 44))
        msgButton.setImage(UIImage.init(named: "msg"), for: .normal)
        msgButton.backgroundColor = UIColor(red:21.0/255.0, green:126.0/255.0, blue:251.0/255.0, alpha:255.0/255.0)
        msgButton.tintColor = UIColor.white
        msgButton.addTarget(self, action: #selector(msg(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(msgButton)
        
        self.setRoundedCorners(msgButton)
        self.setRoundedCorners(callButton)
        self.setRoundedCorners(headerImageView)
        
        msgButton.setImage(UIImage.init(named: "msg"), for: .normal)
        callButton.setImage(UIImage.init(named: "call"), for: .normal)
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
    }
    
    private func setRoundedCorners(_ targetView:UIView){

        let maskPath = UIBezierPath.init(roundedRect: targetView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: targetView.bounds.size.width, height: targetView.bounds.size.width))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = targetView.bounds
        maskLayer.path = maskPath.cgPath
        targetView.layer.mask = maskLayer

    }
}
