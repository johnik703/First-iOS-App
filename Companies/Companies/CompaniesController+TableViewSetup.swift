//
//  CompaniesController+UITableViewDelegate.swift
//  Companies
//
//  Created by Daniel Peach on 1/20/18.
//  Copyright © 2018 Daniel Peach. All rights reserved.
//

import UIKit

extension CompaniesController {
    
    func setupTableView() {
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        self.companies = CoreDataManager.shared.fetchCompanies()
        setupTableViewStyles()
    }
    
    private func setupTableViewStyles() {
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
    }
    
    // setupTableViewRows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // setupTableViewCells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell
        cell.backgroundColor = .mainTeal
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let company = companies[indexPath.row]
        cell.company = company
        return cell
    }
    
    // Add Actions to TableCells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = companies[indexPath.row]
        let employeesController = EmployeesController()
        employeesController.company = company
        navigationController?.pushViewController(employeesController, animated: true)
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteHandler)
        deleteAction.backgroundColor = .mainRed
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandler)
        editAction.backgroundColor = .darkBlue
        return [deleteAction, editAction]
    }
    private func deleteHandler(action: UITableViewRowAction, indexPath: IndexPath) -> Void {
        let company = self.companies[indexPath.row]
        self.companies.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
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
    
    // setupTableHeader
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .backgroundPaleBlue
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // setupTableFooter
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
}
