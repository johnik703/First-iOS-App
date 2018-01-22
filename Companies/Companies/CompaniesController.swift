//
//  ViewController.swift
//  Companies
//
//  Created by Daniel Peach on 1/13/18.
//  Copyright © 2018 Daniel Peach. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {

    // Array of Company objects
    var companies = [Company]()
    
    // Start building here
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupViewStyles()
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupViewStyles() {
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Companies"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        setupPlusButtonOnNavBar(selector: #selector(handleAddCompany))
    }
    // (Reset) Button Pressed
    @objc private func handleReset() {
        if CoreDataManager.shared.deleteAllCompanies() {
            var indexPathsToRemove = [IndexPath]()
            for (index) in companies.indices {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        }
    }
    // (Add Company) Button Pressed
    @objc private func handleAddCompany() {
        let createCompanyViewController = CompanyInfoViewController()
        let createCompanyNavigationController = CustomNavigationController(rootViewController: createCompanyViewController)
        createCompanyViewController.companyInfoDelegate = self
        present(createCompanyNavigationController, animated: true, completion: nil)
    }
}

