//
//  FMessage.swift
//  ChatsApp
//
//  Created by Mahmoud Sherbeny on 11/2/20.
//

import Foundation

class FMessage {
    var message: String
    var senderId: String
    var senderName: String
    var date: Date
    var type: String
    var messageId: String
    var picture: String
    
    init(message: String, senderId: String, senderName: String, date: Date, type: String, messageId: String, picture: String) {
        self.message = message
        self.senderId = senderId
        self.senderName = senderName
        self.date = date
        self.type = type
        self.messageId = messageId
        self.picture = picture
    }
    
    init(_ dictionary: NSDictionary) {
        if let messageText = dictionary[KMESSAGE] as? String {
            message = messageText
        } else {
            message = ""
        }
        
        if let senderID = dictionary[KSENDERID] as? String {
            senderId = senderID
        } else {
            senderId = ""
        }
        
        if let senderNAMe = dictionary[KSENDERNAME] as? String {
            senderName = senderNAMe
        } else {
            senderName = ""
        }
        
        if let datee = dictionary[KDATE] as? String {
            date = dateFormatter().date(from: datee)!
        } else {
            date = Date()
        }
        
        if let types = dictionary[KTYPE] as? String {
            type = types
        } else {
            type = ""
        }
        
        if let messageID = dictionary[KMESSAGEID] as? String {
            messageId = messageID
        } else {
            messageId = ""
        }
        
        if let pic = dictionary[KPICTURE] as? String {
            picture = pic
        } else {
            picture = ""
        }
    }
}
