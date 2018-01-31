//
//  LedgerItemSceneConfiguration.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/30/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import Foundation

struct LedgerItemSceneCell {
    var name: String
    var section: Section
    var indexPath: IndexPath?
    
    init(name: String, section: Section) {
        self.name = name
        self.section = section
    }
}

enum Section: Int {
    case type = 0, details = 1, notes = 2
}


