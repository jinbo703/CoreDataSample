//
//  ViewController.swift
//  coredatacourse
//
//  Created by Max Nelson on 1/5/18.
//  Copyright © 2018 AsherApps. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var cellId:String = "cellId"
    var companies = [Company]()
    
    @objc private func doWork() {
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            (0...10).forEach { (val) in
                print(val)
                let company = Company(context: backgroundContext)
                company.name = String(val)
            }
            do {
                try backgroundContext.save()
                self.companies = CoreDataManager.shared.fetchCompanies()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let err { print("err saving:",err) }
        })
        
        // GCD - Grand Central Dispatch
        DispatchQueue.global(qos: .background).async {
            
        }
    }
    
    //trippy core data updates
    @objc func doUpdates() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                })
                do {
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                }
                catch let saveErr {
                    print("failed to save on background thread:", saveErr)
                }
            } catch let err {
                print("errfetching companies on background:",err)
            }
           
        }
    }
    
    @objc fileprivate func doNestedUpdates() {
        print("nested application updates")
        
        
        DispatchQueue.global(qos: .background).async {
            
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies = try privateContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    //after save succeeds
                    DispatchQueue.main.async {
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            if context.hasChanges {
                                try context.save()
                            }
                            self.tableView.reloadData()
                        } catch let err {
                            print("faield to save main context:",err)
                        }
                        
                    }
                } catch let err {
                    print("err saving on private context:",err)
                }
            }
            catch let err { print("err fetching on private context:",err)}
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        doWork()
//        companies = CoreDataManager.shared.fetchCompanies()
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(self.handleReset)),
            UIBarButtonItem(title: "Nested Updates", style: .done, target: self, action: #selector(self.doNestedUpdates))
        ]
        tableView.backgroundColor = UIColor.darkBlue
        tableView.tableFooterView = UIView()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = .white
        navigationItem.title = "Companies"
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
    }
    
    @objc private func handleReset() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)

        } catch let err { print("failed to delete objects from core data:",err)}
    }
    
    @objc func handleAddCompany() {
        print("adding company")
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        present(navController, animated: true  , completion: nil)
    }
    
}

