//
//  LedgerItemTableViewController.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 2/5/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class LedgerItemTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var itemDescription: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var notes: UITextField!
    
    var category: Category?
    var ledgerItem: LedgerItem?
    
    var delegate: LedgerItemTableViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
        
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    func configureView() {
        configureDatePicker()
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMdd")
        return dateFormatter.string(from:date)
    }
    
    func configureDatePicker() {
        let date = Date()
        self.date.text = formatDate(date: date)
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.setDate), for: .valueChanged)
    }
    
    @objc func setDate() {
        let date = datePicker.date
        self.date.text = formatDate(date: date)
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        // Get type of item
        
        var type: LedgerItemType
        if segmentedControl.selectedSegmentIndex == 0 {
            type = .income
        } else {
            type = .expense
        }
        
        // Get date
        
        let date = self.date.text
        
        // Get item description
        
        let description = self.itemDescription.text ?? ""
        
        // Convert price text field to a Double
        var amount: Double
        let price = self.price.text ?? ""
        if price.isEmpty {
            amount = 0
        } else {
            amount = Double(price)!
        }
        
        let item = LedgerItem(type: type, date: date, description: description, amount: amount)
        
        category?.addLedgerItem(item: item)
        
        // Save category disk, so that it is updated when this VC is dismissed.
        
        // If presented modally, then dismiss the view. If presented with navigation controller, then pop off the stack.
        
        let isAddingAnItem = presentingViewController is UINavigationController
        
        if isAddingAnItem {
            dismiss(animated: true, completion: nil)
        }
        //else if let owningNavigationController ... 
        
        
        
        
        
        
        
    }
    
    
    

}
