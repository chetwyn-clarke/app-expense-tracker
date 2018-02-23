//
//  Category.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/21/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit
import os.log

class Category: NSObject, NSCoding {
    
    // MARK: - Properties
    
    var name: String
    var startingAmount: Double
    var runningTotal: Int
    var ledgerAmounts: [LedgerItem]
    
    // MARK: - Initialisation
    
    init?(name: String, amount: Double?, runningTotal: Int?, ledgerAmounts: [LedgerItem]?) {
        
        // Name most not be empty.
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize properties
        self.name = name
        self.startingAmount = amount ?? 0.00
        self.runningTotal = runningTotal ?? 0
        self.ledgerAmounts = ledgerAmounts ?? [LedgerItem]()
        
    }
    
    // MARK: - Functions
    
    func calculateRunningTotal() {
        
        if ledgerAmounts.isEmpty {
            runningTotal = Int(startingAmount)
        } else if !ledgerAmounts.isEmpty {
            var sumOfLedgerItems: Double = 0
            
            for item in ledgerAmounts {
                var amount: Double = 0
                if item.type == .income {
                    amount = item.amount
                } else if item.type == .expense {
                    amount = -(item.amount)
                }
                sumOfLedgerItems += amount
            }
            
            runningTotal = Int(round(sumOfLedgerItems))
            
            //TODO: Run a unit test for this function
        }
    }
    
    func addLedgerItem(item: LedgerItem) {
        self.ledgerAmounts.append(item)
    }
    
    // MARK: - Data Persistence
    
    struct PropertyKey {
        static let name = "name"
        static let startingAmount = "starting Amount"
        static let runningTotal = "running total"
        static let ledgerItems = "ledger items"
    }
    
    func encode(with aCoder: NSCoder) {
        
        // Encode each class variable to a specific key
        
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(startingAmount, forKey: PropertyKey.startingAmount)
        aCoder.encode(runningTotal, forKey: PropertyKey.runningTotal)
        aCoder.encode(ledgerAmounts, forKey: PropertyKey.ledgerItems)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // Decode each item to a specific variable
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Category object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let amount = aDecoder.decodeDouble(forKey: PropertyKey.startingAmount)
        
        let runningTotal = aDecoder.decodeInteger(forKey: PropertyKey.runningTotal)
        
        let ledgerItems = aDecoder.decodeObject(forKey: PropertyKey.ledgerItems) as? [LedgerItem]
        
        // Use the variables to initialise the Category
        
        self.init(name: name, amount: amount, runningTotal: runningTotal, ledgerAmounts: ledgerItems)
    }
    
}
