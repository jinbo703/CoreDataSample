//
//  CustomMigrationPolicy.swift
//  coredatacourse
//
//  Created by Max Nelson on 1/25/18.
//  Copyright © 2018 AsherApps. All rights reserved.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    //type out transformation function
    @objc func transformNumEmployees(forNum: NSNumber) -> String {
        if forNum.intValue < 150 {
            return "small"
        } else {
            return "v large"
        }
    }
}
