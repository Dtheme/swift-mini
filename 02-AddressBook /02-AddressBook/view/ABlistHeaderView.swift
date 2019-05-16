//
//  ABlistHeaderView.swift
//  02-AddressBook
//
//  Created by dzw on 2019/5/13.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

class ABlistHeaderView: UIView {
    

    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!

    var addAction : ((_ phoneNumber: String,_ name: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.phoneNumberTF.delegate = self
        self.nameTF.delegate = self
        
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
    }
    
    @IBAction func addToContactAction(_ sender: UIButton) {

        phoneNumberTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        addAction?(phoneNumberTF.text!, nameTF.text!)

    }
}

extension ABlistHeaderView : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(String(describing: textField.text?.description))")
    }
}
