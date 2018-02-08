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
    
    var type: LedgerItemType
    var date: Date
    var itemDescription: String
    var amount: Double
    var notes: String?
    
    // MARK: - Initializer
    
    init(type: LedgerItemType, date: Date, description: String, amount: Double, notes: String?) {
        
        self.date = date
        
        self.type = type
        self.itemDescription = description
        
        // No need to change amount depending on whether it is an expense or an item; the Category Class description handles that calculation.
        
        self.amount = amount
        self.notes = notes ?? ""
        
    }
    
}

enum LedgerItemType {
    case income
    case expense
}
