//
//  OutMessage.swift
//  ChatsApp
//
//  Created by Mahmoud Sherbeny on 11/15/20.
//

import Foundation

class OutMessage {
    
    let outingMessage: NSMutableDictionary
    
    init(message: String, senderId: String, senderName: String, date: Date, messageType: String, type: String, messageId: String) {
        outingMessage = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().string(from: date), messageType, type, messageId], forKeys: [KMESSAGE as NSCopying, KSENDERID as NSCopying, KSECONDNAME as NSCopying, KDATE as NSCopying, KMESSAGETYPE as NSCopying, KTYPE as NSCopying, KMESSAGEID as NSCopying])
    }
    
    init(message: String, senderId: String, senderName: String, date: Date, messageType: String, type: String, messageId: String, imageLink: String) {
        outingMessage = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().string(from: date), messageType, type, messageId], forKeys: [KMESSAGE as NSCopying, KSENDERID as NSCopying, KSECONDNAME as NSCopying, KDATE as NSCopying, KMESSAGETYPE as NSCopying, KTYPE as NSCopying, KMESSAGEID as NSCopying, KPICTURE as NSCopying])
    }
    
    func sendMessage(chatRoomId: String, messageDictionary: NSMutableDictionary, membersIds: [String]) {
        let DB = DBREF.child(referance(.Message))
        for memberId in membersIds {
            DB.child(memberId).child(chatRoomId).child(messageDictionary[KMESSAGEID] as! String).setValue(messageDictionary as! [String: Any])
        }
    }
    
}
