//
//  CategoryDetailViewController.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/21/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit
import os.log

class CategoryDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LedgerItemTableViewControllerDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var runningTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Properties
    
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
        loadSampleData()
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
            
        case "toAddItem":
            
            guard let destinationViewController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(String(describing: segue.destination))")
            }
            
//            guard let selectedCategory = self.category else {
//                fatalError("No category selected")
//            }
            
            guard let receivingViewController = destinationViewController.topViewController as? LedgerItemTableViewController else {
                fatalError("Unexpected destination: \(String(describing: segue.destination))")
            }
            
            //receivingViewController.category = selectedCategory
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
    
//    @IBAction func addLedgerItem(_ sender: Any) {
//        performSegue(withIdentifier: "toAddLedgerItem", sender: nil)
//    }
    
    
    
    // MARK: - Functions
    
    func configureView() {
        if let category = category {
            navigationItem.title = category.name
            category.calculateRunningTotal(ledgerEntries: ledgerEntries)
           
            runningTotal.text = String(describing: category.runningTotal)
            print(runningTotal.text as Any)
            ledgerEntries = category.ledgerAmounts
        }
        
        // Configure right bar button item
        
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(clearAllLedgerEntries))
        resetButton.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = resetButton
        
        
    }
    
    func userDidCreate(ledgerItem: LedgerItem) {
        
        guard let category = category else {
            fatalError("No category available.")
        }
        
        category.addLedgerItem(item: ledgerItem)
        ledgerEntries = category.ledgerAmounts
        category.calculateRunningTotal(ledgerEntries: ledgerEntries)
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
    
    private func loadSampleData() {
        
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
        
        ledgerEntries += [ledgerItem1, ledgerItem2, ledgerItem3]
        ledgerEntries.sort { (item1, item2) -> Bool in
            let date1 = item1.date
            let date2 = item2.date
            return date1 > date2
        }
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
