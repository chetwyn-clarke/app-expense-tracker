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
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryName.delegate = self
        startingAmount.delegate = self
        
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
        
        let name = categoryName.text ?? ""
        var amount = 0.0
        if let amnt = startingAmount.text {
            amount = Double(amnt)!
        } else {
            // TODO: Add debug code.
        }
        
        // Set the category to be passed to destination view controller.
        category = Category(name: name, amount: amount)
        
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

}
