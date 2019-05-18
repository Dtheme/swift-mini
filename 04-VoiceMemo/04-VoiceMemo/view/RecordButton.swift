//
//  RecordButton.swift
//  04-VoiceMemo
//
//  Created by dzw on 2019/5/18.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class RecordButton: UIView {
    let ViewRadius = 80
    let innerBorder = 3
    let animationDuraion = 0.2
    
    var innerButton: UIButton!
    var action : ((_ sender:UIButton)->Void)?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.configView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configView()
    }
    @objc func innerButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.action!(sender)
    }
    
    func configView(){
        self.backgroundColor = #colorLiteral(red: 0.19612059, green: 0.1965018511, blue: 0.1714800596, alpha: 1)
        self.layer.cornerRadius = CGFloat(ViewRadius/2)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = CGFloat(innerBorder)
        self.layer.masksToBounds = true
        
        self.innerButton = UIButton(frame: CGRect.init(x: innerBorder*2, y: innerBorder*2, width: ViewRadius - innerBorder*4, height: ViewRadius - innerBorder*4))
        self.innerButton!.addTarget(self, action: #selector(innerButtonAction(_:)), for: UIControl.Event.touchUpInside)
        innerButton.backgroundColor = #colorLiteral(red: 0.9990579486, green: 0.2335602939, blue: 0.1984924972, alpha: 1)
        innerButton.layer.cornerRadius = innerButton.frame.size.width/2
        innerButton.layer.masksToBounds = true
        self.addSubview(self.innerButton)
    }
}

//MARK: -  animation
extension RecordButton{
    public func startButtonAnimation() {
        
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        cornerRadiusAnimation.fillMode = CAMediaTimingFillMode.forwards
        cornerRadiusAnimation.isRemovedOnCompletion = false
        cornerRadiusAnimation.duration = self.animationDuraion
    
        let finalRadius = (self.ViewRadius - self.innerBorder*4)/2
        if self.innerButton.isSelected {
            
            UIView.animate(withDuration: self.animationDuraion) {
                let centerPoint = self.convert(self.innerButton.center, to: self)
                self.innerButton.frame = CGRect.init(x: centerPoint.x-CGFloat(finalRadius)/2, y: centerPoint.y-CGFloat(finalRadius)/2, width: CGFloat(finalRadius), height: CGFloat(finalRadius))
            }
            cornerRadiusAnimation.fromValue = self.innerButton.layer.cornerRadius
            cornerRadiusAnimation.toValue = 5

        }else{
            UIView.animate(withDuration: self.animationDuraion) {
                self.innerButton.frame = CGRect.init(x: CGFloat(self.innerBorder*2), y: CGFloat(self.innerBorder*2), width: CGFloat(finalRadius)*2, height: CGFloat(finalRadius)*2)
            }
            cornerRadiusAnimation.fromValue = 5
            cornerRadiusAnimation.toValue = self.innerButton.layer.cornerRadius
        }
        
        self.innerButton.layer.add(cornerRadiusAnimation, forKey:"cornerRadius")
    }
}
