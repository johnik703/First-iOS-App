//
//  EmployeeInfoController.swift
//  Companies
//
//  Created by Daniel Peach on 1/20/18.
//  Copyright © 2018 Daniel Peach. All rights reserved.
//

import UIKit

protocol EmployeeInfoControllerDelegate{
    func didAddEmployee(employee: Employee)
}

class EmployeeInfoController: UIViewController {
    
    var company: Company?
    
    var delegate: EmployeeInfoControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .darkBlue
        setupNavigationBar()
        layoutViews()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Add Employee"
        setupCancelButton()
        setupSaveButton(selector: #selector(handleEmployeeInfoSave))
    }
    
    // (Save Employee Information) Button Pressed
    @objc private func handleEmployeeInfoSave() {
        guard let employeeName = nameInputField.text else { return }
        guard let company = company else { return }
        guard let birthdayText = birthdayInputField.text else { return }
        if birthdayText.isEmpty {
            showError(title: "Empty Birthday", message: "You have not entered a birthday.")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showError(title: "Bad Birthday", message: "You have not entered a valid birthday.")
            return
        }
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
        let tuple = CoreDataManager.shared.saveEmployee(name: employeeName, birthday: birthdayDate, employeeType: employeeType, company: company)
        if let saveErrorOccurred = tuple.1 {
            print(saveErrorOccurred)
        } else {
            dismiss(animated: true, completion: {
                self.delegate?.didAddEmployee(employee: tuple.0!)
            })
        }
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // Create Views
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let nameInputField: UITextField = {
        let inputField = UITextField()
        inputField.placeholder = "Enter Employee Name"
        inputField.translatesAutoresizingMaskIntoConstraints = false
        return inputField
    }()
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let birthdayInputField: UITextField = {
        let inputField = UITextField()
        inputField.placeholder = "MM/DD/YYYY"
        inputField.translatesAutoresizingMaskIntoConstraints = false
        return inputField
    }()
    let employeeTypeSegmentedControl: UISegmentedControl = {
        let types = [
            EmployeeType.Executive.rawValue,
            EmployeeType.Management.rawValue,
            EmployeeType.Staff.rawValue,
        ]
        let segmentedControl = UISegmentedControl(items: types)
        segmentedControl.tintColor = UIColor.darkBlue
        segmentedControl.selectedSegmentIndex = 2
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private func layoutViews() {
        _ = setupLightBlueBackground(withHeight: 150)
        // nameLabel
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
                nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                nameLabel.widthAnchor.constraint(equalToConstant: 100),
                nameLabel.heightAnchor.constraint(equalToConstant: 50),
            ])
        // nameInputField
        view.addSubview(nameInputField)
        NSLayoutConstraint.activate([
                nameInputField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
                nameInputField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
                nameInputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                nameInputField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
        ])
        // birthdayLabel
        view.addSubview(birthdayLabel)
        NSLayoutConstraint.activate([
                birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
                birthdayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                birthdayLabel.widthAnchor.constraint(equalToConstant: 100),
                birthdayLabel.heightAnchor.constraint(equalToConstant: 50),
            ])
        // birthdayInputField
        view.addSubview(birthdayInputField)
        NSLayoutConstraint.activate([
                birthdayInputField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor),
                birthdayInputField.leadingAnchor.constraint(equalTo: birthdayLabel.trailingAnchor),
                birthdayInputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                birthdayInputField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor),
            ])
        view.addSubview(employeeTypeSegmentedControl)
        NSLayoutConstraint.activate([
                employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor),
                employeeTypeSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                employeeTypeSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34),
            ])
        
    }
}
