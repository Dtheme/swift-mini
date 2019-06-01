//
//  ViewController.swift
//  05-MediaPlayer
//
//  Created by dzw on 2019/5/31.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit
import CoreMedia

class ViewController: UIViewController, PlayUtilDelegate {

    var playerManager: PlayUtil!
    
    lazy var videoBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.orange
        btn.tag = 1
        btn.setTitle("本地视频", for: .normal)
        btn.addTarget(self, action: #selector(changeVideo(btn:)), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: self.playerManager.playerView.bottom + 50, width: 100, height: 30)
        btn.centerX = self.view.centerX
        return btn
    }()
    
    lazy var videoBtn2: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.orange
        btn.tag = 2
        btn.setTitle("在线视频", for: .normal)
        btn.addTarget(self, action: #selector(changeVideo(btn:)), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: self.videoBtn.bottom + 50, width: 100, height: 30)
        btn.centerX = self.view.centerX
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // 添加视频播放器
        playerManager = PlayUtil(playerFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 210), contentView: self.view)
        view.addSubview(playerManager.playerView)
        
        // 添加视频切换按钮
        view.addSubview(videoBtn)
        view.addSubview(videoBtn2)
        
        playerManager.delegate = self
        playerManager.playUrlStr = Bundle.main.path(forResource: "mix", ofType: "mp4")
        playerManager.seekToTime(5)// 跳转至第N秒的进度位置，从头播放则是0
        playerManager.play()
    }
    // 切换播放视频
    @objc func changeVideo(btn: UIButton) {
        
        let urlStr: String
        let startTime: Int
        if btn.tag == 1 {
            urlStr = Bundle.main.path(forResource: "mix", ofType: "mp4")!
            startTime = 35
        } else if btn.tag == 2 {
            urlStr = "https://qiniu-xpc9.vmoviercdn.com/5cd517d6baed5.mp4"
            startTime = 15
        } else {
            urlStr = ""
            startTime = 0
        }
        // 传入要切换的播放地址和定位的时间(秒)
        playerManager.changePlayUrl(urlStr, startTime: startTime)
    }
    
    func test() {
        // 获取播放视频的当前进度时间和总时间
        let currentTime = playerManager.getCurrentTime()
        let totalTime = playerManager.getTotalTime()
        print(currentTime, totalTime)
    }
    
    // push跳转
    @objc func jumpToViewController() {
        
        playerManager.pause()
        navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    
    // MARK:- PlayerManagerDelegate
    // 返回按钮点击回调
    func playerViewBack() {
        navigationController?.popViewController(animated: true)
    }
 
    // 播放完成回调
    func playFinished() {
        print("播放完了😁")
    }

}

