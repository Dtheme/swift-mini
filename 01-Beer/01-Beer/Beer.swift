//
//  Beer.swift
//  01-Beer
//
//  Created by dzw on 2019/5/12.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class Beer: NSObject {
    
    var name : String?
    var Image : String?
    var info :  String?
    var fullscreenImage : String?
    init(name: String, image:String, fullscreenImage:String,info:String) {
        self.name = name
        self.Image = image
        self.info = info
        self.fullscreenImage = fullscreenImage
    }
}
