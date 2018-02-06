//
//  Helpers.swift
//  My Expense Tracker
//
//  Created by Chetwyn on 1/30/18.
//  Copyright © 2018 Clarke Enterprises. All rights reserved.
//

import Foundation

// MARK: - Cell Identifiers in LedgerItemViweController

let NOTES_CELL = "NotesCell"
let SELECT_TYPE = "SelectItemType"
let PRICE_OR_DESCRIPTION = "AddItemOrPriceCell"
let DATE = "AddDateCell"

// MARK: - Protocols

protocol LedgerItemTableViewControllerDelegate {
    func userDidCreate(ledgerItem: LedgerItem)
    func userDidEdit(ledgerItem: LedgerItem)
}
