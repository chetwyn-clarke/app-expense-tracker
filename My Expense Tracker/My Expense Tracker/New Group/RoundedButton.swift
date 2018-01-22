//
//  RoundedButton.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/22/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 2.0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateCornerRadius()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateCornerRadius()
    }
    
    func updateCornerRadius() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
