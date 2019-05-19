//
//  SlideView.swift
//  04-VoiceMemo
//
//  Created by dzw on 2019/5/18.
//  Copyright © 2019 dzw. All rights reserved.
//


//  最后整理一下代码


import UIKit

enum SliderHeight {
    case low
    case medium
}

class SlideView: UIView {
    
    lazy var mediumPosition = UIScreen.main.bounds.size.height / 5 * 3
    lazy var lowPosition = UIScreen.main.bounds.size.height - 150
    var currentSliderHeight: SliderHeight = .low
    
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var volumView: SpectrumView!
    
    @IBOutlet weak var recordButton: RecordButton!
    
    
    override func awakeFromNib() {
        configSubviews()
        configSwipeGesture()
    }
    private func configSubviews() {
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = CACornerMask(rawValue: CACornerMask.layerMinXMinYCorner.rawValue | CACornerMask.layerMaxXMinYCorner.rawValue)
        self.layer.masksToBounds = true
        self.backgroundColor = #colorLiteral(red: 0.1880786121, green: 0.1965952218, blue: 0.1674754918, alpha: 1)
        
        titleTF?.backgroundColor = #colorLiteral(red: 0.1880786121, green: 0.1965952218, blue: 0.1674754918, alpha: 1)
        titleTF?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleTF?.textAlignment = NSTextAlignment.center
        titleTF?.attributedPlaceholder = NSAttributedString.init(string:"给声音一个名字吧", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        titleTF?.delegate = self
        titleTF?.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium)

        timeLabel?.backgroundColor = #colorLiteral(red: 0.1880786121, green: 0.1965952218, blue: 0.1674754918, alpha: 1)
        timeLabel?.textColor = UIColor.lightGray
        timeLabel?.textAlignment = NSTextAlignment.center
        timeLabel?.text = "2019年05月18日20:54:15"

        volumView?.backgroundColor = UIColor.orange

        recordButton?.action = { [unowned self](sender) in
            self.recordButton.startButtonAnimation()
            if sender.isSelected {
                //展开
                self.animateSlider(targetPosition: self.mediumPosition) { (_) in}
                
            }else{
                
                //收起
                self.animateSlider(targetPosition: self.lowPosition) { (_) in }
            }
            self.layoutIfNeeded()
        }
        
        self.updateSubviews()
    }
    
    
    
    private func configSwipeGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .up {
            if currentSliderHeight == .low {

                //                delegate?.animateTemperatureLabel(targetPosotion: mediumPosition, targetHeight: .medium)

                animateSlider(targetPosition: mediumPosition) { (_) in }
            }
            
        } else if gesture.direction == .down {
            if currentSliderHeight == .medium {
                animateSlider(targetPosition: lowPosition) { (_) in }
            }
        }
    }
    
    func animateSlider(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame = CGRect.init(x: self.frame.origin.x, y: targetPosition, width: self.frame.size.width, height: UIScreen.main.bounds.size.height - targetPosition)
            self.layoutIfNeeded()
            
            if targetPosition == self.lowPosition{
                self.currentSliderHeight = .low
            }else{
                self.currentSliderHeight = .medium
            }

            self.updateSubviews()
        }, completion: completion)
    }
    
    private func updateSubviews() {
        var needsHidden = false
        switch self.currentSliderHeight {
        case .low:
            needsHidden = true
            break
        case .medium:
            needsHidden = false
            break
        }
        
        indicatorView?.isHidden = needsHidden
        titleTF.isHidden = needsHidden
        timeLabel.isHidden = needsHidden
        volumView.isHidden = needsHidden
    }
    
}

extension SlideView: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

