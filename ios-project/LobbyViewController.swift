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

    @IBOutlet weak var GameIDLabel: UILabel!
    
    @IBOutlet weak var HostSettingsButton: UIButton!
    
    
    fileprivate var db: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!   // not observing anything
    
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    public var gameId : String = ""
    public var hostId : String = ""
    var players = [LobbyUser]()
    var currentUser : LobbyUser?

    // let lobby : Lobby = Lobby()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self 
        
        configureDatabase()

        HostSettingsButton.addTarget(self, action: #selector(startMap), for: .touchUpInside)
        HostSettingsButton.backgroundColor = UIColor.clear
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
        
        //username: data.childSnapshot(forPath: "username").value as! String,
        GameIDLabel.text = "Game ID " + gameId
        var tmp = self.db.child("lobbies").child(gameId).observe(.value, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            //            strongSelf.locationsSnapshot = snapshot
            strongSelf.parseDevicesForHost(devices: snapshot)
        })
        // retrieve values 
        // var lobby = self.db.child("lobbies").child(gameId)
        
    }
    
    
    func parseDevicesForHost(devices: FIRDataSnapshot) {
        
        //grabs the host's device ID from the database
        hostId = devices.childSnapshot(forPath: "hostId").value as! String
        
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
    
    func changeRole(_ role: String) {
        //self.db.child("lobbies").child(gameId).child("players").child(userId).setValue(
        //    ["role": role]
        //)
        //TODO: get the new role of the user that role has been switched
        //      and update the database
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

    //Start of host map settings stuff
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! LobbyMapSelectView
    }
    
    func startMap(){
        performSegue(withIdentifier: "mapSegue" , sender: nil)
    }
    
    //End of host map settings stuff
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
    @IBOutlet weak var playerRoleButton: UIButton!
    
    var lobbyController : LobbyViewController?
    
    var lobbyUser : LobbyUser? {
        didSet {
            playerNameLabel.text = lobbyUser?.username
            playerReadySwitch.isOn = (lobbyUser?.isReady)!
            let role = (lobbyUser?.role.uppercased() == "SEEKER") ? "S" : "H"
            playerRoleButton.setTitle(role, for: .normal)
        
            if (lobbyUser?.id != lobbyController?.deviceId) {
                playerReadySwitch.isEnabled = false
            }
            let roleColor = (lobbyUser?.role.uppercased() == "SEEKER") ? UIColor.darkGray : UIColor.lightGray
            playerRoleButton.backgroundColor = roleColor
            if(lobbyController?.deviceId != lobbyController?.hostId) {
                playerRoleButton.isEnabled = false
            }
        }
    }
    
    @IBAction func playerRoleChange(_ sender: UIButton) {
        if (playerRoleButton.currentTitle == "S") {
            playerRoleButton.setTitle("H", for: .normal)
            lobbyUser?.role = "hider"
                lobbyController?.updateDatabase(lobbyUser!)
            playerRoleButton.backgroundColor = UIColor.lightGray
            
        } else {
            playerRoleButton.setTitle("S", for: .normal)
            lobbyUser?.role = "seeker"
            lobbyController?.updateDatabase(lobbyUser!)
            playerRoleButton.backgroundColor = UIColor.darkGray
        }
    }
    
    @IBAction func onReadyChanged(_ sender: AnyObject) {
        lobbyController?.changeReadyStatus(playerReadySwitch.isOn)
    }
}
