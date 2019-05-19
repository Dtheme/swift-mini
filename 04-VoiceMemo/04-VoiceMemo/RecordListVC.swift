//
//  ViewController.swift
//  04-VoiceMemo
//
//  Created by dzw on 2019/5/18.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit
import  CoreLocation

class RecordListVC: UIViewController {
    
    let locationManager:CLLocationManager = CLLocationManager()
    var recordButton = RecordButton()
    var slider = SlideView()
    var tableView : UITableView?
    let cellId = "RecordListCell"
    private var titleView = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        ////发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
        self.configTableView()
        self.configSlide()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        titleView = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        titleView.textAlignment = NSTextAlignment.center
        titleView.text = "test"
        titleView.alpha = 1
        self.navigationItem.titleView = titleView
        
    }
    
    func configTableView() {
        self.tableView = UITableView.init(frame: view.bounds, style: UITableView.Style.plain)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        view.addSubview(self.tableView!)
    }
    
    func configSlide() {
        slider = Bundle.main.loadNibNamed("SlideView",
                                          owner: self, options: nil)?.first as! SlideView
        slider.frame = CGRect.init(x: 0, y: view.frame.height - 150, width: view.frame.width, height: 150)
        view.addSubview(slider)
        
    }
 
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView!.setEditing(editing, animated: true)
    }
}

extension RecordListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellId)
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        cell?.textLabel?.text = "2312"
        return cell!
    }

    //cell编辑状态
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
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
