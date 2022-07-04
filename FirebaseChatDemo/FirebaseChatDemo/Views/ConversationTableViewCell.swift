//
//  ConversationTableViewCell.swift
//  FirebaseChatDemo
//
//  Created by Jay Buddhdev on 04/07/22.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(model: Conversation){
        self.nameLabel.text = model.name
        self.messageLabel.text = model.latestMessage.text
    }
}
