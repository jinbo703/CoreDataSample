//
//  EmployeesController.swift
//  coredatacourse
//
//  Created by Max Nelson on 1/22/18.
//  Copyright © 2018 AsherApps. All rights reserved.
//

import UIKit
import CoreData

class TabbedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 16, 0, 0)))
    }
    
}

class EmployeeCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tealColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
//        employees.append(employee)
//        tableView.reloadData()

        guard let employeeType = employee.type else { return }
        guard let section = employeeTypes.index(of: employeeType) else { return }
        let row = allEmployees[section].count
        let insertionIP = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [insertionIP], with: .middle)
    }
    
    var company: Company?
    
    var employees = [Employee]()
    var cellId = "cellId"

    var allEmployees = [[Employee]]()
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Simpleton.rawValue,
        EmployeeType.Intern.rawValue
    ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        allEmployees = []
        for employeeType in employeeTypes {
            allEmployees.append(companyEmployees.filter { $0.type == employeeType })
        }
        
//        self.employees = companyEmployees
        
//        print("attempting to fetch emps")
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//
//        let request = NSFetchRequest<Employee>(entityName: "Employee")
//
//        do {
//            self.employees = try context.fetch(request)
//            
//            employees.forEach{print("Employee name:", $0.name ?? "")}
//
//        } catch let err {
//            print("Failed to fetch employees:",err)
//        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = TabbedLabel()
        label.text = employeeTypes[section]
        label.backgroundColor = .lightBlue
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmployeeCell

        let employee = allEmployees[indexPath.section][indexPath.row]
    
        cell.textLabel?.text = employee.fullName
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.fullName ?? "")    \(dateFormatter.string(from: birthday))"
        } else
        if let taxId = employee.employeeInformation?.taxId {
            cell.textLabel?.text = employee.fullName! + " taxId: " + taxId
        }
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = .white
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEmployees()
        view.backgroundColor = .darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: cellId)
    }

    @objc func handleAdd() {
        let employeeController = CreateEmployeeController()
        employeeController.delegate = self
        employeeController.company = company
        let navController = UINavigationController(rootViewController: employeeController)
        present(navController, animated: true, completion: nil)
    }

}
