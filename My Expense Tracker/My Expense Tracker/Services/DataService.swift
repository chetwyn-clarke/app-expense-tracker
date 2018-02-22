//
//  DataService.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/30/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import Foundation
import os.log

class DataService {
    
    // MARK: - Initialisation
    
    static let instance = DataService()
    
    // MARK: - Properties

    var categories = [Category]()
    var selectedCategory: Category?
    var indexPathForSelectedCategory: IndexPath?
    
    // MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("categories")
    
    // MARK: - Functions
    
    func getCategories() -> [Category] {
        return categories
    }
    
    func saveCategories() {
        
        /*
        if let categoryToBeSaved = selectedCategory, let selectedIndexPath = indexPathForSelectedCategory {
            categories[selectedIndexPath.row] = categoryToBeSaved
        }
        */
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(categories, toFile: DataService.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Categories successfully saved.", log: .default, type: .debug)
        } else {
            os_log("Failed to save categories...", log: .default, type: .debug)
        }
    }
    
    func loadCategories() {
        let savedCategories = NSKeyedUnarchiver.unarchiveObject(withFile: DataService.ArchiveURL.path) as? [Category]
        if let categories = savedCategories {
            self.categories = categories
            print("Categories successfully loaded.")
        } else {
            print("No categories have been saved.")
            loadSampleData()
        }
        
        if categories.isEmpty {
            loadSampleData()
        }
    }
    
    func addCategory(category: Category) {
        categories.append(category)
        saveCategories()
        loadCategories()
    }
    
    func saveCategoryToCategories(category: Category) {
        categories.append(category)
    }
    
    private func loadSampleData() {
        
        let categoryName1 = "Allowances (Sample)"
        let categoryAmount1: Double = 500
        guard let category1 = Category(name: categoryName1, amount: categoryAmount1, runningTotal: nil, ledgerAmounts: nil) else {
            fatalError("Unable to instantiate category.")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMddyyyy"
        
        let ledgerItemType1 = LedgerItemType.expense
        let ledgerItemDate1 = dateFormatter.date(from: "Jan252018")
        let ledgerItemDescription1 = "Groceries"
        let ledgerItemAmount1 = 31.25
        let ledgerItem1 = LedgerItem(type: ledgerItemType1, date:ledgerItemDate1!, description: ledgerItemDescription1, amount: ledgerItemAmount1, notes: "Riba Smith")
        
        let ledgerItemType2 = LedgerItemType.expense
        let ledgerItemDate2 = dateFormatter.date(from: "Jan302018")
        let ledgerItemDescription2 = "Trip to San Blas"
        let ledgerItemAmount2 = 50.43
        let ledgerItem2 = LedgerItem(type: ledgerItemType2, date: ledgerItemDate2!, description: ledgerItemDescription2, amount: ledgerItemAmount2, notes: "")
        
        let ledgerItemType3 = LedgerItemType.expense
        let ledgerItemDate3 = dateFormatter.date(from: "Jan202018")
        let ledgerItemDescription3 = "Suvlas"
        let ledgerItemAmount3 = 9.25
        let ledgerItem3 = LedgerItem(type: ledgerItemType3, date: ledgerItemDate3!, description: ledgerItemDescription3, amount: ledgerItemAmount3, notes: "")
        
        let firstLedgerItemType  = LedgerItemType.income
        let firstLedgerItemDate = dateFormatter.date(from: "Jan012018")
        let firstLedgerItemDescription = startingAmountDescription
        let firstLedgerItemAmount = categoryAmount1
        let firstLedgerItemNotes = "First of the month entry"
        let firstLedgerItem = LedgerItem(type: firstLedgerItemType, date: firstLedgerItemDate!, description: firstLedgerItemDescription, amount: firstLedgerItemAmount, notes: firstLedgerItemNotes)
        
        
        category1.ledgerAmounts += [ledgerItem1, ledgerItem2, ledgerItem3, firstLedgerItem]
        category1.ledgerAmounts.sort { (item1, item2) -> Bool in
            let date1 = item1.date
            let date2 = item2.date
            return date1 > date2
        }
        
        category1.newCalculateRunningTotal()
        
        categories += [category1]
    }
}
