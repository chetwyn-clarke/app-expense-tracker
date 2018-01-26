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
    var startingAmount: Double?
    var runningTotal: Double?
    var ledgerAmounts = [Double]()
    
    // MARK: - Initialisation
    
    init?(name: String, amount: Double?) {
        
        // Name most not be empty.
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize properties
        self.name = name
        self.startingAmount = amount
    }
    
    // MARK: - Private functions
    
    private func calculateRunningTotal(startingAmount: Double, ledgerEntries: [Double]) {
        
        if ledgerEntries.isEmpty {
            runningTotal = startingAmount
        }
        else {
            var sumOfLedgerEntries = 0.0
            for entry in ledgerEntries {
                //TODO: Check syntax, and see if this can be simplified.
                sumOfLedgerEntries = sumOfLedgerEntries + entry
                //sumOfLedgerEntries += entry
            }
            runningTotal = startingAmount + sumOfLedgerEntries
            //TODO: Run a unit test for this function.
        }
        
    }
}
