//
//  EmployeesController.swift
//  Companies
//
//  Created by Daniel Peach on 1/20/18.
//  Copyright © 2018 Daniel Peach. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let customInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, customInsets)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController, EmployeeInfoControllerDelegate {
    
    // Conform to EmployeeInfoControllerDelegate
    func didAddEmployee(employee: Employee) {
        guard let type = employee.type else { return }
        guard let section = employeeTypes.index(of: type) else { return }
        let row = allEmployees[section].count
        let indexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [indexPath], with: .middle)
    }
    
    var company: Company?
    let cellId = "employeeCell"
    
    var executives = [Employee]()
    var management = [Employee]()
    var staff = [Employee]()
    var allEmployees = [[Employee]]()
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.Management.rawValue,
        EmployeeType.Staff.rawValue,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = company?.name
        setupPlusButtonOnNavBar(selector: #selector(handleAddEmployee))
    }
    
    // (Add Employee) Button Pressed
    @objc private func handleAddEmployee() {
        let addEmployeeViewController = EmployeeInfoController()
        addEmployeeViewController.delegate = self
        addEmployeeViewController.company = company
        let addEmployeeNavigationController = UINavigationController(rootViewController: addEmployeeViewController)
        present(addEmployeeNavigationController, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId) 
        fetchEmployees()
    }
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employeeSet?.allObjects as? [Employee] else { return }
        allEmployees = []
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(
                companyEmployees.filter { $0.type == employeeType }
            )
        }
    }
    
    // Setup TableViewSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.backgroundColor = UIColor.backgroundPaleBlue
        label.textColor = UIColor.darkBlue
        label.text = employeeTypes[section]
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // Setup TableViewRows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // Setup TableViewCells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
//        let employee = employees[indexPath.row]
        let employee = allEmployees[indexPath.section][indexPath.row]
        var employeeLabelTextArray = [String]()
        if let name = employee.name {
            employeeLabelTextArray.append(name)
        }
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let formattedDateString = dateFormatter.string(from: birthday)
            employeeLabelTextArray.append(formattedDateString)
        }
        cell.textLabel?.text = employeeLabelTextArray.joined(separator: " - ")
        cell.backgroundColor = .mainTeal
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
}
