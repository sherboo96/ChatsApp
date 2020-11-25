//
//  Referance.swift
//  ChatsApp
//
//  Created by Mahmoud Sherbeny on 11/2/20.
//

import Foundation

enum referanceCode: String {
    case User
    case Message
    case Recent
}

func referance(_ ref: referanceCode) -> String {
    return ref.rawValue
}
