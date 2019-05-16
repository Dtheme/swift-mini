//
//  AddressBookDetailVC.swift
//  02-AddressBook
//
//  Created by dzw on 2019/5/14.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit
import MessageUI
import Contacts

class AddressBookDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pModel : Person?
    var detailHeaderView : ABdetailHeaderView?
    let cellId = "ABDetailCell"
    let titles = ["电话号码","地址"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.detailHeaderView = ABdetailHeaderView()
        self.tableView.estimatedSectionFooterHeight = 200
        
        tableView.register(UINib.init(nibName: "ABDetailCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableHeaderView = self.detailHeaderView
        tableView.tableFooterView = UIView.init()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        detailHeaderView?.updateView(model: self.pModel!)
        detailHeaderView?.callAction = { [unowned self]()->Void in
            let cnPN = self.pModel?.phoneNumber?.first?.value
            let phoneNumebr = cnPN?.stringValue
            var url = NSURL.init()
            if phoneNumebr != nil{
                url = NSURL(string :"tel://"+"\(phoneNumebr!)")!
            }else{
                print("号码为空")
            }
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
        }
        
        detailHeaderView?.msgAction = { [unowned self]()->Void in
            if MFMessageComposeViewController.canSendText(){
                
                let cnPN = self.pModel?.phoneNumber?.first?.value
                let phoneNumebr = cnPN?.stringValue
                
                let controller = MFMessageComposeViewController()
                controller.body = "短信内容： xxxx"
                controller.recipients = ([phoneNumebr] as! [String])
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
            else{
                print("当前设备不能发送短信")
            }

        }
        self.tableView.reloadData()
    }
    
    
}

//MARK: -  UITableViewDelegate & UITableViewDataSource
extension AddressBookDetailVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ABDetailCell") as! ABDetailCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        switch indexPath.row {
        case 0:
            cell.titleLabel?.text = "电话号码"
            let cnPN = self.pModel?.phoneNumber?.first?.value
            let phoneNumebr = cnPN?.stringValue
            cell.infoLabel?.text = phoneNumebr
            
            break
        case 1:
            cell.titleLabel?.text = "地址"
            var str = ""
            if self.pModel?.postalAddresses?.count != 0 {
                let address = self.pModel?.postalAddresses?.first
                let detail = address!.value
                let contry = detail.value(forKey: CNPostalAddressCountryKey) ?? ""
                let state = detail.value(forKey: CNPostalAddressStateKey) ?? ""
                let city = detail.value(forKey: CNPostalAddressCityKey) ?? ""
                let street = detail.value(forKey: CNPostalAddressStreetKey) ?? ""
                let code = detail.value(forKey: CNPostalAddressPostalCodeKey) ?? ""
                str = "\(contry) \(state) \(city) \(street) \(code)"
            }

            if str == ""{
                cell.infoLabel?.text = "未设置地址"
            }else{
                cell.infoLabel?.text = str
            }

            
            break
        default:
            break
        }

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 110
        }else if indexPath.row == 1{
            return 150
        }
        return 110
    }
    
}

//MARK: -  MFMessageComposeViewControllerDelegate
extension AddressBookDetailVC : MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        switch result{
        case .sent:
            print("短信已发送")
        case .cancelled:
            print("短信取消发送")
        case .failed:
            print("短信发送失败")
        default:
            break
        }
    }
}
