//
//  CompanyCell.swift
//  Companies
//
//  Created by Daniel Peach on 1/18/18.
//  Copyright © 2018 Daniel Peach. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            var cellTextArray = [String]()
            if let name = company?.name {
                cellTextArray.append(name)
            }
            if let foundedDate = company?.founded {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let formattedDateString = dateFormatter.string(from: foundedDate)
                cellTextArray.append(formattedDateString)
            }
            if let imageData = company?.imageData {
                let image = UIImage(data: imageData)
                companyImageView.image = image
            }
            nameFoundedDateLabel.text = cellTextArray.joined(separator: " - ")
        }
    }
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "add_image"))
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 1 
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "COMPANY NAME"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add ImageView
        addSubview(companyImageView)
        NSLayoutConstraint.activate([
                companyImageView.heightAnchor.constraint(equalToConstant: 50),
                companyImageView.widthAnchor.constraint(equalToConstant: 50),
                companyImageView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
                companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        // Add Name/Founded Label
        addSubview(nameFoundedDateLabel)
        NSLayoutConstraint.activate([
            nameFoundedDateLabel.leadingAnchor.constraint(equalTo: companyImageView.trailingAnchor, constant: 16),
                nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor),
                nameFoundedDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
