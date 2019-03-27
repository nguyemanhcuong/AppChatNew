//
//  ChatCell.swift
//  Chat App
//
//  Created by cuongDeptrai on 3/23/19.
//  Copyright © 2019 cuongDeptrai. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    enum bubbleType {
        case incoming
        case outgoing
    }
    @IBOutlet var ChatTextView: UITextView!
    @IBOutlet var UserNameLabel: UILabel!
    
    @IBOutlet var chatTextBundel: UIView!
    @IBOutlet var chatStack: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        chatTextBundel.layer.cornerRadius = 10
        
    }
    
    func setMessageData(message: Message) {
        UserNameLabel.text = message.senderName
        ChatTextView.text = message.messageText
    }
    
    func setBubbleType(type: bubbleType) {
        if (type == .incoming) {
            chatStack.alignment = .leading
            chatTextBundel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            ChatTextView.textColor = .black
            
            
            
        } else if (type == .outgoing) {

            chatStack.alignment = .trailing
            chatTextBundel.backgroundColor = #colorLiteral(red: 0.9344248723, green: 1, blue: 0.2643673962, alpha: 1)
            ChatTextView.textColor = .blue
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
