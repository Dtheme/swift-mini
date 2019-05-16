//
//  AddressBookListVC.swift
//  02-AddressBook
//
//  Created by dzw on 2019/5/13.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit
import Contacts

class AddressBookListVC: UIViewController{
    @IBOutlet weak var tableView: UITableView!
//    var contactData :[Person] = []
    var contactData : [String:[Person]] = [:]
    var titlesData : NSArray = NSArray.init()
    var headerView = ABlistHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        headerView = Bundle.main.loadNibNamed("ABlistHeaderView", owner: nil, options: nil)?.first as! ABlistHeaderView
        tableView.tableHeaderView = headerView
        headerView.addAction = { [unowned self](phoneNumber,name) in
            self.isEditing = true
            //添加到通讯录
            let store = CNContactStore()
            let contactToAdd = CNMutableContact()
            
            //名字
            contactToAdd.familyName = name
            
            //设置电话
            let mobileNumber = CNPhoneNumber(stringValue: phoneNumber)
            let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile,
                                             value: mobileNumber)
            contactToAdd.phoneNumbers = [mobileValue]
            
            let saveRequest = CNSaveRequest()
            saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
            
            do {
                try store.execute(saveRequest)
                let alertController = UIAlertController(title: "保存成功!",
                                                        message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                    action in
                    self.loadData()
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } catch {
                let alertController = UIAlertController(title: "保存失败!",
                                                        message: "\(error)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                    action in
                    self.loadData()
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let rightBtn=UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        rightBtn.setTitle("刷新", for: .normal)
        rightBtn.addTarget(self, action: #selector(loadData), for: UIControl.Event.touchUpInside)
        rightBtn.setTitleColor(UIColor.black, for: .normal)
        let item2=UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = item2
        
        loadData()
    }
    
    @objc func loadData()  {
        if ContactUtil.hasContactAuth() == true {
            self.contactData = ContactUtil.fetchOrderedContactData()//fetchOriginContactData()
            self.titlesData = self.getAllTitleKey()
            self.tableView.reloadData();
        }
    }
}

extension AddressBookListVC : UITableViewDelegate,UITableViewDataSource{
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key :String = titlesData[section] as! String
        let arr = contactData[key]
        return arr!.count
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return titlesData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
       
        let key :String = titlesData[indexPath.section] as! String
        let arr = contactData[key]
        let p = arr![indexPath.row]
        cell?.textLabel?.text = String(format: "%@ %@ %@", p.givenName!,p.middleName!,p.familyName!)

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key :String = titlesData[indexPath.section] as! String
        let arr = contactData[key]
        let p = arr![indexPath.row]
        
        let vc = AddressBookDetailVC()
        vc.pModel = p
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: -  Section Header

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (titlesData[section] as! String)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return (titlesData as! [String])
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
}

//MARK: -  private
extension AddressBookListVC {
    private func getAllTitleKey()->NSArray {
        let arr : NSArray = Array(contactData.keys) as NSArray
        let res = arr.sortedArray(using: #selector(NSNumber.compare(_:))) as NSArray
        return res
    }
}
