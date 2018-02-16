//
//  LedgerItem.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/26/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class LedgerItem: NSObject {
    
    //MARK: - Properties
    
    var type: LedgerItemType
    var date: Date
    var itemDescription: String
    var amount: Double
    var notes: String
    
    // MARK: - Initializer
    
    init(type: LedgerItemType, date: Date, description: String, amount: Double, notes: String?) {
        
        self.date = date
        
        self.type = type
        self.itemDescription = description
        
        // No need to change amount depending on whether it is an expense or an item; the Category Class description handles that calculation.
        
        self.amount = amount
        self.notes = notes ?? ""
        
    }
    
    // MARK: - Decoding from saved files
    
    required convenience init?(coder aDecoder: NSCoder) {
        let type = aDecoder.decodeObject(forKey: PropertyKey.type) as? LedgerItemType
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date
        let itemDescription = aDecoder.decodeObject(forKey: PropertyKey.itemDescription) as? String
        let amount = aDecoder.decodeDouble(forKey: PropertyKey.amount)
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String
        
        //TODO: Figure out why type, date and description have to be unwrapped but not amount and notes.
        
        self.init(type: type!, date: date!, description: itemDescription!, amount: amount, notes: notes)
    }
    
}

extension LedgerItem: NSCoding {
    
    struct PropertyKey {
        static let type = "type"
        static let date = "date"
        static let itemDescription = "item Description"
        static let amount = "amount"
        static let notes = "notes"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: PropertyKey.type)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(itemDescription, forKey: PropertyKey.itemDescription)
        aCoder.encode(amount, forKey: PropertyKey.amount)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
    
}

enum LedgerItemType {
    case income
    case expense
}
