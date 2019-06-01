//
//  ToolBarView.swift
//  05-MediaPlayer
//
//  Created by dzw on 2019/6/1.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

protocol ToolBarDelegate {
    func slideIsDraging(sender: UISlider)
    func sliderStartDrag(sender: UISlider)
    func sliderEndDrag(sender: UISlider)
    func fullScreenAction(sender: UIButton)
    func startAction(sender: UIButton)
    func lockAction(sender: UIButton)
}

class ToolBarView: UIView {

     var delegate : ToolBarDelegate?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var rightTimeLabel: UILabel!
    @IBOutlet weak var fullScreenButton: UIButton!

    private let ProgressColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:1) //进度条颜色
    private let ProgressTintColor = UIColor(red:221.0/255.0, green:221.0/255.0, blue:221.0/255.0, alpha:1) //缓冲颜色
    private let PlayFinishColor = UIColor(red:252.0/255.0, green:106.0/255.0, blue:125.0/255.0, alpha:1) //播放完成颜色

    override func awakeFromNib() {
        super.awakeFromNib()
        configSubviews()
        
    }
    
    private func configSubviews() {
        leftTimeLabel.font = UIFont.systemFont(ofSize: 12.0 * SCREEN_WIDTH / 375.0)
        rightTimeLabel.font = leftTimeLabel.font
        
        progressView.trackTintColor = ProgressColor
        progressView.progressTintColor = ProgressTintColor

        var image = UIImage(named: "round")
        UIGraphicsBeginImageContext(CGSize(width: SCALE_WIDTH(15), height: SCALE_WIDTH(15)))
        draw(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = scaledImage
        progressSlider.setThumbImage(image, for: UIControl.State.normal)
        progressSlider.thumbRect(forBounds: CGRect.init(x: 0, y: 0, width: 10, height: 10), trackRect: progressSlider.bounds, value: progressSlider.value)
        
    }
    @IBAction func slideIsDraging(_ sender: UISlider) {
        delegate?.slideIsDraging(sender: sender)
    }
    
    @IBAction func sliderStartDrag(_ sender: UISlider) {
        delegate?.sliderStartDrag(sender: sender)
    }
    @IBAction func sliderEndDrag(_ sender: UISlider) {
        delegate?.sliderEndDrag(sender: sender)
    }
    
    @IBAction func fullScreenAction(_ sender: UIButton) {
        delegate?.fullScreenAction(sender: sender)
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        delegate?.startAction(sender: sender)
    }
    
    @IBAction func lockAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        updateSubviews(isEnable: !sender.isSelected)
        delegate?.lockAction(sender: sender)
    }

    private func updateSubviews(isEnable:Bool) {
        playButton.isUserInteractionEnabled = isEnable
        progressView.isUserInteractionEnabled = isEnable
        progressSlider.isUserInteractionEnabled = isEnable
    }

}
