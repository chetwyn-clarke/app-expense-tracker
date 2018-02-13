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
    
    // TODO: - Fix unWindSegue such that added category is shown in CategoryVC
    
    // MARK: - Properties
    
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var startingAmount: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var category: Category?
    var delegate: CategoryTransferDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryName.delegate = self
        startingAmount.delegate = self
        
        // Set up the view if editing a category
        if let category = category {
            navigationItem.title = "Edit Category"
            categoryName.text = category.name
            startingAmount.text = String(describing: category.startingAmount)
        }
        
        updateSaveButtonStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    // MARK: - Navigation

    // Configure the destination view controller before presenting it.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("The save button was not pressed, cancelling.", log: OSLog.default, type: .debug)
            return
        }
        
        // Configure the category to be passed to the destination view controller i.e. to the CategoryViewController.
        
//        let name = categoryName.text ?? ""
//        var amount = 0.0
//        if let amnt = startingAmount.text {
//            amount = Double(amnt)!
//        } else {
//            os_log("No starting amount added.", log: OSLog.default, type: .debug)
//        }
//
//        category = Category(name: name, amount: amount)
        
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
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        // Creating a new category
        
        if category == nil {
            
            let name = categoryName.text ?? "New Category"
            var amount = 0.0
            if let amnt = startingAmount.text {
                if !amnt.isEmpty {
                    amount = Double(amnt)!
                }
            } else {
                os_log("No starting amount added.", log: OSLog.default, type: .debug)
            }
            
            category = Category(name: name, amount: amount, runningTotal: nil, ledgerAmounts: nil)
            
            if let category = category {
                DataService.instance.saveCategoryToCategories(category: category)
            }
            
            print("Category Count: \(DataService.instance.getCategories().count)")
            
            determinePresentingViewControllerAndDismiss()
            
        }
        
        // Editing an existing category
            
        else if category != nil {
            
            guard let category = category else {
                fatalError("No category was sent in segue to this view controller.")
            }
            
            let name = categoryName.text ?? "Edited Category"
            let startAmount = startingAmount.text ?? "0.00"
            
            category.name = name
            category.startingAmount = Double(startAmount)!
            
            guard let delegate = delegate else {
                fatalError("No delegate set.")
            }
            
            delegate.userDidCreateOrEdit(category: category)
            
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
    
    
    // MARK: - Private Functions
    
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
