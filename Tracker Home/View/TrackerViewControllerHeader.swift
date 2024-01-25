//
//  TrackerViewControllerHeader.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 27.12.2023.
//

import UIKit

//HEADER ячеек
class TrackerViewControllerHeader: UICollectionReusableView {
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 19, weight: .bold)
        title.numberOfLines = 1
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
