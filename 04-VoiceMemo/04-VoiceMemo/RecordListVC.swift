//
//  ViewController.swift
//  04-VoiceMemo
//
//  Created by dzw on 2019/5/18.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class RecordListVC: UIViewController {

    var recordButton = RecordButton()
    var slider = SlideView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        recordButton = RecordButton.init(frame: CGRect.init(x: 100, y: 100, width: recordButton.ViewRadius, height: recordButton.ViewRadius))
        recordButton.action = { [unowned self](sender) in
            self.recordButton.startButtonAnimation()
            
        }
        self.view.addSubview(recordButton)
        
    
        self.configSlide()
    }
    
    func configSlide() {
//        slider.delegate = self
//        slider.mapController = self
        slider = Bundle.main.loadNibNamed("SlideView",
                                          owner: self, options: nil)?.first as! SlideView
        slider.frame = CGRect.init(x: 0, y: view.frame.height - 150, width: view.frame.width, height: 150)
        view.addSubview(slider)
        
//        slider.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: view.frame.height - 150, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height))
        
    }
    


}

