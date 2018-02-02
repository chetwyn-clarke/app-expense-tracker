//
//  LedgerItemViewController.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/21/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import UIKit
import os.log

class LedgerItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    
    var sections = [[LedgerItemSceneCell]]()
    
    var ledgerItem: LedgerItem?
    
    // These store the cells in the sections
//    var section0 = ["typeOfItem"]
//    var section1 = ["date"]
//    var section2 = ["item","price","notes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        initSections()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ledgerItemCell = sections[indexPath.section][indexPath.row]
        
        switch sections[indexPath.section][indexPath.row].section {
            
        case .type:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SELECT_TYPE, for: indexPath) as? SelectItemTypeCell else {
                fatalError("The dequeued cell is not an istance of SelectItemTypeCell.")
            }
            return cell
            
        case .details:
            
            // Use ledgerItemCell
            
            if ledgerItemCell.name == "Date" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DATE, for: indexPath) as? AddDateCell else {
                    fatalError("The dequeued cell is not an instance of AddDateCell")
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PRICE_OR_DESCRIPTION, for: indexPath) as? AddItemOrPriceCell else {
                    fatalError("The dequeued cell is not an istance of AddItemOrPriceCell.")
                }
                cell.configureCells(name: ledgerItemCell.name)
                return cell
            }
            
        case .notes:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NOTES_CELL, for: indexPath) as? AddNotesCell else {
                fatalError("The dequeued cell is not an istance of AddNotesCell.")
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellName = sections[indexPath.section][indexPath.row].name
        
        if cellName == "Notes" {
            return 150
        } else {
            return 50
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
    
    func initSections() {
        
        // Aim: Take all the LedgerItemSceneCells and sort them into sections based on their type. Then use those sections to build the table.
        
        let cells = DataService.instance.getLedgerItemSceneCells()
        
        var section0 = [LedgerItemSceneCell]()
        var section1 = [LedgerItemSceneCell]()
        var section2 = [LedgerItemSceneCell]()
        
        for cell in cells {
            switch (cell.section) {
            case .type:
                section0.append(cell)
            case .details:
                section1.append(cell)
            case .notes:
                section2.append(cell)
            }
        }
        
        let allSections = [section0, section1, section2]
        
        sections = allSections
        
        
        
        
        // Create an index path
        
        
    }
    
    // MARK: - Actions
    
    // When save button pressed need to do one of two things. If editing a ledger item, then need to save that ledger item; if creating a new one, then need to save that to the array, enter it into a new index path, and then reload the tableview.
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        
        
        
    }
    

}
