//
//  HelperFunc.swift
//  ChatsApp
//
//  Created by Mahmoud Sherbeny on 11/2/20.
//

import UIKit

func dateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    dateFormatter.dateFormat = DATEFORMAT
    return dateFormatter
}

func timeElapsed(date: Date) -> String {
    
    let seconds = NSDate().timeIntervalSince(date)
    
    var elapsed: String?
    
    if (seconds < 60) {
        elapsed = "Just now"
    } else if (seconds < 60 * 60) {
        let minutes = Int(seconds / 60)
        
        var minText = "min"
        if minutes > 1 {
            minText = "mins"
        }
        elapsed = "\(minutes) \(minText)"
        
    } else if (seconds < 24 * 60 * 60) {
        let hours = Int(seconds / (60 * 60))
        var hourText = "hour"
        if hours > 1 {
            hourText = "hours"
        }
        elapsed = "\(hours) \(hourText)"
    } else {
        let currentDateFormater = dateFormatter()
        currentDateFormater.dateFormat = "yyyy-MM-dd"
        
        elapsed = "\(currentDateFormater.string(from: date))"
    }
    
    return elapsed!
}

func imageToString(image: UIImage) -> String {
    let imageComp = image.jpegData(compressionQuality: 0.5)
    guard let imageDecode = imageComp?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) else { return ""}
    return imageDecode
}

func stringToImage(stringImage: String, complation: @escaping (_ image: UIImage?) -> ()) {
    var image: UIImage?
    let imageData = NSData(base64Encoded: stringImage, options: NSData.Base64DecodingOptions(rawValue: 0))
    image = UIImage(data: imageData! as Data)
    complation(image)
}

func createChatRoom(sUserId: String, rUserId: String) -> String {
    let compareTwoIds = sUserId.compare(rUserId).rawValue
    
    if compareTwoIds > 0 {
        return sUserId + rUserId
    } else {
        return rUserId + sUserId
    }
}
