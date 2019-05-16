//
//  UsVC.swift
//  01-Beer
//
//  Created by dzw on 2019/5/13.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class UsVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = UIImage.init(named: "us")
        self.descriptionLabel.text = "【Rochefort（罗斯福）】啤酒是著名的7大修道院啤酒品牌中的一员。Rochefort啤酒生产于比利时de Saint Remy（圣雷米）修道院内，这个修道院坐落于名叫Rochefort的城镇，所以这个修道院的啤酒就以此地名命名了。\n与其它间修道院一样虽然拥有悠久历史，但仍避免不了战火的摧残，尤其是十九世纪初期，战争更摧毁大部分位在比利时的修道院，所幸靠着来自其它间Trappist修道院的帮忙，Chimay修道院的修道士甚至帮忙建造酿造所及配方，Rochefort啤酒才能至今能可被大众享用。\nRochefort brewery的主要产品有三种：6，8，10，其中Rochefort 10是最浓烈的一款，也是外界评价最高的一款。\nR6（Rochefort Trappistes 6）：酒精度为7.5％，是一款精致的啤酒，酒体呈褐色，带有淡淡的蜂蜜和酵母的味道，口感醇香顺滑，但较为少见。\nR8（Rochefort Trappistes 8）：酒精度为9.2％，丰富的果香味（轻微无花果的味道），还带有一点龙涎香的味道，入口清淡、微苦，后味是淡淡甜味。是罗斯福销售最好的产品，占了产能的相当比例。"
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
