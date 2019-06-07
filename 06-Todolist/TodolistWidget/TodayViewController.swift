//
//  TodayViewController.swift
//  TodolistWidget
//
//  Created by dzw on 2019/6/4.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let identifier = "TodolistCell"
    let tasks:[String] = ["吃一块那么大鸡排","吃一顿早饭","看一篇英文博客","写一个demo","刷一道leetcode","刷一部电影","解决一个小问题"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode:
        NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        let expanded = activeDisplayMode == .compact
        preferredContentSize = expanded ? maxSize : CGSize(
            width: maxSize.width, height: CGFloat(tasks.count*44))
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: identifier) as! TodolistCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.infoLabel?.text = tasks[indexPath.row]
        cell.didSelectCheckMark =  { (sender:UIButton) in
            if sender.isSelected {
                let previousStr = String(cell.infoLabel.text!)
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: previousStr, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15.0)])
                attributeString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(0, attributeString.length))
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSRange(location:0,length:attributeString.length))
                cell.infoLabel.attributedText = attributeString
            }else{
                let previousStr = String(cell.infoLabel.text!)
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: previousStr, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14, weight: .light)])
                attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:attributeString.length))
                cell.infoLabel.attributedText = attributeString
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
}
