//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    let db = Firestore.firestore()
    var messages : [Message] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constant.cellNibName, bundle: nil), forCellReuseIdentifier: Constant.cellIdentifier)
        tableView.dataSource = self
        title = Constant.appName
       // navigationItem.hidesBackButton = true
        loadMessages()
    }
    
    func loadMessages(){
        messages = []
        db.collection(Constant.FStore.collectionName).order(by: "date").addSnapshotListener{(querySnapshot,error) in
            self.messages = []
            
            if let e = error {
                print("there is issue with firebase")
            }else {
                if let snapshotDocuments =
                    querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let sender = data[Constant.FStore.senderField] as? String, let messageBody = data[Constant.FStore.bodyField] as? String{
                            let newMessages = Message(sender: sender, body: messageBody)
                            self.messages.append(newMessages)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(Constant.FStore.collectionName).addDocument(data: [
                Constant.FStore.senderField: messageSender,
                Constant.FStore.bodyField: messageBody,
                Constant.FStore.dateField: Date().timeIntervalSince1970
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: ")
                    DispatchQueue.main.async{
                    self.messageTextfield.text = ""
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath) as! MessageCell
        
        
        cell.Label.text = message.body
        
        //this is a message from current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.LeftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBuble.backgroundColor = UIColor(named: Constant.BrandColors.purple)
            cell.Label.textColor = UIColor(named: Constant.BrandColors.lightPurple)
        }else{
            cell.LeftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBuble.backgroundColor = UIColor(named: Constant.BrandColors.lightPurple)
            cell.Label.textColor = UIColor(named: Constant.BrandColors.purple)
        }
        
        return cell
    }
    
}

