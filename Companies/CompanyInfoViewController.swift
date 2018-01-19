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

class CompanyInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var company: Company? {
        didSet {
            nameInputField.text = company?.name
            guard let founded = company?.founded else { return }
            datePicker.date = founded
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }
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
        if let companyImage = companyImageView.image {
            let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
            newCompany.setValue(imageData, forKey: "imageData")
        }
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
        if let companyImage = companyImageView.image {
            let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
            company?.imageData = imageData
        }
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
    // lazy lets the self wait to be set until after class is created.
//    lazy var companyImageView: UIImageView = {
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.isUserInteractionEnabled = true // remember to do this, otherwise image views by default are not interactive
//
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
//
//        return imageView
//    }()
//
//    @objc private func handleSelectPhoto() {
//        print("Trying to select photo...")
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.allowsEditing = true
//        present(imagePickerController, animated: true, completion: nil)
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
//            companyImageView.image = editedImage
//        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            companyImageView.image = originalImage
//        }
//        setupCircularImageStyle()
//        dismiss(animated: true, completion: nil)
//
//    }
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "add_image"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imageView
    }()

    // Setup ImagePicker
    @objc private func handleSelectPhoto() {
        print("selected Photo")

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            companyImageView.image = originalImage
        }

        setupCircularImageStyle()
        dismiss(animated: true, completion: nil)
    }
    private func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.backgroundDarkBlue.cgColor
        companyImageView.layer.borderWidth = 2
    }
//    private func setupCircularImageStyle() {
//        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
//        companyImageView.clipsToBounds = true
//        companyImageView.layer.borderColor = UIColor.backgroundDarkBlue.cgColor
//        companyImageView.layer.borderWidth = 2
//    }
    
    // viewWillAppear
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
                backgroundView.heightAnchor.constraint(equalToConstant: 350),
            ])
        // companyImageView
        view.addSubview(companyImageView)
        NSLayoutConstraint.activate([
                companyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                companyImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                companyImageView.heightAnchor.constraint(equalToConstant: 100),
                companyImageView.widthAnchor.constraint(equalToConstant: 100),
            ])
        // nameLabelView
        view.addSubview(nameLabelView)
        NSLayoutConstraint.activate([
                nameLabelView.topAnchor.constraint(equalTo: companyImageView.bottomAnchor),
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
