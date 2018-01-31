//
//  DataService.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/30/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import Foundation

class DataService {
    
    // MARK: - Initialisation
    
    static let instance = DataService()
    
    // MARK: - Properties

    private var categories = [Category]()
    
    private var ledgerItemViewControllerCells = [
        LedgerItemSceneCell(name: "Type", section: .type),
        LedgerItemSceneCell(name: "Date", section: .details),
        LedgerItemSceneCell(name: "Description", section: .details),
        LedgerItemSceneCell(name: "Price", section: .details),
        LedgerItemSceneCell(name: "Notes", section: .notes)
    ]
    
    // MARK: - Functions
    
    func getCategories() -> [Category] {
        return categories
    }
    
    func saveCategories() {
        // TODO: Build this using the example in the Food Tracker App
    }
    
    func getLedgerItemSceneCells() -> [LedgerItemSceneCell] {
        return ledgerItemViewControllerCells
    }
    
    func saveCategoryToCategories(category: Category) {
        categories.append(category)
    }
}
