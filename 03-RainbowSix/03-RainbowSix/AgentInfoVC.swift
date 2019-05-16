//
//  AgentInfoVC.swift
//  03-RainbowSix
//
//  Created by dzw on 2019/5/15.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class AgentInfoVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var headerView : UIImageView?
    var agentModel : Agent?
    var headerImage : String?
    let cellId = "AgentInfoCell"
    let sectionTitle = ["背景","心理状态档案","训练","经历"]
    let isFoldFlags:NSMutableArray = [true,true,true,true]
    
    private let headerviewH: CGFloat = UIScreen.main.bounds.size.height
    private let navigationH: CGFloat = 44
    private let statusH: CGFloat = 20
    private var percentTransition: UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = headerImage?.uppercased()
        
        //图片
        self.headerImage = agentModel!.name!.lowercased()
        
        headerView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.self.width, height: UIScreen.main.bounds.self.width))
        headerView?.image = UIImage.init(named: headerImage!)
        tableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView.init()
        tableView.rowHeight = UITableView.automaticDimension
        self.navigationController?.delegate = self
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture(edgePan:)))
        edgePan.edges = UIRectEdge.left
        self.view.addGestureRecognizer(edgePan)
    }
    
    @objc func edgePanGesture(edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = edgePan.translation(in: self.view).x / self.view.bounds.width
        
        if edgePan.state == UIGestureRecognizer.State.began {
            self.percentTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewController(animated: true)
        } else if edgePan.state == UIGestureRecognizer.State.changed {
            self.percentTransition?.update(progress)
        } else if edgePan.state == UIGestureRecognizer.State.cancelled || edgePan.state == UIGestureRecognizer.State.ended {
            if progress > 0.5 {
                self.percentTransition?.finish()
            } else {
                self.percentTransition?.cancel()
            }
            self.percentTransition = nil
        }
    }
}

extension AgentInfoVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! AgentInfoCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.infoLabel?.text = agentModel?.psychological
        switch indexPath.section {
        case 0:
            cell.infoLabel?.text = agentModel?.background
            break
        case 1:
            cell.infoLabel?.text = agentModel?.psychological
            break
        case 2:
            cell.infoLabel?.text = agentModel?.train
            break
        case 3:
            cell.infoLabel?.text = agentModel?.experience
            break
        default:
            break
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count: Int
        if self.isFoldFlags[section] as! Bool == true {
            count = 0
        }else{
            count = 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("AgentInfoSectionHeader",
                                                  owner: self, options: nil)?.first as! AgentInfoSectionHeader
//        headerView.didSelectSectionBtn.isSelected = isFoldFlags[section] as! Bool
        headerView.updateView(title: self.sectionTitle[section],isFold: isFoldFlags[section] as! Bool)
  
        headerView.didSelect = { [unowned self](sender)  in
            
            if sender.isSelected == true {
                self.isFoldFlags[section] = true
            }else{
                self.isFoldFlags[section] = false
            }
            self.tableView.reloadSections(NSIndexSet.init(index: section) as IndexSet, with: .fade)
        }
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

}

extension AgentInfoVC:UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationController.Operation.pop {
            let transition = MagicMove()
            transition.type = .pop
            return transition
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is AgentListVC {
            return self.percentTransition
        } else {
            return nil
        }
    }
}
 
