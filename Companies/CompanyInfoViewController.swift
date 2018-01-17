//
//  NewCompanyViewController.swift
//  Companies
//
//  Created by Daniel Peach on 1/13/18.
//  Copyright © 2018 Daniel Peach. All rights reserved.
//

import UIKit
import CoreData

protocol CompanyInfoViewControllerDelegate {
    func didSaveNewCompany(company: Company)
    func didSaveUpdatedCompany(company: Company)
}

class CompanyInfoViewController: UIViewController {
    
    var company: Company? {
        didSet {
            nameInputField.text = company?.name
            guard let founded = company?.founded else { return }
            datePicker.date = founded
        }
    }
    
    var companyInfoDelegate: CompanyInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        setupView()
    }
    
    private func setupView() {
        setupViewStyles()
        setupNavigationBar()
        layoutViews()
    }
    
    private func setupViewStyles() {
        view.backgroundColor = .backgroundDarkBlue
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleNewCompanyCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleNewCompanySave))
    }
    
    // (Cancel) Button Pressed
    @objc private func handleNewCompanyCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // (Save Company Info) Button Pressed
    @objc private func handleNewCompanySave() {
        company == nil ? createNewCompany() : editExistingCompany()
    }
    
    // handle new company
    private func createNewCompany() {
        // Get info from container created in CoreDataManager
        let context = CoreDataManager.shared.persitentDataContainer.viewContext
        // Insert an entity into the container
        let newCompany = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        // Save values to entity in the container
        newCompany.setValue(nameInputField.text, forKey: "name")
        newCompany.setValue(datePicker.date, forKey: "founded")
        // Perform the save of the data in the container
        do {
            try context.save()
            // on success, do:
            dismiss(animated: true, completion:  {
                // call didSaveCompany of the delegate (CompaniesController)
                self.companyInfoDelegate?.didSaveNewCompany(company: newCompany as! Company)
            })
        } catch let createSaveError {
            print("Failed to save new company to the Core Data", createSaveError)
        }
    }
    
    // handle company update
    private func editExistingCompany() {
        let context = CoreDataManager.shared.persitentDataContainer.viewContext
        company?.name = nameInputField.text
        company?.founded = datePicker.date
        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.companyInfoDelegate?.didSaveUpdatedCompany(company: self.company as Company!)
            })
        } catch let updateSaveError {
            print("Failed to save updated company to the Core Data", updateSaveError)
        }
    }
    
    // Create Views
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundPaleBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let nameLabelView: UILabel = {
        let label = UILabel()
        label.text = "Name: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let nameInputField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter Company Name"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    private func layoutViews() {
        // backgroundView
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
                backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                backgroundView.heightAnchor.constraint(equalToConstant: 300),
            ])
        // nameLabelView
        view.addSubview(nameLabelView)
        NSLayoutConstraint.activate([
                nameLabelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                nameLabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
                nameLabelView.widthAnchor.constraint(equalToConstant: 100),
                nameLabelView.heightAnchor.constraint(equalToConstant: 50),
            ])
        // nameInputField
        view.addSubview(nameInputField)
        NSLayoutConstraint.activate([
                nameInputField.topAnchor.constraint(equalTo: nameLabelView.topAnchor),
                nameInputField.leadingAnchor.constraint(equalTo: nameLabelView.trailingAnchor),
                nameInputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                nameInputField.bottomAnchor.constraint(equalTo: nameLabelView.bottomAnchor),
            ])
        // datePicker
        view.addSubview(datePicker)
        NSLayoutConstraint.activate([
                datePicker.topAnchor.constraint(equalTo: nameLabelView.bottomAnchor),
                datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                
            ])
    }
}
