//
//  CardLayout.swift
//  03-RainbowSix
//
//  Created by dzw on 2019/5/15.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class CardLayout: UICollectionViewFlowLayout {
    var itemSidelength = UIScreen.main.bounds.size.width*0.8
    var lineSpacing: CGFloat = 10
    lazy var inset:CGFloat = {
        return (self.collectionView?.bounds.width ?? 0) * 0.5 - self.itemSize.width * 0.5
    }()
    
    init(itemSidelength: CGFloat, LineSpacing: CGFloat ) {
        super.init()
        self.lineSpacing = LineSpacing
        self.itemSidelength = itemSidelength
        //元素大小
        self.itemSize = CGSize(width: itemSidelength, height: itemSidelength)
        self.scrollDirection = .vertical
        //间距
        self.minimumLineSpacing = LineSpacing
//        self.minimumInteritemSpacing = 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    override func prepare() {
        self.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
}




