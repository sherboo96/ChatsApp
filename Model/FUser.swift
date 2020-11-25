//
//  FUser.swift
//  ChatsApp
//
//  Created by Mahmoud Sherbeny on 11/2/20.
//

import Foundation
import Firebase
import ProgressHUD

class FUser {
    
    var objectId: String
    var username: String
    var createdAt: Date
    var updatedAt: Date
    var email: String
    var profileImage: String
    
    init(objectId: String, username: String, createdAt: Date, updatedAt: Date, email: String, profileImage: String) {
        self.objectId = objectId
        self.username = username
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.email = email
        self.profileImage = profileImage
    }
    
    init(_ dictionary: NSDictionary) {
        objectId = dictionary[KOBJECTID] as! String
        
        if let name = dictionary[KFULLNAME] as? String {
            username = name
        } else {
            username = ""
        }
        
        if let created = dictionary[KCREATEAT] as? String {
            createdAt = dateFormatter().date(from: created)!
        } else {
            createdAt = Date()
        }
        
        if let updated = dictionary[KUPDATEDAT] as? String {
            updatedAt = dateFormatter().date(from: updated)!
        } else {
            updatedAt = Date()
        }
        
        if let mail = dictionary[KEMAIL] as? String {
            email = mail
        } else {
            email = ""
        }
        
        if let profile = dictionary[KAVATAR] as? String {
            profileImage = profile
        } else {
            profileImage = ""
        }
    }
    
    class func currentID() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> FUser? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.dictionary(forKey: KCURRENTUSER) {
                return FUser(dictionary as NSDictionary)
            }
        }
        return nil
    }
}

func savaLocally(user: FUser) {
    UserDefaults.standard.setValue(getUserDictionary(user: user), forKey: KCURRENTUSER)
    UserDefaults.standard.synchronize()
}

func saveCurrentUserLocally(userId: String, complation: @escaping (_ status: Bool) -> ()) {
    let currentUSer = DBREF.child(referance(.User)).child(userId)
    
    currentUSer.observeSingleEvent(of: .value) { (snapShot) in
        if snapShot.exists() {
            let userDic = snapShot.value as! [String: Any]
            savaLocally(user: FUser(userDic as NSDictionary))
            complation(true)
        } else {
            complation(false)
        }
    }
}

func getUserDictionary(user: FUser) -> NSDictionary {
    
    let created = dateFormatter().string(from: user.createdAt)
    let updated = dateFormatter().string(from: user.updatedAt)
    
    return NSDictionary(objects: [user.objectId, created, updated, user.username, user.email, user.profileImage], forKeys: [KOBJECTID as NSCopying, KCREATEAT as NSCopying, KUPDATEDAT as NSCopying, KFULLNAME as NSCopying, KEMAIL as NSCopying, KAVATAR as NSCopying])
}

func createNewUser(user: FUser) {
    DBREF.child(referance(.User)).child(user.objectId).setValue(getUserDictionary(user: user)) { (error, dataRef) in
        if error != nil {
            ProgressHUD.showError(error!.localizedDescription)
            return
        } else {
            savaLocally(user: user)
        }
    }
}

func deleteUser(userId: String) {
    DBREF.child(referance(.User)).child(userId).removeAllObservers()
    try! Auth.auth().signOut()
    Auth.auth().currentUser!.delete(completion: { (error) in
        if error != nil {
            ProgressHUD.showError(error!.localizedDescription)
            return
        } else {
            ProgressHUD.showSuccess("Account Delected")
        }
    })
}
