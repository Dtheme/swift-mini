//
//  BeerInfoVC.swift
//  01-Beer
//
//  Created by dzw on 2019/5/13.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class BeerInfoVC: UIViewController {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var beer : Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgImage.image = UIImage.init(named: beer!.fullscreenImage!)
        self.descriptionLabel.text = beer!.info
        
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
