//
//  LobbyViewController.swift
//  ios-project
//
//  Created by Jason Cheung on 2016-11-18.
//  Copyright © 2016 Manjot. All rights reserved.
//

import UIKit
import Firebase

class LobbyViewController: UIViewController {

    fileprivate var db: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!   // not observing anything
    
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    public var gameId : String = ""
    var players = [(deviceId: String, ready: Bool, role: String)]()
    // let lobby : Lobby = Lobby()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        )
        
        // retrieve values 
        var lobby = self.db.child("lobbies").child(gameId)
        
    }
    
    func onPlayerListUpdated(playerList: FIRDataSnapshot) {
        
        // This looks pretty promising 
        // http://stackoverflow.com/questions/38038990/firebase-converting-snapshot-value-to-objects
        for child in playerList.children.allObjects as? [FIRDataSnapshot] ?? [] {
            let childId = child.key
            let childReady = child.childSnapshot(forPath: "ready").value as! Bool
            let childRole = child.childSnapshot(forPath: "role").value as! String
            // do stuff with data
        }
    }
    
    func debugShowPlayerJoined(player: FIRDataSnapshot) {
        
        // create alert
        let alert = UIAlertController(title: "Player joined!", message: "I don't know who though", preferredStyle: UIAlertControllerStyle.alert)
        
        // Add back button
        alert.addAction(UIAlertAction(title: "Back", style: .default))
        
        // Preset alert and play SFX
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        self.db.child("lobbies").child(gameId).removeObserver(withHandle: _refHandle)
    }
    
}

class LobbyPlayerCell: UITableViewCell {
    
    var deviceId = ""
    
    var name = "" {
        didSet {
            playerNameLabel.text = name
        }
    }
    
    var ready = false {
        didSet {
            playerReadySwitch.isOn = ready
        }
    }
    
    var role = ""
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerReadySwitch: UISwitch!
    
    
}
