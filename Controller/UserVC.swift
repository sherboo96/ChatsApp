//
//  UserVC.swift
//  ChatsApp
//
//  Created by Mahmoud Sherbeny on 11/2/20.
//

import UIKit
import Firebase

class UserVC: UIViewController {

    //MARK: - IBOulet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //MARK: - Variable
    var users = [FUser]()
    
    //MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUsers()
    }
    

    //MARK: - IBAction
    
    //MARK: - Helper Function
    func setupUI() {
        tableView.tableFooterView = UIView()
        self.backView.isHidden = false
        self.indicator.startAnimating()
    }
    
    func getUsers() {
        DBREF.child(referance(.User)).observe(.value) { (snapShot) in
            let userDic = snapShot.value as! [String: Any]
            for (_, value) in userDic {
                let fUser = FUser(value as! NSDictionary)
                if fUser.objectId != FUser.currentID() {
                    self.users.append(fUser)
                }
            }
            self.backView.isHidden = true
            self.indicator.stopAnimating()
            self.tableView.reloadData()
        }
    }

}

extension UserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
        cell.nameText.text = users[indexPath.row].username
        cell.mailText.text = users[indexPath.row].email
        
        stringToImage(stringImage: users[indexPath.row].profileImage) { (image) in
            cell.profileImage.image = image!.circleMasked
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREENHEIGHT / 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Message", bundle: nil).instantiateViewController(identifier: "MessageVC") as! MessageVC
        vc.users = [FUser.currentUser()!, users[indexPath.row]]
        vc.usersIDs = [FUser.currentID(), users[indexPath.row].objectId]
        vc.chatRoom = createChatRoom(sUserId: FUser.currentID(), rUserId: users[indexPath.row].objectId)
        navigationController?.pushViewController(vc, animated: true)
    }
}
