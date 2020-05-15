//
//  ExtensionFile.swift
//  ServiceBook
//
//  Created by Abhishek Singla on 15/05/20.
//  Copyright © 2020 abhi. All rights reserved.
//

import UIKit

extension UITextField {
    override open func draw(_ rect: CGRect) {
        // Drawing code
        self.textColor = .black
        self.layer.borderWidth = 0.6
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.darkGray.cgColor
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Italic", size: 15) ]
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes as [NSAttributedStringKey : Any])
    }
}

extension UITextView {
    override open func draw(_ rect: CGRect) {
        
    }
}

