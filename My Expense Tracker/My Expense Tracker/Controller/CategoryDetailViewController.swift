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
    
    // MARK: - Table view data source and delegate
    
    
    

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
            
            //destinationViewController.initSections()
            
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
            
            let selectedItem = ledgerEntries[indexPath.row]
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
        //runningTotal.text = String(describing: DataService.instance.selectedCategory?.runningTotal)
        ledgerEntries = category.ledgerAmounts
        
//        if let category = category {
//            navigationItem.title = category.name
//
//            runningTotal.text = String(describing: category.runningTotal)
//            print(runningTotal.text as Any)
//            ledgerEntries = category.ledgerAmounts
//
//        }
        
        // Configure right bar button item
        
        
        
        
    }
    
    @objc private func clearAllLedgerEntries() {
        
        // Clear all entries in the ledger.
        
        ledgerEntries.removeAll()
        
        // Reset running total to Category starting amount, and add ledger item with starting amount.
        
        guard let category = category else {
            fatalError("No category available.")
        }
        category.calculateRunningTotal(ledgerEntries: ledgerEntries)
        
        // Set date to the date you are resetting the total
        let date = Date()
        let firstLedgerItem = LedgerItem(type: .income, date: date, description: "Starting Amount", amount: category.startingAmount, notes: "")
        ledgerEntries.append(firstLedgerItem)
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
        //return ledgerEntries.count
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
        
        //        let ledgerEntry = ledgerEntries[indexPath.row]
        //        cell.configureCell(ledgerItem: ledgerEntry)
        //        return cell
        
    }
    
}

// MARK: - LedgerItemTableViewControllerDelegate

extension CategoryDetailViewController: LedgerItemTableViewControllerDelegate {
    
    func userDidCreate(ledgerItem: LedgerItem) {
        
        guard let category = category else {
            fatalError("No category available.")
        }
        
        category.addLedgerItem(item: ledgerItem)
        
        ledgerEntries = category.ledgerAmounts
        
        // TODO: Sorting function needs to go into its own call. Viloating the DRY principle.
        ledgerEntries.sort { (item1, item2) -> Bool in
            let date1 = item1.date
            let date2 = item2.date
            return date1 > date2
        }
        
        category.calculateRunningTotal()
        runningTotal.text = String(describing: category.runningTotal)
        
        // TODO: Save category to disk beore reloading data.
        
        tableView.reloadData()
        
        /*
        // New structure
        DataService.instance.selectedCategory?.addLedgerItem(item: ledgerItem)
        DataService.instance.selectedCategory?.ledgerAmounts.sort(by: { (item1, item2) -> Bool in
            let date1 = item1.date
            let date2 = item2.date
            return date1 > date2
        })
        DataService.instance.selectedCategory?.newCalculateRunningTotal()
        
        if let category = DataService.instance.selectedCategory {
            runningTotal.text = String(describing: category.runningTotal)
        }
        
        tableView.reloadData()
         */
        
    }
    
    func userDidEdit(ledgerItem: LedgerItem) {
        
        /*
         If a LedgerItem was selected for editing, then the selected row has an index path, and we can use that to determine which item and cell to update.
         */
        
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            fatalError("The LedgerItem selected has no indexPath.")
        }
        
        ledgerEntries[selectedIndexPath.row] = ledgerItem
        
        guard let category = category else {
            fatalError("No category available.")
        }
        category.ledgerAmounts = ledgerEntries
        category.calculateRunningTotal()
        
        // Save the category to disk.
        
        // TODO: Change the category.calculateRunningTotal so that it uses its own ledgerAmounts category instead of having to pass in an argument. It should then return a string, which you use to set the UILabel here.
        
        tableView.reloadRows(at: [selectedIndexPath], with: .none)
        
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
