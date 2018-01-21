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
    
    //MARK: Private Functions
    
    private func loadSampleData() {
        
        let categoryName1 = "Allowances"
        let category1 = Category(name: categoryName1)
        
        // Add category to array
        categories += [category1]
    }
    


}

