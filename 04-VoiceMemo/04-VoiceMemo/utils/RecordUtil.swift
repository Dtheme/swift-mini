//
//  RecordUtil.swift
//  04-VoiceMemo
//
//  Created by dzw on 2019/5/19.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit
import AVFoundation

public class RecordUtil: NSObject {
    
    
    var audioPlayer: AVAudioPlayer!
    var audioFileName: String = ""
    
    //Audio
    var audioRecorder: AVAudioRecorder!
    let audioSession = AVAudioSession.sharedInstance()
    var isAllowed:Bool = false
    
    // Timer
    var count = 0
    let timer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),//编码格式
        AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]//音频质量
    
    public override init() {
        super.init()
        checkPermission()
        createAudioRecorder()
        createTimer()
        timer.suspend()
    }
    //MARK: audio init
    func createAudioRecorder() {
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioRecorder = AVAudioRecorder(url: self.ht_directoryURL(), settings: recordSettings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch let error {
            print(error)
        }
    }
    
    func checkPermission() {
        audioSession.requestRecordPermission { (allowed) in
            if !allowed {
                self.isAllowed = false
            }else {
                self.isAllowed = true
            }
        }
    }
    
    //MARK: 播放相关
    public func startPlay() {
        if !audioRecorder.isRecording {
            do {
                let url:URL? = audioRecorder.url
                if let url = url {
                    try audioPlayer = AVAudioPlayer(contentsOf: url)
                    audioPlayer.delegate = self
                    audioPlayer.play()
                }
            }catch let error {
                print(error)
            }
        }
    }
    
    public func pausePlay() {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            if !audioRecorder.isRecording {
                audioPlayer.pause()
            }
        }
    }
    
    public func stopPlay() {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            if !audioRecorder.isRecording {
                audioPlayer.stop()
            }
        }
    }
    
    //MARK: 录音相关
    //开始录音
    public func startRecord() {
        //如果正在播放，那么先停止当前的播放器
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        //判断是否正在录音，如果没有那么开始录音
        if !audioRecorder.isRecording {
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
                fireTimer()
            }catch let error {
                print(error)
            }
        }
    }
    
    //停止录音
    public func stopRecord() {
        if audioRecorder.isRecording {
            audioRecorder.stop()
            do {
                try audioSession.setActive(false)
                stopTimer()
            }catch let error {
                print(error)
            }
        }
    }
    
    //MARK: Timer
    func createTimer() {
        timer.schedule(wallDeadline: .now(), repeating: 1.0)
        timer.setEventHandler {
            print("timer")
            self.count = self.count + 1
            print(self.count)
        }
        timer.resume()
    }
    
    func fireTimer() {
        count = 0
        self.timer.resume()
    }
    
    func pauseTimer() {
        self.timer.suspend()
    }
    
    func stopTimer() {
        self.timer.suspend()
        count = 0
    }
    
    //暂停录制
    func pauseRecord() {
        if audioRecorder.isRecording {
            audioRecorder.pause()
        }
    }
    
    //恢复录制
    func resumeRecoder() {
        if !audioPlayer.isPlaying {
            self.startRecord()
        }
    }
    
    //获取默认文件存放地址
    func ht_directoryURL() -> URL {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        
        let recordingName = formatter.string(from: currentDateTime) + ".caf"
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docDir = urls[0]
        
        let soundURL = docDir.appendingPathComponent(recordingName)
        return soundURL
    }
}

extension RecordUtil: AVAudioRecorderDelegate {
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        
    }
    
    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("\(String(describing: error))")
    }

    public func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder) {
        
    }

    public func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int) {
        
    }
}

extension RecordUtil: AVAudioPlayerDelegate {
    
}
