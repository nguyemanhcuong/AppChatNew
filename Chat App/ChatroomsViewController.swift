//
//  ChatroomsViewController.swift
//  Chat App
//
//  Created by cuongDeptrai on 3/23/19.
//  Copyright © 2019 cuongDeptrai. All rights reserved.
//

import UIKit
import Firebase
class ChatroomsViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    @IBOutlet var chatTableView: UITableView!
   
    var room: Room?
    @IBOutlet var ChatTextFiled: UITextField!
    
    var chatMessage = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        getUsernameWithId(id: Auth.auth().currentUser!.uid) { (userName) in
            
            print(userName)
            
        }
        observeMessages()
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        
        title = room?.roomName
        
    }
    
    
    func observeMessages() {
         guard let roomId = self.room?.roomId else { return }
         let databaseRef = Database.database().reference()
        
        databaseRef.child("rooms").child(roomId).child("messages").observe(.childAdded) { (snapshot) in
            if let dataArray = snapshot.value as? [String : Any] {
                guard let senderName = dataArray["senderName"] as? String , let messagetext = dataArray["text"] as? String,
                 let userId = dataArray["senderId"] as? String else { return}
                
                let message = Message.init(messageKey: snapshot.key, senderName: senderName, messageText: messagetext , userId: userId)
                self.chatMessage.append(message)
                self.chatTableView.reloadData()
                                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.chatMessage[indexPath.row]
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
        
//        cell.UserNameLabel.text = message.senderName
//        cell.ChatTextView.text = message.messageText
//
        cell.setMessageData(message: message)
        if (message.userId == Auth.auth().currentUser?.uid) {
            cell.setBubbleType(type: .outgoing)
        } else {
            cell.setBubbleType(type: .incoming)
        }
        
        return cell
        
    }
    func getUsernameWithId(id: String , completion: @escaping (_ userName: String?) -> () ) {
        
        let databaseRef = Database.database().reference()
        let user = databaseRef.child("users").child(id)
        
        user.child("username").observeSingleEvent(of: .value) { (snapshot) in
            
            if let userName = snapshot.value as? String {
                completion(userName)
            } else {
                
                completion(nil)
            }
        }
    }
    
    
    func sendMessage(text: String , completion: @escaping (_ isSuccess: Bool ) -> () ) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
         let databaseRef = Database.database().reference()
        getUsernameWithId(id: userId) { (userName) in
            if let userName = userName as? String {
                //                print("username is \(userName)")
                
                if let roomId = self.room?.roomId  , let userId = Auth.auth().currentUser?.uid {
                    let dataArray : [String:Any] = ["senderName": userName , "text": text , "senderId": userId]
                    let room =   databaseRef.child("rooms").child(roomId)
                    room.child("messages").childByAutoId().setValue(dataArray, withCompletionBlock: { (error, ref) in
                        if (error == nil ) {
                            completion(true)
                            
                            //print("Room Add to database succseflly")
                        }else {
                            completion(false)
                            
                        }
                    })
                }
            }
        }
    
        }
    
    
    
    @IBAction func DidPressSendButton(_ sender: UIButton) {
        guard let chatText = self.ChatTextFiled.text , chatText.isEmpty == false , let userId = Auth.auth().currentUser?.uid  else { return }
        
        sendMessage(text: chatText) { (isSuccess) in
            if (isSuccess) {
                self.ChatTextFiled.text = ""
                
            }
            
        }
    }
    
    
}
