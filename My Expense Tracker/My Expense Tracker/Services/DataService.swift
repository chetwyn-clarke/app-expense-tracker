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
        } else {
            print("No categories have been saved.")
        }
        //return NSKeyedUnarchiver.unarchiveObject(withFile: DataService.ArchiveURL.path) as? [Category]
    }
    
    func addCategory(category: Category) {
        categories.append(category)
        saveCategories()
        loadCategories()
    }
    
    func saveCategoryToCategories(category: Category) {
        categories.append(category)
    }
}
