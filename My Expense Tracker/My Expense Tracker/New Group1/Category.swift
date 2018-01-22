//
//  Category.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/21/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class Category {
    
    // MARK: Properties
    
    var name: String
    var startingAmount: Double?
    
    // MARK: Initialisation
    
    init?(name: String, amount: Double?) {
        
        // Name most not be empty.
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize properties
        self.name = name
        self.startingAmount = amount
    }
}
