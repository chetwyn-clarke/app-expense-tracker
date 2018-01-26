//
//  CategoryDetailViewController.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/21/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var runningTotal: UILabel!
    
    
    //MARK: - Properties
    
    /* This value is passed by CategoryViewController in 'prepare(for:sender:)
     */
    var category: Category?
    
    var ledgerEntries: [LedgerItem]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // navigationItem.rightBarButtonItem
        
        // Update running total and table view with ledger items.
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK: Functions
    func updateView() {
        if let category = category {
            runningTotal.text = String(describing: category.runningTotal)
        }
    }

}
