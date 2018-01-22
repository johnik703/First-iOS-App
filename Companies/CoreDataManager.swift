//
//  CoreDataManager.swift
//  Companies
//
//  Created by Daniel Peach on 1/14/18.
//  Copyright © 2018 Daniel Peach. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persitentDataContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CompanyModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        let context = persitentDataContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let allCompanies = try context.fetch(fetchRequest)
            return allCompanies
        } catch let fetchError {
            print("Failed to fetch Companies objects: ", fetchError)
            return []
        }
    }
    
    func deleteAllCompanies() -> Bool {
        let context = CoreDataManager.shared.persitentDataContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            return true
        } catch let deleteError {
            print("There was an error resetting the company objects", deleteError)
            return false
        }
    }
    
    func saveEmployee(name: String, birthday: Date, employeeType: String, company: Company) -> (Employee?, Error?) {
        let context = persitentDataContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.company = company
        employee.name = name
        employee.type = employeeType
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        employeeInformation.birthday = birthday
        employee.employeeInformation = employeeInformation
        do {
            try context.save()
            return (employee, nil)
        } catch let employeeSaveError {
            print("There was an error saving the employee", employeeSaveError)
            return (nil, employeeSaveError)
        }
    }
}
