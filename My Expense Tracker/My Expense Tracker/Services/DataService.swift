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

    private var _categories = [Category]()
    
    var categories: [Category] {
        return _categories
    }
    
    // MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("categories")
    
    
    // MARK: - Functions
    
    func getCategories() -> [Category] {
        return categories
    }
    
    func saveCategories() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(_categories, toFile: DataService.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Categories successfully saved.", log: .default, type: .debug)
        } else {
            os_log("Failed to save categories...", log: .default, type: .debug)
        }
    }
    
    func loadCategories() -> [Category]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: DataService.ArchiveURL.path) as? [Category]
    }
    
    func addCategory(category: Category) {
        _categories.append(category)
        saveCategories()
    }
    
    func saveCategoryToCategories(category: Category) {
        _categories.append(category)
    }
}
