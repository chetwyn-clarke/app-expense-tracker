//
//  CategoryDetailViewController.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/21/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit
import os.log

class CategoryDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var runningTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    /*
     This value is passed by CategoryViewController in 'prepare(for:sender:)
     */
    var category: Category?
    
    /*
     This value is passed by LedgerItemTableViewController in delegate functiions
     */
    var ledgerEntries = [LedgerItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(clearAllLedgerEntries))
        resetButton.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = resetButton
        
        runningTotal.adjustsFontSizeToFitWidth = true
        runningTotal.minimumScaleFactor = 50 / 150
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configureView()
        
        print("Category Detail View Loaded")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //configureView()
        
        configureView()
        
        ledgerEntries.sort { (item1, item2) -> Bool in
            let date1 = item1.date
            let date2 = item2.date
            return date1 > date2
        }
        
        tableView.reloadData()
        
        print("Category Detail View Appeared.")
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "modifyCategory":
            
            guard let destinationViewController = segue.destination as? AddCategoryViewController else {
                fatalError("Unexpected destination: \(String(describing: segue.destination))")
            }
            guard let presentCategory = self.category else {
                fatalError("No category selected.")
            }
            //destinationViewController.category = presentCategory
            //destinationViewController.delegate = self
            
        case "toAddItem":
            
            guard let destinationViewController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(String(describing: segue.destination))")
            }
            
            guard let receivingViewController = destinationViewController.topViewController as? LedgerItemTableViewController else {
                fatalError("Unexpected destination: \(String(describing: segue.destination))")
            }
            
            receivingViewController.delegate = self
            receivingViewController.navigationItem.title = "Add Item"
            
        case "toShowLedgerItemDetail":
            
            guard let destinationViewController = segue.destination as? LedgerItemTableViewController else {
                fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
            }
            guard let selectedLedgerItemCell = sender as? CategoryDetailTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedLedgerItemCell) else {
                fatalError("The selected cell is not being displayed by the table.")
            }
            
            let selectedItem = DataService.instance.selectedCategory?.ledgerAmounts[indexPath.row]
            
            destinationViewController.ledgerItem = selectedItem
            destinationViewController.delegate = self
            destinationViewController.navigationItem.title = "Edit Item"
            
        default:
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: - Actions
    
    @IBAction func unWindToCategoryDetail(sender: UIStoryboardSegue) {
        
    }
        
    
    // MARK: - Functions
    
    func configureView() {
        
        guard let category = DataService.instance.selectedCategory else {
            fatalError("No category selected")
        }
        
        navigationItem.title = category.name
        runningTotal.text = String(describing: category.runningTotal)
        ledgerEntries = category.ledgerAmounts
    }
    
    @objc private func clearAllLedgerEntries() {
        
        // Reset running total to Category starting amount, and add ledger item with starting amount.
        
        guard let category = DataService.instance.selectedCategory else {
            fatalError("No category available.")
        }
        guard let categoryIndexPath = DataService.instance.indexPathForSelectedCategory else {
            fatalError("Unable to find IndexPath for selected category.")
        }
        
        // Set date to the date you are resetting the total
        let date = Date()
        let firstLedgerItem = LedgerItem(type: .income, date: date, description: "Starting Amount", amount: category.startingAmount, notes: "")
        
        category.ledgerAmounts.removeAll()
        category.ledgerAmounts.append(firstLedgerItem)
        category.newCalculateRunningTotal()
        
        DataService.instance.selectedCategory = category
        DataService.instance.categories[categoryIndexPath.row] = DataService.instance.selectedCategory!
        //DataService.instance.saveCategories()
        
        tableView.reloadData()
        
        runningTotal.text = String(describing: category.runningTotal)
        
    }
    
}

// MARK: - TableView DataSource and Delegate

extension CategoryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let numberOfRows = DataService.instance.selectedCategory?.ledgerAmounts.count else {
            fatalError("No category selected")
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "LedgerEntryCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CategoryDetailTableViewCell else {
            fatalError("The dequeued cell is not an instance of CategoryDetailTableViewCell")
        }
        guard let ledgerItem = DataService.instance.selectedCategory?.ledgerAmounts[indexPath.row] else {
            fatalError("Unable to find category or ledger amounts.")
        }
        cell.configureCell(ledgerItem: ledgerItem)
        return cell
    }
}

// MARK: - LedgerItemTableViewControllerDelegate

extension CategoryDetailViewController: LedgerItemTableViewControllerDelegate {
    
    func userDidCreate(ledgerItem: LedgerItem) {
        
        
        // TODO: Sorting function needs to go into its own call. Viloating the DRY principle.
    
        guard let category = DataService.instance.selectedCategory else { fatalError("Selected Category not available") }
        guard let categoryIndexPath = DataService.instance.indexPathForSelectedCategory else {
            fatalError("Unable to find IndexPath for selected category.")
        }
        category.addLedgerItem(item: ledgerItem)
        category.ledgerAmounts.sort { (item1, item2) -> Bool in
            let date1 = item1.date
            let date2 = item2.date
            return date1 > date2
        }
        category.newCalculateRunningTotal()
        runningTotal.text = String(describing: category.runningTotal)
         
        DataService.instance.selectedCategory = category
        DataService.instance.categories[categoryIndexPath.row] = category
        //DataService.instance.saveCategories()
        
        tableView.reloadData()
        //runningTotal.text = String(describing: category.runningTotal)
        
    }
    
    func userDidEdit(ledgerItem: LedgerItem) {
        
        /*
         If a LedgerItem was selected for editing, then the selected row has an index path, and we can use that to determine which item and cell to update.
         */
        
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            fatalError("The LedgerItem selected has no indexPath.")
        }
        guard let category = DataService.instance.selectedCategory else {
            fatalError("No category available.")
        }
        guard let categoryIndexPath = DataService.instance.indexPathForSelectedCategory else {
            fatalError("Unable to find IndexPath for selected category.")
        }
        
        category.ledgerAmounts[selectedIndexPath.row] = ledgerItem
        category.ledgerAmounts.sort { (item1, item2) -> Bool in
            let date1 = item1.date
            let date2 = item2.date
            return date1 > date2
        }
        category.newCalculateRunningTotal()
        
        DataService.instance.selectedCategory = category
        DataService.instance.categories[categoryIndexPath.row] = DataService.instance.selectedCategory!
        //DataService.instance.saveCategories()
        
        tableView.reloadData()
        
        runningTotal.text = String(describing: category.runningTotal)
        
    }
    
}

// MARK: - CategoryTransferDelegate

extension CategoryDetailViewController: CategoryTransferDelegate {
    
    func userDidCreateOrEdit(category: Category) {
        _ = category
        
        configureView()
    }
    
}
