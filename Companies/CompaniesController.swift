//
//  ViewController.swift
//  Companies
//
//  Created by Daniel Peach on 1/13/18.
//  Copyright © 2018 Daniel Peach. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CompanyInfoViewControllerDelegate {
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
    }
    
    // (Add Company) Button Pressed
    @objc private func handleAddCompany() {
        let createCompanyViewController = CompanyInfoViewController()
        let createCompanyNavigationController = CustomNavigationController(rootViewController: createCompanyViewController)
        createCompanyViewController.companyInfoDelegate = self
        present(createCompanyNavigationController, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        fetchData()
        setupTableViewStyles()
    }
    
    private func fetchData() {
        // Get info from container created in CoreDataManager
        let context = CoreDataManager.shared.persitentDataContainer.viewContext
        // Create fetch request
        // Tell Xcode what entity's info you want
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        // fetch the entity from the context and store it in a constant
        do {
            let allCompanies = try context.fetch(fetchRequest)
            self.companies = allCompanies
            self.tableView.reloadData()
        } catch let fetchError {
            print("Failed to fetch Companies objects: ", fetchError)
        }
    }
    
    // setupTableViewRows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }

    // setupTableViewCells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .backgroundTeal
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let company = companies[indexPath.row]
        var cellTextArray = [String]()
        if let name = company.name {
            cellTextArray.append(name)
        }
        if let foundedDate = company.founded {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let foundedDateString = dateFormatter.string(from: foundedDate)
            cellTextArray.append(foundedDateString)
        }
        let cellText = cellTextArray.joined(separator: " - ")
        cell.textLabel?.text = cellText
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    // Add Actions to TableCells
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteHandler)
        deleteAction.backgroundColor = .navbarRed
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandler)
        editAction.backgroundColor = .backgroundDarkBlue
        return [deleteAction, editAction]
    }
    
    private func deleteHandler(action: UITableViewRowAction, indexPath: IndexPath) -> Void {
        // Remove entry from companies array and from the tableView
        let company = self.companies[indexPath.row]
        self.companies.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        // Get the company object from CoreData and delete it
        let context = CoreDataManager.shared.persitentDataContainer.viewContext
        context.delete(company)
        do {
            try context.save()
        } catch let deleteSaveError {
            print("Failed to save the delete of a company", deleteSaveError)
        }
    }
    
    private func editHandler(action: UITableViewRowAction, indexPath: IndexPath) -> Void {
        let editCompanyViewController = CompanyInfoViewController()
        let editCompanyNavigationController = UINavigationController(rootViewController: editCompanyViewController)
        editCompanyViewController.company = companies[indexPath.row]
        editCompanyViewController.companyInfoDelegate = self
        present(editCompanyNavigationController, animated: true, completion: nil)
    }
    
    // setupTableHeaderCell
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .backgroundPaleBlue
        return view
    }
    
    // setupTableHeaderCellHeight
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    private func setupTableViewStyles() {
        tableView.backgroundColor = .backgroundDarkBlue
        tableView.separatorColor = .white
    }
    
    // Company objects
    var companies = [Company]()
    
    // Conform to NewCompanyViewControllerDelegate
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

