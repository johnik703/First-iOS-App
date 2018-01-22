//
//  CompaniesController+CompanyInfoViewControllerDelegate.swift
//  Companies
//
//  Created by Daniel Peach on 1/20/18.
//  Copyright © 2018 Daniel Peach. All rights reserved.
//

import UIKit

extension CompaniesController: CompanyInfoViewControllerDelegate {
    
    // Conform to CompanyInfoViewControllerDelegate
    func didSaveNewCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    func didSaveUpdatedCompany(company: Company) {
        let row = companies.index(of: company)
        let indexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [indexPath], with: .middle)
    }
}
