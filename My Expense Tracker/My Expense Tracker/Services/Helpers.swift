//
//  Helpers.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/30/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Cell Identifiers in LedgerItemViweController

let NOTES_CELL = "NotesCell"
let SELECT_TYPE = "SelectItemType"
let PRICE_OR_DESCRIPTION = "AddItemOrPriceCell"
let DATE = "AddDateCell"

let startingAmountDescription = "Initial Amount"

let myDisabledColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8039215686, alpha: 1)

// MARK: - Protocols

protocol LedgerItemTableViewControllerDelegate {
    func userDidCreate(ledgerItem: LedgerItem)
    func userDidEdit(ledgerItem: LedgerItem)
}

protocol CategoryTransferDelegate {
    func userDidCreateOrEdit(category: Category)
}
