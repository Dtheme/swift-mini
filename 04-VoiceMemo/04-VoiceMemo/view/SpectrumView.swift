//
//  MCVolumeView.swift
//  MCChatHUD
//
//  Created by duwei on 2018/1/30.
//  Copyright © 2018年 Dywane. All rights reserved.
//

import UIKit

class SpectrumView: UIView {

    // 声音表数组
    private var soundMeters: [Float]!
    /// 声音数据数组容量
    public let soundMeterCount = 60 
    /// 波形更新间隔
    public let updateFequency = 0.05
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = UIColor.clear
//        contentMode = .redraw   //内容模式为重绘，因为需要多次重复绘制音量表
//        NotificationCenter.default.addObserver(self, selector: #selector(updateView(notice:)), name: NSNotification.Name.init("updateMeters"), object: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        contentMode = .redraw   //内容模式为重绘，因为需要多次重复绘制音量表
        NotificationCenter.default.addObserver(self, selector: #selector(updateView(notice:)), name: NSNotification.Name.init("updateMeters"), object: nil)
    }
    
    override func draw(_ rect: CGRect) {
        if soundMeters != nil && soundMeters.count > 0 {
            let noVoice = -66.0     // 该值代表低于-46.0的声音都认为无声音
            
            let margin = Int(UIScreen.main.bounds.size.width/CGFloat(soundMeterCount))
            for (index,item) in soundMeters.enumerated() {
                var columnX:CGFloat = 0.0
                if soundMeters.count < soundMeterCount{
                    columnX = CGFloat((soundMeterCount - (soundMeters.count-index)) * margin)
                }else{
                    columnX = CGFloat(index * margin)
                }

                let self_h = CGFloat(self.frame.size.height)
                let barHeight:CGFloat = CGFloat((Double(item) - noVoice)/2)
                let rowY = CGFloat(self_h/2 - barHeight)
                let rectanglePath = UIBezierPath.init(rect: CGRect.init(x: columnX, y:rowY , width: 3, height: barHeight))
                let mirrorPath = UIBezierPath.init(rect: CGRect.init(x: columnX, y: self_h/2, width: 3, height: barHeight))

                UIColor.white.setFill()
                rectanglePath.fill()

                UIColor.init(white: 1, alpha: 0.5).setFill()
                mirrorPath.fill()
            }
        }
    }
    
    @objc private func updateView(notice: Notification) {
        soundMeters = notice.object as? [Float]
        setNeedsDisplay()
    }
}
