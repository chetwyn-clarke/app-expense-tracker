//
//  CategoryDetailTableViewCell.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/26/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class CategoryDetailTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    // MARK: - Configuration
    
    func configureCell(ledgerItem: LedgerItem) {
        
        // Format and show the date.
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMdd")
        date.text = dateFormatter.string(from: ledgerItem.date)
            
        itemDescription.text = ledgerItem.itemDescription
        amount.text = ledgerItem.amount.roundedString
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

extension Double {
    var roundedString: String {
        return String(format: "%.2f", self)
    }
}
