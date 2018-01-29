//
//  CategoryViewController.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/20/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set tableView delegate and data source
        tableView.dataSource = self
        tableView.delegate = self
        
        // Load Data
        loadSampleData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of CategoryTableViewCell")
        }
        let category = categories[indexPath.row]
        cell.configureCell(category: category)
        return cell
    }
    
    //MARK: Navigation
    
    /*
     In order to set the category in the destination VC, you have to get the selected category. In order to do that, you need to know the indexPath. In order to get the index path, you have to get the cell that has been selected.
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "toCategoryDetail" {
            
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
            
        }
    }
    
    //MARK: Private Functions
    
    private func loadSampleData() {
        
        let categoryName1 = "Allowances"
        let categoryAmount1: Double = 500
        guard let category1 = Category(name: categoryName1, amount: categoryAmount1) else {
            fatalError("Unable to instantiate category.")
        }
        
        // Add category to array
        categories += [category1]
    }
    
    //MARK: - Actions
    
    @IBAction func unwindToCategoriesList(sender: UIStoryboardSegue) {
        
        // Try to add category from sending view controller to the categoris array in the receiving view controller.
        
        if let sendingViewController = sender.source as? AddCategoryViewController, let category = sendingViewController.category {
            
            // Add a new category to the table
            let newIndexPath = IndexPath(row: categories.count, section: 0)
            categories.append(category)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
}

