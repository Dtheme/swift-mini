//
//  Agent.swift
//  03-RainbowSix
//
//  Created by dzw on 2019/5/16.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class Agent: NSObject {
    var name : String?
    var background : String?
    var psychological : String?
    var train : String?
    var experience : String?
    
    
    init(name : String,
         background : String,
         psychological : String,
         train : String,
         experience : String)
    {
        self.name = name
        self.background = background
        self.psychological = psychological
        self.train = train
        self.experience = experience
    }
    
}
