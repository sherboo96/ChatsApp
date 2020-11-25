//
//  MessageVC.swift
//  ChatsApp
//
//  Created by Mahmoud Sherbeny on 11/2/20.
//

import UIKit


class MessageVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var senderBtn: UIButton!
    
    //MARK: - Variable
    var usersIDs = [String]()
    var users = [FUser]()
    var chatRoom: String!
    var messages = [FMessage]()
    
    
    //MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    //MARK: - IBAction
    @IBAction func sendMessageTapped(_ sender: Any) {
        
        senderBtn.isEnabled = false
        
        if messageText.text != "" {
            sendMessage(text: messageText.text!, image: nil)
        }
        
        senderBtn.isEnabled = true
    }
    

    //MARK: - Helper Function
    func setupUI() {
        tableView.rowHeight = tableView.estimatedRowHeight
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        
        messages = []
        getAllMessages()
        
    }
    
    func sendMessage(text: String?, image: String?) {
        if let text = text {
            let messageID = UUID().uuidString
            
            let goingMessage = OutMessage(message: text, senderId: FUser.currentID(), senderName: FUser.currentUser()?.username ?? "", date: Date(), messageType: messageType(message: .text), type: KPRIVATE, messageId: messageID)
            
            goingMessage.sendMessage(chatRoomId: chatRoom, messageDictionary: goingMessage.outingMessage, membersIds: usersIDs)
        }
    }
    
    func getAllMessages() {
        DBREF.child(referance(.Message)).child(FUser.currentID()).child(chatRoom).queryOrdered(byChild: KDATE).observe(.childAdded) { (dataSnapShot) in
            let data = dataSnapShot.value as! NSDictionary
            let newMesage = FMessage(data)
            self.messages.append(newMesage)
            self.tableView.reloadData()
            self.scrollDown()
        }
    }
    
    func scrollDown() {
        DispatchQueue.main.async {
            let index = IndexPath(row: self.messages.count - 1, section: 0)
            if index.row > 0 {
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }
        }
    }

}

extension MessageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].type == messageType(message: .text) {
            if messages[indexPath.row].senderId == FUser.currentID() {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SCell", for: indexPath) as! SMessageCell
                cell.messageText.text = messages[indexPath.row].message
                print(timeElapsed(date: messages[indexPath.row].date))
                cell.messageTime.text = timeElapsed(date: messages[indexPath.row].date)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RCell", for: indexPath) as! RMessageCell
                cell.messageText.text = messages[indexPath.row].message
                cell.messageTime.text = timeElapsed(date: messages[indexPath.row].date)
                return cell
            }
        } else {
            if messages[indexPath.row].senderId == FUser.currentID() {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SICell", for: indexPath) as! SIMessageCell
//                cell.messageText.text = messages[indexPath.row].message
                print(timeElapsed(date: messages[indexPath.row].date))
                cell.messageTime.text = timeElapsed(date: messages[indexPath.row].date)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RICell", for: indexPath) as! RIMessageCell
//                cell.messageImage.image = messages[indexPath.row].picture
                cell.messageTime.text = timeElapsed(date: messages[indexPath.row].date)
                return cell
            }
        }
        
    }
    
}
