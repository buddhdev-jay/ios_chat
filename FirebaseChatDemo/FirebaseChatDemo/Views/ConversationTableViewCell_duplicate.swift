//
//  ConversationTableViewCell.swift
//  FirebaseChatDemo
//
//  Created by Jay Buddhdev on 04/07/22.
//

import UIKit

class ConversationTableViewCell_duplicate: UITableViewCell {

    
    private var userNameLabel : UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        return label
    }
    
    private var userMessage : UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        return label
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
}
