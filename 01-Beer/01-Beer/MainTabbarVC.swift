//
//  MainTabbarVC.swift
//  01-Beer
//
//  Created by dzw on 2019/5/13.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class MainTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupChildVCWith(childVC: BeerListVC(), childTitle: "Beer", index: 0)
        self.setupChildVCWith(childVC: UsVC(), childTitle: "Us", index: 0)
    }
    
    func setupChildVCWith(childVC:UIViewController, childTitle:String,index:Int) {
        let navigation = UINavigationController(rootViewController: childVC)
        childVC.title = childTitle
        childVC.tabBarItem.tag = index
        self.addChild(navigation)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
