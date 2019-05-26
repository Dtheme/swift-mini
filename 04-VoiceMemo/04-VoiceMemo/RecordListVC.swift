//
//  ViewController.swift
//  04-VoiceMemo
//
//  Created by dzw on 2019/5/18.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox
import AVKit

class RecordListVC: UIViewController {
    
    let locationManager:CLLocationManager = CLLocationManager()
    var recordButton = RecordButton()
    var slider = SlideView()
    var tableView : UITableView?
    let cellId = "RecordListCell"
    var selectedIndexPath : IndexPath? = IndexPath.init(item: 1000, section: 1000)
    var dataSource : RecordArchiveTool?
    
    let achiPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/audioInfo.dat"
    /// 录音文件路径
    var recordPath = ""
    /// 录音器
    private var recorder: AVAudioRecorder!
    /// 录音器设置
    private let recorderSetting = [AVSampleRateKey : NSNumber(value: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),//编码格式
        AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]//声音质量
    /// 录音计时器
    private var timer: Timer?
    /// 声音数据数组
    private var soundMeters: [Float]!
    /// 录音时间
    private var recordTime = 0.00
    
    // 播放器
    var player: AVAudioPlayer!
    
    private var titleView = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 定位操作
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
        
        self.configTableView()
        self.tableView?.register(UINib.init(nibName: "RecordListCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        titleView = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        titleView.textAlignment = NSTextAlignment.center
        titleView.text = "test"
        titleView.alpha = 1
        self.navigationItem.titleView = titleView
        self.configSlide()

    }
    
    func configTableView() {
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 150), style: UITableView.Style.plain)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.tableFooterView = UIView.init()
        view.addSubview(self.tableView!)
    }
    
    func configSlide() {
        slider = Bundle.main.loadNibNamed("SlideView",
                                          owner: self, options: nil)?.first as! SlideView
        slider.frame = CGRect.init(x: 0, y: view.frame.height - 150, width: view.frame.width, height: 150)
        view.addSubview(slider)
        slider.recordAction = { () in
           print("record")
            self.configRecord()
            self.beginRecordVoice()
            let model = RecordArchiveTool.sharedInstance
            let dic = NSMutableDictionary.init()
            dic["url"] = self.directoryURL()
            dic["time"] = self.timeStr()
            dic["name"] = "\(self.recordPath)-\(self.timeStr() ?? "")"
            model.audioInfo.insert(dic.copy(), at: 0)
            
            NSKeyedArchiver.archiveRootObject(model, toFile: self.achiPath)
        }
        
        slider.stopAction = { () in
            print("stop")
            self.endRecordVoice()
            //        4.解档
            let audioModel = NSKeyedUnarchiver.unarchiveObject(withFile: self.achiPath) as! RecordArchiveTool
            print(audioModel.audioInfo)
        }
    }
 
    private func configRecord() {
        AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
            if !allowed {
                return
            }
        }
        let session = AVAudioSession.sharedInstance()
        do {
            
            try session.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.record)))
            
        }
        catch { print("session config failed") }
        do {
            self.recorder = try AVAudioRecorder(url: self.directoryURL()!, settings: self.recorderSetting)
            self.recorder.delegate = self
            self.recorder.prepareToRecord()
            self.recorder.isMeteringEnabled = true
        } catch {
            print(error.localizedDescription)
        }
        do { try AVAudioSession.sharedInstance().setActive(true) }
        catch { print("session active failed") }
    }
    
    //MARK: -  构建音频名称
    private func directoryURL() -> URL? {
        let time = self.timeStr()
        let currentFileName = "\(recordPath)-\(time ?? "")).m4a"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        return soundFileURL
    }
     //MARK: -  时间字符串
    private func timeStr() -> String?{
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd_HH:mm:ss"

        return format.string(from: Date())
    }
    
    private func reloadData(){
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: self.achiPath, isDirectory: &isDir) {
            let audioModel = NSKeyedUnarchiver.unarchiveObject(withFile: self.achiPath) as! RecordArchiveTool
            self.dataSource = audioModel
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }


    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView!.setEditing(editing, animated: true)
    }
}

extension RecordListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.audioInfo.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordListCell") as! RecordListCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let audioInfo : NSDictionary = dataSource?.audioInfo[indexPath.row] as! NSDictionary
        cell.updateCell(audioInfo: audioInfo)
        
        //MARK: -  播放相关
        cell.playAction = { [unowned self](url) in
            guard NSURL(string: url) != nil else {
                return//url不存在
            }
            do{
                //AVAudioSessionCategoryPlayback扬声器模式
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            }catch {
                print(error)
                return
            }
            //如果播放的音乐与之前的一样，则继续播放
            self.player?.play()
            do {
                self.player = try AVAudioPlayer(data: FileManager.default.contents(atPath: url)!)
                self.player?.prepareToPlay()
                self.player?.play()

            }catch {
                print(error)
            }
            
        }

        cell.pauseAction = { () in
            self.player.pause()
        }
        
        if selectedIndexPath == nil {
            cell.foldState(foldState: .isflod)
        }else{
            if indexPath.elementsEqual(selectedIndexPath!) {
                cell.foldState(foldState: .unfold)
            }else{
                cell.foldState(foldState: .isflod)
            }
            return cell
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath? = indexPath
        self.tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard selectedIndexPath != nil else {
            return 85
        }
        if indexPath.elementsEqual(selectedIndexPath!) {
            return 190
        }else{
            return 85
        }
    }
    
    //cell编辑状态
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 删除操作
        
    }
    
}

// 更新地理位置
extension RecordListVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currLocation:CLLocation = locations.last!
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation) { (placemarks, error) in
            if error != nil {
                print("\(String(describing: error))")
                return
            }
            
            if let place = placemarks?[0]{
                self.slider.titleTF.text = place.name
                self.recordPath = place.name!
            }
        }
    }
}

extension RecordListVC : UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minAlphaOffset:CGFloat = -88;
        let maxAlphaOffset:CGFloat = 50;
        let offset = scrollView.contentOffset.y;
        let alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
        titleView.alpha = 1 - alpha;
    }

}

fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

// MARK: - Record handlers
extension RecordListVC: AVAudioRecorderDelegate {
    
    /// 开始录音
    @objc private func beginRecordVoice() {
        if recorder == nil {
            return
        }
        soundMeters = [Float]()
        recorder.record()
        timer = Timer.scheduledTimer(timeInterval: Double(slider.volumView!.updateFequency), target: self, selector: #selector(updateMeters), userInfo: nil, repeats: true)
    }
    
    /// 停止录音
    @objc private func endRecordVoice() {
        recorder.stop()
        timer?.invalidate()
        view.isUserInteractionEnabled = true  //录音完了才能点击其他地方
        soundMeters.removeAll()
        self.reloadData()
    }
    
    
    @objc private func updateMeters() {
        recorder.updateMeters()
        recordTime += Double(slider.volumView!.updateFequency)
        addSoundMeter(item: recorder.averagePower(forChannel: 0))
        if recordTime >= 60.0 {
            endRecordVoice()
        }
    }
    
    private func addSoundMeter(item: Float) {
        let soundMeterCount = slider.volumView.soundMeterCount
        if soundMeters.count < soundMeterCount {
            soundMeters.append(item)
        } else {
            for (index, _) in soundMeters.enumerated() {
                if index < soundMeterCount - 1 {
                    soundMeters[index] = soundMeters[index + 1]
                }
            }
            // 插入新数据
            soundMeters[soundMeterCount - 1] = item
        }
        NotificationCenter.default.post(name: NSNotification.Name.init("updateMeters"), object: soundMeters)
    }
}
