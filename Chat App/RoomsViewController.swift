//
//  RoomsViewController.swift
//  Chat App
//
//  Created by cuongDeptrai on 3/23/19.
//  Copyright © 2019 cuongDeptrai. All rights reserved.
//

import UIKit

import Firebase

class RoomsViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var roomsTable: UITableView!
    var rooms = [Room]()
    @IBOutlet var newRomTexFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.roomsTable.delegate = self
          self.roomsTable.dataSource = self
        observeRooms()
    }
    override func viewDidAppear(_ animated: Bool) {
        if ( Auth.auth().currentUser == nil ) {
            self.presentLoginScreen()
        }
    }
    @IBAction func didPressLogout(_ sender: Any) {
        try! Auth.auth().signOut()
        self.presentLoginScreen()
    }
    func presentLoginScreen() {
        let formScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginSreen") as! ViewController
        self.present(formScreen, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = self.rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell")!
        
        cell.textLabel?.text = room.roomName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRoom = self.rooms[indexPath.row]
        let chatRoomView = self.storyboard?.instantiateViewController(withIdentifier: "Chatroom") as! ChatroomsViewController
        chatRoomView.room = selectedRoom
        self.navigationController?.pushViewController(chatRoomView, animated: true)
        
    }
    
    @IBAction func didPressCreateNewRoom(_ sender: UIButton) {
        guard let roomName = self.newRomTexFiled.text , roomName.isEmpty  == false  else { return }
        let databaseRef = Database.database().reference()
        let room = databaseRef.child("rooms").childByAutoId()
        
        let dataArray:[String : Any] = ["roomName" : roomName]
        room.setValue(dataArray) { (error, ref) in
            if (error == nil ) {
                self.newRomTexFiled.text = " "
            }
        }
    }
    
    func observeRooms() {
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").observe(.childAdded) { (snapshot) in
            if  let dataArray = snapshot.value as? [String: Any] {
                if let roomName = dataArray["roomName"] as? String {
                    let room =  Room.init(roomId: snapshot.key, roomName: roomName)
                    
                    self.rooms.append(room)
                    self.roomsTable.reloadData()
                }
                
            }
        }
        
    }
}
