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
    var selectedIndexPath : IndexPath? = IndexPath.init(item: 1000, section: 1000)
    
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
        self.configSlide()
        
        self.tableView?.register(UINib.init(nibName: "RecordListCell", bundle: nil), forCellReuseIdentifier: cellId)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordListCell") as! RecordListCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
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
