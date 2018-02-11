//
//  LedgerItemTableViewController.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 2/5/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit

class LedgerItemTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var displayedDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var itemDescription: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var notes: UITextField!
    
    //var category: Category?
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

    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == itemDescription {
            setSaveButtonStatus()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        if textField == itemDescription {
            setSaveButtonStatus()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Functions
    
    func configureView() {
        
        itemDescription.delegate = self
        price.delegate = self
        notes.delegate = self
        
        if let item = ledgerItem {
            
            // Set up segmented control
            
            if item.type == .income {
                segmentedControl.selectedSegmentIndex = 0
            } else  {
                segmentedControl.selectedSegmentIndex = 1
            }
            
            // Set date picker to show item's date.
            
            datePicker.date = item.date
            displayedDate.text = formatDate(date: datePicker.date)
            
            itemDescription.text = item.itemDescription
            price.text = String(describing: item.amount)
            notes.text = item.notes
            
        } else {
            
            // In the case there is no ledger item, set displayed date to current date.
            
            let date = Date()
            self.displayedDate.text = formatDate(date: date)
            
        }
        
        setSaveButtonStatus()
        
        configureDatePicker()
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMdd")
        return dateFormatter.string(from:date)
    }
    
    func configureDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.setDate), for: .valueChanged)
    }
    
    @objc func setDate() {
        let date = datePicker.date
        self.displayedDate.text = formatDate(date: date)
    }
    
    func setSaveButtonStatus() {
        let text = itemDescription.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func createItemFromEnteredUserValues() -> LedgerItem {
        
        // Get type of item
        
        var type: LedgerItemType
        if segmentedControl.selectedSegmentIndex == 0 {
            type = .income
        } else {
            type = .expense
        }
        
        // Get date
        
        let date = datePicker.date
        
        // Get item description
        
        let description = self.itemDescription.text ?? ""
        
        // Convert price text field to a Double
        
        var amount: Double
        let price = self.price.text ?? ""
        if price.isEmpty {
            amount = 0.00
        } else {
            amount = Double(price)!
        }
        
        // Get notes
        
        let notes = self.notes.text ?? ""
        
        // Initialise item
        
        let item = LedgerItem(type: type, date: date, description: description, amount: amount, notes: notes)
        
        return item
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func hideKeyboardOnTap(_ sender: UITapGestureRecognizer) {
        itemDescription.resignFirstResponder()
        price.resignFirstResponder()
        notes.resignFirstResponder()
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        /*
         To pass data to the previous view controller we are not using an unwind segue; instead a protocol (LedgerItemTableViewControllerDelegate) is being used. We therefore need to dismiss this view properly depending on how it was presented. If modal presentation was used (i.e. creating a new LedgerItem), the view needs to be dismissed. If 'push' presentation was used (i.e. editing an existing LedgerItem), the view needs to be 'popped' off the navigation stack to return to the previous scene.
         */
 
        // Creating a new Ledger Item
        
        if ledgerItem == nil {
            
            // TODO: Clean the following code. It violates the DRY principle (see else block).
            
            // Get type of item
            
            var type: LedgerItemType
            if segmentedControl.selectedSegmentIndex == 0 {
                type = .income
            } else {
                type = .expense
            }
            
            // Get date
            
            let date = datePicker.date
            
            // Get item description
            
            let description = self.itemDescription.text ?? ""
            
            // Convert price text field to a Double
            
            var amount: Double
            let price = self.price.text ?? ""
            if price.isEmpty {
                amount = 0.00
            } else {
                amount = Double(price)!
            }
            
            // Get notes
            
            let notes = self.notes.text ?? ""
            
            // Initialise item
            
            let item = LedgerItem(type: type, date: date, description: description, amount: amount, notes: notes)
            
            // Pass ledger item to previous VC, and save it there.
            
            // Save category disk, so that it is updated when this VC is dismissed.
            
            guard let delegate = delegate else {
                fatalError("No delegate set")
            }
            delegate.userDidCreate(ledgerItem: item)
            
            dismiss(animated: true, completion: nil)
            
        }
        
        // Editing an existing LedgerItem
        
        else if ledgerItem != nil {
            
            // Get type of item
            
            var type: LedgerItemType
            if segmentedControl.selectedSegmentIndex == 0 {
                type = .income
            } else {
                type = .expense
            }
            
            // Get date
            
            let date = datePicker.date
            
            // Get item description
            
            let description = self.itemDescription.text ?? ""
            
            // Convert price text field to a Double
            
            var amount: Double
            let price = self.price.text ?? ""
            if price.isEmpty {
                amount = 0.00
            } else {
                amount = Double(price)!
            }
            
            // Get notes
            
            let notes = self.notes.text ?? ""
            
            // Initialise item
            
            let item = LedgerItem(type: type, date: date, description: description, amount: amount, notes: notes)
            
            guard let delegate = delegate else {
                fatalError("No delegate set")
            }
            
            delegate.userDidEdit(ledgerItem: item)
            
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    
    

}
