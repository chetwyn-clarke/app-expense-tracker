//
//  LedgerItem.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/26/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class LedgerItem {
    
    //MARK: - Properties
    
    var date: String?
    var itemDescription: String
    var amount: Double
    
    //MARK: - Initializer
    
    init(date: String?, description: String, amount: Double) {
        if date == nil {
            self.date = ""
        } else {
            self.date = date
        }
        
        self.itemDescription = description
        self.amount = amount
    }
    
}
