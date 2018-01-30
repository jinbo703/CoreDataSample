//
//  CompaniesController+CreateCompany.swift
//  coredatacourse
//
//  Created by Max Nelson on 1/22/18.
//  Copyright © 2018 AsherApps. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
    
    //specify extension methods here dot dot dot. lol.
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        if let row = companies.index(of: company) {
            let reloadIndexPath = IndexPath(row: row, section: 0)
            tableView.reloadRows(at: [reloadIndexPath], with: .right)
        }
    }
    
}
