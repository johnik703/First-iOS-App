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
        // Create a container to hold the context data
        // Tell Xcode what file to go to
        let container = NSPersistentContainer(name: "CompanyModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        return container
    }()
}

// In CoreDataManager, Create a container to hold the data for a specific model(file).
// In the main view(CompaniesController) load up all the data from an entity(Company) in the container created here.
// In the add view(NewCompanyController) select an entity(Company) from the container created here, and add some data to that entity(name), then save it back to the entity and save the entire container's context, and send call to the delegate's didSaveCompany function.
// In the main view(CompaniesController) load up all the data from the entity(Company) in the container created here, then activate that call to didSaveCompany(), which updates the tableview with another row to display the newly saved company in the CoreData.
