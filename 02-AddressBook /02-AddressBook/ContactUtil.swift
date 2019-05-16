//
//  ContactUtil.swift
//  02-AddressBook
//
//  Created by dzw on 2019/5/13.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit
import Contacts

class ContactUtil: NSObject {

    class func hasContactAuth() -> Bool{
        
        var hasAuth : Bool = false
        CNContactStore().requestAccess(for: .contacts) { (isSuccess, error) in
            if isSuccess {
                hasAuth = true
            } else {
                print("你需要在设置中授权通讯录")
                hasAuth = false
                return
            }
        }
        return hasAuth
    }
    
    //获取系统通讯录原始联系人数据
    class func fetchOriginContactData() -> [Person]{
        
        //临时数据
        var tempContactData : [Person] = []
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        guard status == .authorized  else {
            return []
        }
        let store = CNContactStore()
        let fetchKeys = [CNContactGivenNameKey,CNContactMiddleNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactOrganizationNameKey,CNContactPostalAddressesKey,CNContactImageDataKey]
        
        let request = CNContactFetchRequest(keysToFetch: fetchKeys as [CNKeyDescriptor])
        do{
            try store.enumerateContacts(with: request, usingBlock: { (contact, stop) in
                let p = Person(givenName: contact.givenName, middleName: contact.middleName, familyName: contact.familyName, phoneNumber: contact.phoneNumbers,postalAddresses: contact.postalAddresses)
                tempContactData.append(p)
            })
        }catch  {
            print("通讯录获取失败")
        }
        return tempContactData
    }
    
    class func fetchOrderedContactData() -> [String:[Person]]{
        
        let originData = ContactUtil.fetchOriginContactData()
        //排序后的结果
        var orderedDict = [String:[Person]]()
    
        for p in originData {
            let firstLetterString = self.getFirstLetterFromString(aString: p.familyName!)
            if orderedDict[firstLetterString] != nil {
                orderedDict[firstLetterString]?.append(p)
            } else {
                var arrGroupNames : [Person] = []
                arrGroupNames.append(p)
                orderedDict[firstLetterString] = arrGroupNames
            }
        }
        
        return orderedDict
    }
    
    //MARK: -  private
    private class func getFirstLetterFromString(aString: String) -> (String) {
        
        let mutableString = NSMutableString.init(string: aString)
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        let strPinYin = polyphoneStringHandle(nameString: aString, pinyinString: pinyinString).uppercased()
        let firstString :String
        if strPinYin != "" {
            firstString =  String(strPinYin[..<strPinYin.index(strPinYin.startIndex, offsetBy:1)])
        }else{
            firstString = "#"
        }

        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
    }
    

    private class func polyphoneStringHandle(nameString:String, pinyinString:String) -> String {
        if nameString.hasPrefix("长") {return "chang"}
        if nameString.hasPrefix("沈") {return "shen"}
        if nameString.hasPrefix("厦") {return "xia"}
        if nameString.hasPrefix("地") {return "di"}
        if nameString.hasPrefix("重") {return "chong"}
        
        return pinyinString;
    }
    

    

}
