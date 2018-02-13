//
//  CategoryDetailViewController.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/21/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit
import os.log

class CategoryDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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

        // navigationItem.rightBarButtonItem
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Update running total and table view with ledger items.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source and delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ledgerEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "LedgerEntryCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CategoryDetailTableViewCell else {
            fatalError("The dequeued cell is not an instance of CategoryDetailTableViewCell")
        }
        
        let ledgerEntry = ledgerEntries[indexPath.row]
        cell.configureCell(ledgerItem: ledgerEntry)
        return cell
        
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
            destinationViewController.category = presentCategory
            destinationViewController.delegate = self
            
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
        
        runningTotal.adjustsFontSizeToFitWidth = true
        runningTotal.minimumScaleFactor = 50 / 150
        
        if let category = category {
            navigationItem.title = category.name
            category.calculateRunningTotal()
           
            runningTotal.text = String(describing: category.runningTotal)
            print(runningTotal.text as Any)
            ledgerEntries = category.ledgerAmounts
        }
        
        // Configure right bar button item
        
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(clearAllLedgerEntries))
        resetButton.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = resetButton
        
        
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

// MARK: - LedgerItemTableViewControllerDelegate

extension CategoryDetailViewController: LedgerItemTableViewControllerDelegate {
    
    func userDidCreate(ledgerItem: LedgerItem) {
        
        guard let category = category else {
            fatalError("No category available.")
        }
        
        category.addLedgerItem(item: ledgerItem)
        
        ledgerEntries = category.ledgerAmounts
        ledgerEntries.sort { (item1, item2) -> Bool in
            let date1 = item1.date
            let date2 = item2.date
            return date1 > date2
        }
        
        category.calculateRunningTotal()
        runningTotal.text = String(describing: category.runningTotal)
        
        // TODO: Save category to disk beore reloading data.
        
        tableView.reloadData()
        
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
        category.calculateRunningTotal(ledgerEntries: ledgerEntries)
        
        // Save the category to disk.
        
        // TODO: Change the category.calculateRunningTotal so that it uses its own ledgerAmounts category instead of having to pass in an argument. It should then return a string, which you use to set the UILabel here.
        
        tableView.reloadRows(at: [selectedIndexPath], with: .none)
        
        runningTotal.text = String(describing: category.runningTotal)
        
    }
    
}

// MARK: - CategoryTransferDelegate

extension CategoryDetailViewController: CategoryTransferDelegate {
    
    func userDidEdit(category: Category) {
        _ = category
        
        configureView()
    }
    
}
