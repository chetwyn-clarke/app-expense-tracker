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
    
    //MARK: - Outlets
    
    @IBOutlet weak var runningTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Properties
    
    /* This value is passed by CategoryViewController in 'prepare(for:sender:)
     */
    var category: Category?
    
    /* This value is passed by LedgerItemViewController in 'prepare(for:sender:)'
     */
    var ledgerEntries = [LedgerItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // navigationItem.rightBarButtonItem
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Update running total and table view with ledger items.
        loadSampleData()
        updateView()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    
    @IBAction func unWindToCategoryDetail(sender: UIStoryboardSegue) {
        
    }
    
    // MARK: - Functions
    
    func updateView() {
        if let category = category {
            navigationItem.title = category.name
            runningTotal.text = String(describing: category.runningTotal)
        }
    }
    
    private func loadSampleData() {
        
        let ledgerItemType1 = LedgerItemType.expense
        let ledgerItemDate1 = "Jan 25"
        let ledgerItemDescription1 = "Groceries"
        let ledgerItemAmount1 = 31.25
        
        let ledgerItem1 = LedgerItem(type: ledgerItemType1, date: ledgerItemDate1, description: ledgerItemDescription1, amount: ledgerItemAmount1)
        
        let ledgerItemType2 = LedgerItemType.expense
        let ledgerItemDate2 = "Jan 30"
        let ledgerItemDescription2 = "Trip to San Blas"
        let ledgerItemAmount2 = 50.43
        
        let ledgerItem2 = LedgerItem(type: ledgerItemType2, date: ledgerItemDate2, description: ledgerItemDescription2, amount: ledgerItemAmount2)
        
        let ledgerItemType3 = LedgerItemType.expense
        let ledgerItemDate3 = "Jan 20"
        let ledgerItemDescription3 = "Suvlas"
        let ledgerItemAmount3 = 9.25
        
        let ledgerItem3 = LedgerItem(type: ledgerItemType3, date: ledgerItemDate3, description: ledgerItemDescription3, amount: ledgerItemAmount3)
        
        ledgerEntries += [ledgerItem1, ledgerItem2, ledgerItem3]
    }
    

}
