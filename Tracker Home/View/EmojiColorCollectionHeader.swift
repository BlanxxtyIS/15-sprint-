//
//  EmojiColorCollectionHeader.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 15.01.2024.
//

import UIKit

class EmojiColorCollectionHeader: UICollectionReusableView {
    
    let identifier = "emojiColorCollectionHeader"
    
    let titleLabel: UILabel = {
       let title = UILabel()
        title.font = .systemFont(ofSize: 19, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
