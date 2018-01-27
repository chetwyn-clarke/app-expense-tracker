//
//  Category.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/21/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class Category {
    
    // MARK: - Properties
    
    var name: String
    var startingAmount: Double
    var runningTotal: Int = 0
    var ledgerAmounts = [LedgerItem]()
    
    // MARK: - Initialisation
    
    init?(name: String, amount: Double?) {
        
        // Name most not be empty.
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize properties
        self.name = name
        self.startingAmount = amount ?? 0
    }
    
    // MARK: - Functions
    
    func calculateRunningTotal(ledgerEntries: [LedgerItem]) {
        
        if ledgerEntries.isEmpty {
                runningTotal = Int(startingAmount)
        }
        else {
            var sumOfLedgerEntries = 0.0
            
            for item in ledgerEntries {
                var amount = 0.0
                if item.type == .expense {
                    amount = -(item.amount)
                } else {
                    amount = item.amount
                }
                //TODO: Check syntax, and see if this can be simplified.
                sumOfLedgerEntries = sumOfLedgerEntries + amount
                //sumOfLedgerEntries += entry
            }
            
            runningTotal = Int(round(startingAmount + sumOfLedgerEntries))
            
            //TODO: Run a unit test for this function.
            
        }
    }
}
