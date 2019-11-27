//
//  HomeVC.swift
//  07-UISceneExplore
//
//  Created by dzw on 2019/11/27.
//  Copyright © 2019 zego. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange

        self.title = "Home"
        let centerlabel = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
        centerlabel.backgroundColor = UIColor.lightGray
        centerlabel.text = "这是一个scene中Home Controller"
        self.view.addSubview(centerlabel)
        
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
