//
//  LobbyViewController.swift
//  ios-project
//
//  Created by Jason Cheung on 2016-11-18.
//  Copyright © 2016 Manjot. All rights reserved.
//

import UIKit
import Firebase

class LobbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    fileprivate var db: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!   // not observing anything
    
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    public var gameId : String = ""
    var players = [LobbyUser]()
    var currentUser : LobbyUser?
    // let lobby : Lobby = Lobby()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self 
        
        configureDatabase()
    }
    
    fileprivate func configureDatabase() {
        // init db
        db = FIRDatabase.database().reference()
        
        // add observer to lobby db
        _refHandle = self.db.child("lobbies").child(gameId).child("players").observe(
            .value,
            with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
                strongSelf.debugShowPlayerJoined(player: snapshot)
                self?.onPlayerListUpdated(playerList: snapshot)
            }
        )
        
        // retrieve values 
        // var lobby = self.db.child("lobbies").child(gameId)
        
    }
    
    // This is called when the database players table is updated.
    func onPlayerListUpdated(playerList: FIRDataSnapshot) {
        
        // This looks pretty promising 
        // http://stackoverflow.com/questions/38038990/firebase-converting-snapshot-value-to-objects
        
        for child in playerList.children.allObjects as? [FIRDataSnapshot] ?? [] {

            // Convert to a LobbyUser object to work with
            let user = LobbyUser.MakeFromFIRObject(data: child)
            
            // If the user is us, assign to current user for convenience
            if (user.id == deviceId) {
                currentUser = user
            }
            
            // Update the table datasource
            editOrAddPlayerList(user)
        }
        
        self.tableView.reloadData()

    }
    
    // This updates the table datasource from the database
    func editOrAddPlayerList(_ user : LobbyUser) {
        
        for (index, element) in players.enumerated() {
            // Update
            if (user.id == element.id) {
                players[index] = user
                return;
            }
        }
        
        // Or add
        players.append(user)
    }
    
    func changeReadyStatus(_ torf: Bool) {
        currentUser?.isReady = torf
        updateDatabase(currentUser!)
    }
    
    func updateDatabase(_ user: LobbyUser) {
        self.db.child("lobbies").child(gameId).child("players").child(user.id).setValue(
            ["username": user.username, "role": user.role, "ready": user.isReady]
        )
    }
    
    
    func debugShowPlayerJoined(player: FIRDataSnapshot) {
        
        // create alert
        let alert = UIAlertController(title: "Player joined!", message: "I don't know who though", preferredStyle: UIAlertControllerStyle.alert)
        
        // Add back button
        alert.addAction(UIAlertAction(title: "Back", style: .default))
        
        // Preset alert and play SFX
        self.present(alert, animated: true, completion: nil)
    }

    deinit {
        self.db.child("lobbies").child(gameId).removeObserver(withHandle: _refHandle)
    }
    
    
    
    // MARK : - TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "lobbyPlayerCell") as! LobbyPlayerCell
        
        cell.lobbyController = self
        cell.lobbyUser = players[indexPath.row]
        
        return cell
    }
}

class LobbyUser {
    var id : String
    var username : String
    var isReady : Bool
    var role : String
    
    init(id: String, username: String, ready: Bool, seeker: String) {
        self.id = id
        self.username = username
        self.isReady = ready
        self.role = seeker
    }
    
    class func MakeFromFIRObject(data: FIRDataSnapshot) -> LobbyUser {
        return LobbyUser(
            id: data.key,
            username: data.childSnapshot(forPath: "username").value as! String,
            ready: data.childSnapshot(forPath: "ready").value as! Bool,
            seeker: data.childSnapshot(forPath: "role").value as! String
        )
    }
    
}

class LobbyPlayerCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerReadySwitch: UISwitch!
    @IBOutlet weak var playerRoleLabel: UILabel!
    
    var lobbyController : LobbyViewController?
    
    var lobbyUser : LobbyUser? {
        didSet {
            playerNameLabel.text = lobbyUser?.username
            playerReadySwitch.isOn = (lobbyUser?.isReady)!
            playerRoleLabel.text = (lobbyUser?.role.uppercased() == "SEEKER") ? "S" : "H"
        
            if (lobbyUser?.id != lobbyController?.deviceId) {
                playerReadySwitch.isEnabled = false
            }
        }
    }
    
    @IBAction func onReadyChanged(_ sender: AnyObject) {
        lobbyController?.changeReadyStatus(playerReadySwitch.isOn)
    }
}
