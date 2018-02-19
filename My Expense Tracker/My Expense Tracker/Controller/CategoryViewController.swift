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
        
        // Load Data
        
        if DataService.instance.categories.isEmpty {
            loadSampleData()
        } else {
            DataService.instance.loadCategories()
            categories = DataService.instance.categories
        }
        
        print("View Loaded")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !DataService.instance.categories.isEmpty {
            categories = DataService.instance.categories
        }
        DataService.instance.selectedCategory = nil
        
        tableView.reloadData()
        
        print("View appeared")
    }
    
    
    //MARK: Navigation
    
    /*
     In order to set the category in the destination VC, you have to get the selected category. In order to do that, you need to know the indexPath. In order to get the index path, you have to get the cell that has been selected.
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "toCategoryDetail":
            
            guard let categoryDetailVC = segue.destination as? CategoryDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCategoryCell = sender as? CategoryTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCategoryCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedCategory = categories[indexPath.row]
            categoryDetailVC.category = selectedCategory
            
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
    
    //MARK: Private Functions
    
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
        
        
        category1.ledgerAmounts += [ledgerItem1, ledgerItem2, ledgerItem3]
        category1.ledgerAmounts.sort { (item1, item2) -> Bool in
            let date1 = item1.date
            let date2 = item2.date
            return date1 > date2
        }
        
        category1.calculateRunningTotal()
        
        categories += [category1]
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of CategoryTableViewCell")
        }
        let category = categories[indexPath.row]
        //let category = DataService.instance.categories[indexPath.row]
        cell.configureCell(category: category)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if DataService.instance.categories.isEmpty {
            let selectedCategory = categories[indexPath.row]
            DataService.instance.selectedCategory = selectedCategory
        } else {
            let selectedCategory = DataService.instance.categories[indexPath.row]
            DataService.instance.selectedCategory = selectedCategory
            DataService.instance.indexPathForSelectedCategory = tableView.indexPathForSelectedRow
        }
    }
    
}

// MARK: - CategoryTransferDelegate

extension CategoryViewController: CategoryTransferDelegate {
    
    func userDidCreateOrEdit(category: Category) {
        let newIndexPath = IndexPath(row: categories.count, section: 0)
        categories.append(category)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
}

