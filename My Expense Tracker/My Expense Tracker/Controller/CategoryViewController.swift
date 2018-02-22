//
//  CategoryViewController.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/20/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(CategoryViewController.editButtonSelected))
        self.navigationItem.leftBarButtonItem = editButton
        
        // Set tableView delegate and data source
        tableView.dataSource = self
        tableView.delegate = self
        
        DataService.instance.loadCategories()
        
        print("Category View Loaded")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        if !DataService.instance.categories.isEmpty {
//            categories = DataService.instance.categories
//        }
        
        DataService.instance.selectedCategory = nil
        DataService.instance.loadCategories()
        
        tableView.reloadData()
        
        print("Category View appeared")
    }
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "toCategoryDetail":
            
            print("\(String(describing: segue.identifier)) selected.")
            
//            guard let categoryDetailVC = segue.destination as? CategoryDetailViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//
//            guard let selectedCategoryCell = sender as? CategoryTableViewCell else {
//                fatalError("Unexpected sender: \(String(describing: sender))")
//            }
//
//            guard let indexPath = tableView.indexPath(for: selectedCategoryCell) else {
//                fatalError("The selected cell is not being displayed by the table")
//            }
            
            //let selectedCategory = categories[indexPath.row]
            //categoryDetailVC.category = selectedCategory
            
        case "toAddCategory":
            
            guard let destinationViewController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(String(describing: segue.destination))")
            }
            
            guard let receivingViewController = destinationViewController.topViewController as? AddCategoryViewController else {
                fatalError("Unexpected destination: \(String(describing: segue.destination))")
            }
            
            //receivingViewController.delegate = self
            receivingViewController.navigationItem.title = "Add Category"
            
        default:
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Functions
    
    @objc func editButtonSelected(_ button: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            button.title = "Done"
        } else {
            button.title = "Edit"
        }
    }
    
    func initCategories() {
        categories = DataService.instance.getCategories()
    }
    
}

// MARK: - TableView Data Source and Delegate

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    // TODO: Change function calls to load data from Data Service instead of using category variable in this file.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of CategoryTableViewCell")
        }
        let category = DataService.instance.categories[indexPath.row]
        //let category = DataService.instance.categories[indexPath.row]
        cell.configureCell(category: category)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataService.instance.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //DataService.instance.categories = categories
            DataService.instance.saveCategories()
            DataService.instance.loadCategories()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataService.instance.selectedCategory = DataService.instance.categories[indexPath.row]
        DataService.instance.indexPathForSelectedCategory = tableView.indexPathForSelectedRow
        print("Selected category: \(String(describing: DataService.instance.selectedCategory)) and indexPathForSelectedCategory: \(String(describing: DataService.instance.indexPathForSelectedCategory))")
        
//        if DataService.instance.categories.isEmpty {
//            let selectedCategory = categories[indexPath.row]
//            DataService.instance.selectedCategory = selectedCategory
//        } else {
//            let selectedCategory = DataService.instance.categories[indexPath.row]
//            DataService.instance.selectedCategory = selectedCategory
//            DataService.instance.indexPathForSelectedCategory = tableView.indexPathForSelectedRow
//        }
    }
    
}

// MARK: - CategoryTransferDelegate

//extension CategoryViewController: CategoryTransferDelegate {
//
//    func userDidCreateOrEdit(category: Category) {
//        let newIndexPath = IndexPath(row: categories.count, section: 0)
//        categories.append(category)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
//    }
//
//}

