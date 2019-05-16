//
//  ViewController.swift
//  03-RainbowSix
//
//  Created by dzw on 2019/5/14.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class AgentListVC: UIViewController {

    let cellId = "CardCell"
    
    let ScreenWidth = UIScreen.main.bounds.size.width
    let ScreenHeight = UIScreen.main.bounds.size.height
    var layout = CardLayout(itemSidelength: UIScreen.main.bounds.size.width*0.8, LineSpacing: 100)
    let cellImages = ["alibi","ash","buck","echo","mute","ying","ela","lesion"]
    var agentsData = NSMutableArray.init()
    
    var selectedCell: CardCell!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        self.title = "Agents"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置导航栏背景颜色
        self.navigationController!.navigationBar.barTintColor = UIColor(red:52.0/255.0, green:62.0/255.0, blue:72.0/255.0, alpha:255.0/255.0)
        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController!.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
        //item颜色
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
    }
    
    func loadData() {
        let path:String = Bundle.main.path(forResource: "Agents", ofType:"plist")!
        let data:Array<NSDictionary> = NSArray(contentsOfFile:path)! as! Array<NSDictionary>
//        let dicArr = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [[String:AnyObject]]
        //        将字典对象转化为字符串对象
        for dict in data {
            let A = Agent(name: dict["name"]! as! String, background: dict["background"]! as! String, psychological: dict["psychological"]! as! String, train: dict["train"]! as! String, experience: dict["experience"]! as! String)
            self.agentsData.add(A)
        }
//        let jsonData:Data = jsonString.data(using: .utf8)!
//
//        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
//        if dict != nil {
//            return dict as! NSDictionary
//        }
//        return NSDictionary()
        
    }
}

extension AgentListVC : UICollectionViewDelegate,UICollectionViewDataSource  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellImages.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CardCell
        let agentModel:Agent = self.agentsData[indexPath.row] as! Agent
        cell.bgImage?.image = UIImage(named:agentModel.name!.lowercased())
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedCell = collectionView.cellForItem(at: indexPath) as? CardCell
        let agentModel:Agent = self.agentsData[indexPath.row] as! Agent
        
        let vc = AgentInfoVC()
        vc.agentModel = agentModel
        self.navigationController?.pushViewController(vc, animated: true)

    }
}

extension AgentListVC : UINavigationControllerDelegate {
    
//    navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      
        if operation == UINavigationController.Operation.push {

            let transition = MagicMove()
            transition.type = .push
            return transition
        }
        return nil
    }
}
