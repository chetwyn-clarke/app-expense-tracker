//
//  AddCategoryViewController.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/22/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit
import os.log

class AddCategoryViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var startingAmount: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //var category: Category?
    //var delegate: CategoryTransferDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryName.delegate = self
        startingAmount.delegate = self
        
        configureView()
        
        updateSaveButtonStatus()
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoryName {
            saveButton.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonStatus()
    }
    
    /*

    // MARK: - Navigation

    // Configure the destination view controller before presenting it.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("The save button was not pressed, cancelling.", log: OSLog.default, type: .debug)
            return
        }
        
        
        // Then pass the category to the view controller and add it to the table.
        
        guard let destination = segue.destination as? CategoryViewController else {
            fatalError("Unable to find CategoryViewController.")
        }
        
        guard let category = category else {
            fatalError("Unable to get category from AddCategoryVC")
        }
        
        
        let newIndexPath = IndexPath(row: destination.categories.count, section: 0)
        destination.categories.append(category)
        destination.tableView.insertRows(at: [newIndexPath], with: .automatic)
        
    }
    */
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        if DataService.instance.selectedCategory == nil {
            
            // Creating a category
            
            let name = categoryName.text ?? "New Category"
            let startingAmountText = self.startingAmount.text ?? "0.00"
            let startingAmount = Double(startingAmountText)
            
            let category = Category(name: name, amount: startingAmount, runningTotal: nil, ledgerAmounts: nil)
            
            // Superfluous
            category?.calculateRunningTotal()
            print("First method running total: \(String(describing: category?.runningTotal))")
            
            let date = Date()
            let amount = category?.startingAmount
            let firstLedgerItem = LedgerItem(type: .income, date: date, description: startingAmountDescription, amount: amount!, notes: "")
            category?.addLedgerItem(item: firstLedgerItem)
            
            category?.newCalculateRunningTotal()
            print("New method running total: \(String(describing: category?.runningTotal))")
            
            DataService.instance.addCategory(category: category!)
            
            //DataService.instance.saveCategories()
            
            determinePresentingViewControllerAndDismiss()
            
        } else {
            
            // Editing the selected category
            
            let name = categoryName.text ?? "Untitled"
            let startingAmount = self.startingAmount.text ?? "0.00"
            
            DataService.instance.selectedCategory?.name = name
            DataService.instance.selectedCategory?.startingAmount = Double(startingAmount)!
            
            if let items = DataService.instance.selectedCategory?.ledgerAmounts {
                for item in items {
                    if item.itemDescription == startingAmountDescription {
                        item.amount = Double(startingAmount)!
                    }
                }
            }
            DataService.instance.selectedCategory?.newCalculateRunningTotal()
            
            DataService.instance.saveCategories()
            
            determinePresentingViewControllerAndDismiss()
            
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        determinePresentingViewControllerAndDismiss()
        
    }
    
    // MARK: - Actions
    
    @IBAction func removeKeyboardFromView(_ sender: UITapGestureRecognizer) {
        categoryName.resignFirstResponder()
        startingAmount.resignFirstResponder()
    }
    
    
    // MARK: - Functions
    
    func configureView() {
        //TODO: Confirm if checking that DataService.instance.selectedCategory != nil is actually necessary.
        
        //If editing a category
        if DataService.instance.selectedCategory != nil, let category = DataService.instance.selectedCategory {
            navigationItem.title = "Edit Category"
            categoryName.text = category.name
            startingAmount.text = String(describing: category.startingAmount)
        }
    }
    
    private func updateSaveButtonStatus() {
        //Disable save button if categoryName text field is empty.
        let text = categoryName.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func determinePresentingViewControllerAndDismiss() {
        
        // Action to execute depends on how this view controller was presented. If presented when adding a category, it was presented modally and needs to be dismissed with meal being saved to Categories array; if presented when editing a category, it was pushed, and needs to be popped off the navigation stack.
        
        let presentingInAddCategoryMode = presentingViewController is UINavigationController
        
        if presentingInAddCategoryMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = self.navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The Add / Edit Category view controller is not in a navigation controller. ")
        }
        
    }

}
