//
//  RecordModel.swift
//  04-VoiceMemo
//
//  Created by dzw on 2019/5/26.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class RecordArchiveTool: NSObject,NSCoding {
    
    @objc var audioInfo: NSMutableArray = []
    static let sharedInstance = RecordArchiveTool()
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {

        var count: UInt32 = 0
        let outCount: UnsafeMutablePointer<UInt32> = withUnsafeMutablePointer(to: &count) { (outCount: UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<UInt32> in
            return outCount
        }

        let ivars = class_copyIvarList(RecordArchiveTool.self, outCount)
        for i in 0..<outCount.pointee {
            let ivar = ivars![Int(i)];
            let ivarKey = String(cString: ivar_getName(ivar)!)
            let ivarValue = value(forKey: ivarKey)
            aCoder.encode(ivarValue, forKey: ivarKey)
        }
        free(ivars)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        var count: UInt32 = 0
        let outCount = withUnsafeMutablePointer(to: &count) { (outCount: UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<UInt32> in
            return outCount
        }

        let ivars = class_copyIvarList(RecordArchiveTool.self, outCount)
        for i in 0..<count {
            let ivar = ivars![Int(i)]
            let ivarKey = String(cString: ivar_getName(ivar)!)
            let ivarValue = aDecoder.decodeObject(forKey: ivarKey)
            setValue(ivarValue, forKey: ivarKey)
        }
        free(ivars)
    }
}
