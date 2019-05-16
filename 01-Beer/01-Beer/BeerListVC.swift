//
//  BeerListVC.swift
//  01-Beer
//
//  Created by dzw on 2019/5/12.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class BeerListVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
     
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "cell"
    private var beers:[Beer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "🍺"
        
        beers = [
            Beer.init(name:"罗斯福6号-第一",image:"beer",fullscreenImage:"tr6", info:"开瓶有很明显的焦糖风味，酒体呈现偏橙红色，酒头偏黄不持久，挂杯不明显；口感上应该是这三款里最轻快的酒，偏甜不苦，充满柑橘属，草本味，带着一丝红茶的味道，非常易饮。如果您之前没有接触过很重酒体（类似世涛，酸啤等）的话，那么这款酒是一款不错的开始"),
            Beer.init(name:"罗斯福8号-独特的",image:"beer",fullscreenImage:"tr8",info: "罗8是罗10的姊妹款，明显的果脯味和焦糖味配上中度酒体，品尝起来层次感稍微多了一些。酒体呈现亮棕色，酒头偏黄略持久，有一些挂杯；口感上依然杀口感十足，有一丝丝果酸味，苦度不高。味道上相当于弱化的罗10，焦糖气息明显，酒精味隐藏的很好，回甘绵柔且持久"),
            Beer.init(name:"罗斯福10号-所谓的“奇迹”",image:"beer",fullscreenImage:"tr10",info: "罗10是很多人可能开始涉足比利时修道院啤酒的起点，名气自然很大不必多说。酒体相当浑厚，呈现的是深棕色带有意式浓缩咖啡crema颜色的酒头，酒头持久挂杯明显。开瓶能闻到巧克力，烘焙麦芽，焦糖和香料（丁香或者轻微肉桂粉）的气息；入口伴随浓重的麦芽味，香草味，烤面包味和轻微苦味，口感偏干。这款酒的酒精度高，在口感上隐藏的比较好，但是入喉之后能有明显的温热感。口味层次感非常丰富，回甘厚重，着实是一款好酒")
        ]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        cell?.textLabel?.text = beers?[indexPath.row].name
        cell?.imageView?.image = UIImage.init(named: (beers?[indexPath.row].Image)!)
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoVC = BeerInfoVC()
        infoVC.beer = beers![indexPath.row]
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
}

