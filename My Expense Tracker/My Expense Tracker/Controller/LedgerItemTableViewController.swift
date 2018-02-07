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
    @IBOutlet weak var date: UILabel!
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
        
        setSaveButtonStatus()
        
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
    
    func setSaveButtonStatus() {
        let text = itemDescription.text ?? ""
        saveButton.isEnabled = !text.isEmpty
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
        
        if ledgerItem == nil {
            
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
            
            // Get notes
            
            let notes = self.notes.text ?? ""
            
            // Initialise item
            
            let item = LedgerItem(type: type, date: date, description: description, amount: amount, notes: notes)
            
            //category?.addLedgerItem(item: item)
            
            // Pass ledger item to previous VC, and save it there.
            
            
            
            // Save category disk, so that it is updated when this VC is dismissed.
            
            // If presented modally, save the newly created Ledger Item, then dismiss the view. If presented with navigation controller, save the edited LedgerItem, then pop off the stack.
            
            guard let delegate = delegate else {
                fatalError("No delegate set")
            }
            delegate.userDidCreate(ledgerItem: item)
            dismiss(animated: true, completion: nil)
            
        } else if ledgerItem != nil {
            
            //segmentedControl
            date.text = ledgerItem?.date
            //datePicker.date =
            itemDescription.text = ledgerItem?.itemDescription
            price.text = String(describing: ledgerItem?.amount)
            notes.text = ledgerItem?.notes
            
        }
        
        
        //else if let owningNavigationController ... 
        
    }
    
    
    

}
