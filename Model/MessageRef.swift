//
//  MessageRef.swift
//  ChatsApp
//
//  Created by Mahmoud Sherbeny on 11/15/20.
//

import Foundation

enum MessageType: String {
    case phote
    case text
    case video
    case audio
}

func messageType(message: MessageType) -> String {
    return message.rawValue
}
