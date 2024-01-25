//
//  EmojiColorCell.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 15.01.2024.
//

import UIKit

class EmojiColorCollectionCell: UICollectionViewCell {
    let identifier = "emojiColorCollectionCell"
    
    var lastIndexPath: IndexPath? = nil
    
    var emoji: UILabel = {
        let emoji = UILabel()
        emoji.font = .systemFont(ofSize: 32, weight: .bold)
        emoji.textAlignment = .center
        emoji.translatesAutoresizingMaskIntoConstraints = false
        return emoji
    }()
    
    var color: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(named: "color1")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emoji)
        contentView.addSubview(color)
        contentView.layer.cornerRadius = 16
        
        
        NSLayoutConstraint.activate([
            emoji.heightAnchor.constraint(equalToConstant: 32),
            emoji.widthAnchor.constraint(equalToConstant: 38),
            emoji.centerYAnchor.constraint(equalTo: centerYAnchor),
            emoji.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            color.heightAnchor.constraint(equalToConstant: 40),
            color.widthAnchor.constraint(equalToConstant: 40),
            color.centerXAnchor.constraint(equalTo: centerXAnchor),
            color.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func destroyCell(_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            contentView.backgroundColor = .udWhiteDay
        } else {
            contentView.layer.masksToBounds = false
            contentView.layer.borderWidth = 0.0
        }
    }
}
    


    
    

