//
//  PlayerView.swift
//  05-MediaPlayer
//
//  Created by dzw on 2019/5/31.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

enum RotateDirection {
    case left
    case right
    case up
}

enum DragDirection {
    case none
    case horizontal
    case vertical
}

enum ProgressChangeType {
    case panGuesture
    case sliderPan
    case sliderTap
}

class PlayerView: UIView, UIGestureRecognizerDelegate {
    
    var totalTime = 0
    var currentTime = 0
    
    // MARK:- 控件
    lazy var player: AVPlayer = {
        return AVPlayer()
    }()
    var playerItem: AVPlayerItem?
    var lastPlayerItem: AVPlayerItem?
    var playerLayer = AVPlayerLayer()
    
    private var toolBarView = Bundle.main.loadNibNamed("ToolBarView",
                                                       owner: self, options: nil)?.first as! ToolBarView

    private var defaultSlider = UISlider()
    private let lightSlider = UISlider()
    private let volumeSlider = UISlider()
    private var loadingView = UIActivityIndicatorView()
    private var coverView = UIView()

    var panGesture = UIPanGestureRecognizer()
    
    private var contentView = UIView()
    private var customFarme = CGRect()

    private let initTimeString = "00:00"
    
    // MARK:- 变量属性控制
    private var toolBarTimer: Timer?
    private var isFullScreen = false
    private var firstPoint = CGPoint()
    private var secondPoint = CGPoint()
    private var isDragging = false
    private let DisapperAnimateDuration = 0.5
    private var dragDirection: DragDirection?
    
    // MARK:- 初始化
    init(frame: CGRect, contentView: UIView) {
        
        super.init(frame: frame)
        self.frame = frame
        self.contentView = contentView
        customFarme = frame
        backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        playerLayer.player = nil
        invalidateToolBarTimer()
    }
    
    // MARK:- UI
    fileprivate func makeUI() {
        configLayoutSubViews()
        configSlider()
        configGesture()
        invalidateToolBarTimer()
        setUpToolBarTimer()
    }
    
    private func configLayoutSubViews() {
        
        // 播放器layer
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(playerLayer)
        
        coverView = UIView(frame:(CGRect(x: 0, y: playerLayer.frame.minY, width: playerLayer.frame.width, height: playerLayer.frame.height)))
        self.addSubview(coverView)
        
        
        
        toolBarView.frame = CGRect(x: 0, y: coverView.height-toolBarViewH, width: coverView.width, height: toolBarViewH)
        toolBarView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        toolBarView.delegate = self
        coverView.addSubview(toolBarView)
        
        loadingView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.white)
        loadingView.center = coverView.center
        self.addSubview(loadingView)
    }
    
    //MARK: - 添加子控件
    private func configSlider() {
        
        //亮度滑块
        lightSlider.isHidden = true
        lightSlider.minimumValue = 0
        lightSlider.maximumValue = 1
        lightSlider.value = Float(UIScreen.main.brightness)
        self.addSubview(lightSlider)
        
        // 系统
        let volumeView = MPVolumeView(frame: CGRect(x: -3000, y: -1000, width: 100, height: 100))
        volumeView.sizeToFit()
        self.addSubview(volumeView)
        for view in volumeView.subviews {
            if (view.superclass?.isSubclass(of: UISlider.classForCoder()) == true) {
                defaultSlider = view as! UISlider
            }
        }
        defaultSlider.isHidden = true
        defaultSlider.autoresizesSubviews = false
        defaultSlider.autoresizingMask = UIView.AutoresizingMask()
        self.addSubview(defaultSlider)
        
        //设置声音滑块
        volumeSlider.isHidden = true
        volumeSlider.minimumValue = defaultSlider.minimumValue
        volumeSlider.maximumValue = defaultSlider.maximumValue
        volumeSlider.value = defaultSlider.value
        self.addSubview(volumeSlider)
    }
  
    
 
    private func configGesture() {
        
        // 屏幕点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapGes(tap:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        // 屏幕滑动手势
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(viewPanGes(pan:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
    }
 
}


extension PlayerView {
    
    // MARK:- 手势
 
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view?.isKind(of: UISlider.self) == true {
            return false
        }
        return true
    }
    
    // 屏幕点击手势
    @objc func viewTapGes(tap: UITapGestureRecognizer) {
        
        if coverView.alpha == 1 {
            invalidateToolBarTimer()
            hiddenToolBar()
        } else if coverView.alpha == 0 {
            setUpToolBarTimer()
        }
    }
    
    // 屏幕滑动手势
    @objc func viewPanGes(pan: UIPanGestureRecognizer) {
        
        if pan.state == UIGestureRecognizer.State.began {
            
            isDragging = true
            dragDirection = .none
            
            invalidateToolBarTimer()
            showToolBar()
            
            firstPoint = pan.location(in: self)
            volumeSlider.value = defaultSlider.value
            
        } else if pan.state == UIGestureRecognizer.State.ended {
            
            isDragging = false
            setUpToolBarTimer()
            playVideo()
            
        } else if pan.state == UIGestureRecognizer.State.changed {
            
            secondPoint = pan.location(in: self)
            
            let horValue = abs(firstPoint.x - secondPoint.x)
            let verValue = abs(firstPoint.y - secondPoint.y)
            
            if dragDirection == .none {
                if horValue > verValue {
                    dragDirection = .horizontal
                } else {
                    dragDirection = .vertical
                }
            }
            
            if dragDirection == .horizontal { // 左右滑动 调节视频的播放进度
                pauseVideo()
                changeVideoProgress(changeType: .panGuesture)
            
            } else if dragDirection == .vertical { // 上下滑动 调节音量或者亮度
                changeVolumeOrLight()
            }
            firstPoint = secondPoint
        }
    }
    
}


extension PlayerView {
    
    // MARK:- 全屏模式切换
    // 半屏
    func originalScreen() {
        
        isFullScreen = false
        
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform.identity
        })
        self.frame = customFarme
        playerLayer.frame = CGRect(x: 0, y: 0, width: customFarme.size.width, height: customFarme.size.height)
        contentView.addSubview(self)
        
        _ = self.subviews.map (
            { $0.removeFromSuperview() }
        )
        makeUI()
    }
    
    // 全屏
    func fullScreenWithDirection(_ direction: RotateDirection ,animate: Bool) {
        
        isFullScreen = true
        window?.addSubview(self)
        
        if animate == true{
            UIView.animate(withDuration: 0.25, animations: {
                if direction == RotateDirection.left {
                    self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                } else if direction == RotateDirection.right {
                    self.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi/2))
                }
            })
        }
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        playerLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_HEIGHT, height: SCREEN_WIDTH)
        
        _ = self.subviews.map (
            { $0.removeFromSuperview() }
        )
        makeUI()
    }
    
    // MARK: 刷新监听
    func refreshShowValues() {
        
        let durationT = playerItem?.duration.value ?? 0
        let timescaleT = playerItem?.duration.timescale ?? 0
        if (TimeInterval(durationT) == 0) || (TimeInterval(timescaleT) == 0) {
            return
        }
        guard let currentT = playerItem?.currentTime() else {
            return
        }
        if CMTimeGetSeconds(currentT).isNaN {
            return
        }
        if isDragging == false {
            let currentTime = CMTimeGetSeconds(currentT)
            refreshTimeLabelValue(CMTimeMake(value: Int64(currentTime), timescale: 1))
            toolBarView.progressSlider.value = Float(TimeInterval(currentTime) / (TimeInterval(durationT) / TimeInterval(timescaleT)))
        }
        if (player.status == AVPlayer.Status.readyToPlay) {
            stopLoadingAnimation()
        } else {
            startLoadingAnimation()
        }
    }
    // 刷新显示时间
    @discardableResult
    func refreshTimeLabelValue(_ time: CMTime) -> String {
        
        let timescale = playerItem?.duration.timescale ?? 0
        if Int64(timescale) == 0 || CMTimeGetSeconds(time).isNaN {
            invalidPlayURL()
            return String(format: "%02ld:%02ld", 0, 0)
        }
        
        // 当前时长进度progress
        let proMin = Int64(CMTimeGetSeconds(time)) / 60
        let proSec = Int64(CMTimeGetSeconds(time)) % 60
        // duration 总时长
        let durationT = playerItem?.duration.value ?? 0
        let durMin = Int64(durationT) / Int64(timescale) / 60
        let durSec = Int64(durationT) / Int64(timescale) % 60
        
        let leftTimeStr = String(format: "%02ld:%02ld", proMin, proSec )
        let rightTimeStr = String(format: "%02ld:%02ld", durMin, durSec )
        
        toolBarView.leftTimeLabel.text = leftTimeStr
        toolBarView.rightTimeLabel.text = rightTimeStr
        totalTime = Int(durMin * 60 + durSec)
        currentTime = Int(proMin * 60 + proSec)
        
        return rightTimeStr
    }
}


extension PlayerView {
    
    // MARK: 控件逻辑处理方法
    // 计算缓冲进度
    fileprivate func availableDuration() -> TimeInterval {
        
        guard let timeRange = playerItem?.loadedTimeRanges.first?.timeRangeValue else {
            return 0
        }
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSeconds = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSeconds
        return result
    }
    
    // 调节视频进度
    fileprivate func changeVideoProgress(changeType: ProgressChangeType) {
        
        let timescaleT = playerItem?.duration.timescale ?? 0
        if timescaleT == 0 {
            return
        }
        playerItem?.cancelPendingSeeks()
        
        if changeType == .panGuesture { // 通过屏幕手势拖拽
            toolBarView.progressSlider.value -= Float((firstPoint.x - secondPoint.x) / 300)
        }
        
        let durationT = playerItem?.duration.value ?? 0
        let total = Float64(durationT) / Float64(timescaleT)
        let dragedSeconds = floorf(Float(total * Float64(toolBarView.progressSlider.value)))
        let dragedCMTime = CMTimeMake(value: Int64(dragedSeconds), timescale: 1)

        refreshTimeLabelValue(dragedCMTime)
        DispatchQueue.main.async {
            self.seekToVideo(Int(dragedSeconds))
        }
    }
    
    // 调节音量或者亮度
    fileprivate func changeVolumeOrLight() {
        
        var value = 0 as CGFloat
        if isFullScreen == true {
            value = self.height * 0.5
        } else {
            value = self.width * 0.5
        }
        
        if (firstPoint.x <= value) { // 左边调节屏幕亮度
            lightSlider.value += Float((firstPoint.y - secondPoint.y) / 300.0)
            UIScreen.main.brightness = CGFloat(lightSlider.value)
        } else { //右边调节音量
            defaultSlider.value += Float((firstPoint.y - secondPoint.y) / 300.0)
            volumeSlider.value = defaultSlider.value
        }
    }
}


extension PlayerView {
    func playVideo() {
        player.play()
        toolBarView.playButton.isSelected = true
    }
    
    func pauseVideo() {
        
        player.pause()
        toolBarView.playButton.isSelected = false
    }
    
    // 调整视频进度
    func seekToVideo(_ startTime: Int) {
        let time = startTime < 0 ? 0 : startTime
        // 定位精度较差，但是性能比较高
//        player.seek(to: CMTimeMakeWithSeconds(Float64(time), 1))
        // 定位最为精确，但是性能很差
        player.seek(to: CMTimeMakeWithSeconds(Float64(time), preferredTimescale: 1), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    
    func invalidPlayURL() {
        player.replaceCurrentItem(with: nil)
        stopLoadingAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pauseVideo()
            self.toolBarView.leftTimeLabel.text = self.initTimeString
            self.toolBarView.rightTimeLabel.text = self.initTimeString
            self.toolBarView.progressSlider.value = 0
        }
    }
    
    func startLoadingAnimation() {
        loadingView.startAnimating()
    }
    
    func stopLoadingAnimation() {
        loadingView.stopAnimating()
    }
    
    // 设置缓冲条进度
    func setProgressValue() {
        
        let timeInterval = availableDuration()
        guard let duration = playerItem?.duration else {
            return
        }
        if CMTimeGetSeconds(duration).isNaN {
            return
        }
        let totalDuration = CMTimeGetSeconds(duration)
        if TimeInterval(totalDuration) == 0 {
            return
        }
        toolBarView.progressView.setProgress(Float(TimeInterval(timeInterval) / TimeInterval(totalDuration)), animated: false)
    }
    
    func setUpToolBarTimer() {
        showToolBar()
        toolBarTimer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(hiddenToolBar), userInfo: nil, repeats: false) // 6秒后自动隐藏
        RunLoop.current.add(toolBarTimer!, forMode: RunLoop.Mode.default)
    }
    
    // 释放工具条消失的定时器
    func invalidateToolBarTimer() {
        toolBarTimer?.invalidate()
        toolBarTimer = nil
    }
    
    // 工具栏
    func showToolBar() {
        if isFullScreen {
            UIView.animate(withDuration: DisapperAnimateDuration, animations: {
                self.coverView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: DisapperAnimateDuration, animations: {
                self.coverView.alpha = 1
            })
        }
    }
    @objc func hiddenToolBar() {
        if isFullScreen {
            UIView.animate(withDuration: DisapperAnimateDuration, animations: {
                self.coverView.alpha = 0
            })
        } else {
            UIView.animate(withDuration: DisapperAnimateDuration, animations: {
                self.coverView.alpha = 0
            })
        }
    }
}

extension PlayerView:ToolBarDelegate{
    func fullScreenAction(sender: UIButton){
        if isFullScreen == false {
            fullScreenWithDirection(RotateDirection.left, animate: true)
        } else {
            originalScreen()
        }
    }
    func startAction(sender: UIButton){
        if sender.isSelected == true {
            pauseVideo()
        } else {
            playVideo()
        }
    }
    func lockAction(sender: UIButton){
        print(sender.isSelected)
        if sender.isSelected {
            panGesture.removeTarget(self, action: #selector(viewPanGes(pan:)))
        }else{
            panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(viewPanGes(pan:)))
            panGesture.delegate = self
            self.addGestureRecognizer(panGesture)
        }
    }
    
    func slideIsDraging(sender: UISlider){
        if player.status == AVPlayer.Status.readyToPlay {
            
            changeVideoProgress(changeType: .sliderPan)
        }
    }
    func sliderStartDrag(sender: UISlider){
        invalidateToolBarTimer()
        showToolBar()
        
        isDragging = true
        pauseVideo()

    }
    func sliderEndDrag(sender: UISlider){
        
        isDragging = false
        setUpToolBarTimer()
        playVideo()
    }

    
}
