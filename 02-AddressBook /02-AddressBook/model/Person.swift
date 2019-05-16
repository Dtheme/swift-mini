//
//  Person.swift
//  02-AddressBook
//
//  Created by dzw on 2019/5/13.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit
import Contacts

class Person: NSObject {
    
    @objc var givenName : String?
    var middleName : String?
    var familyName : String?
    var phoneNumber : [CNLabeledValue<CNPhoneNumber>]?
    var postalAddresses : [CNLabeledValue<CNPostalAddress>]?
   
    init(givenName:String,
         middleName:String,
         familyName:String,
         phoneNumber:[CNLabeledValue<CNPhoneNumber>],
         postalAddresses:[CNLabeledValue<CNPostalAddress>])
    {
        self.givenName = givenName
        self.middleName = middleName
        self.familyName = familyName
        self.phoneNumber = phoneNumber
        self.postalAddresses = postalAddresses
    }
}
