//
//  AddItemOrPriceCell.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/21/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class AddItemOrPriceCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var valueTextField: UITextField!
    
    //MARK: Configure Cells
    
    func configureCells(index: Int) {
        switch index {
        case 0:
            valueTextField.placeholder = "Item Description"
        case 1:
            valueTextField.placeholder = "Price"
            valueTextField.keyboardType = .decimalPad
        default:
            valueTextField.placeholder = "Set placeholder"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
