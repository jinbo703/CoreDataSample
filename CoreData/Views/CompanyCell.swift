//
//  CompanyCell.swift
//  coredatacourse
//
//  Created by Max Nelson on 1/22/18.
//  Copyright © 2018 AsherApps. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            guard let company = company else { return }
            if let name = company.name, let founded = company.founded {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                nameFoundedDateLabel.text = "\(name) - Founded: \(dateFormatter.string(from: founded))"
            } else {
                nameFoundedDateLabel.text = company.name
                nameFoundedDateLabel.text = "\(company.name ?? "") \(company.numEmployees ?? "")"
            }
            if let imageData = company.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "company name goes here"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tealColor
        
        addSubview(companyImageView)
        companyImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(nameFoundedDateLabel)
        nameFoundedDateLabel.anchor(top: nil, left: companyImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 40)
        
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameFoundedDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
