//
//  GameStateViewController.swift
//  ios-project
//
//  Created by Lydia Yu on 2016-12-03.
//  Copyright © 2016 Manjot. All rights reserved.
//

import UIKit
import Firebase

class GameStateViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var hiderValue: UILabel!
    @IBOutlet weak var seekerValue: UILabel!
    var db: FIRDatabaseReference!
    var Players: Array< String > = Array < String >()
    fileprivate var _refHandle: FIRDatabaseHandle!
    fileprivate var _refHandlePlayer: FIRDatabaseHandle!
    var hostQuitObserver : AnyObject?
    let notificationCentre = NotificationCenter.default
    let gameId: String = "1"
    var seekersCount = 0
    var hunterCount = 0
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    var playerIsHost: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureDatabase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configureDatabase() {
        // init db
        db = FIRDatabase.database().reference()
        
        // add observer to game db
        _refHandle = self.db.child("game").child(gameId).child("players").observe(.value,
                                                                                  with: { [weak self] (snapshot) -> Void in
                                                                                    guard let strongSelf = self else { return }
                                                                                    strongSelf.showHiders(player: snapshot)
            })
        _refHandlePlayer = self.db.child("game").child(gameId).child("hostId").observe(.value,
                                                                                       with: { [weak self] (snapshot) -> Void in
                                                                                        guard let strongSelf = self else { return }
                                                                                        strongSelf.getPlayerRole(player: snapshot)
            })
    }
    
    //get players info from db.game table and show in the table view
    func showHiders(player: FIRDataSnapshot) {
        for child in player.children.allObjects as? [FIRDataSnapshot] ?? [] {
            Players.append(child.childSnapshot(forPath: "role").value as! String)
        }
        
        for role in Players{
            if(role == "seeker"){
                seekersCount += 1
            }else{
                hunterCount += 1
            }
        }
        
        seekerValue.text = String(seekersCount)
        hiderValue.text = String(hunterCount)
        print(seekersCount)
        self.tableView.reloadData()
        
    }
    func getPlayerRole(player: FIRDataSnapshot) {
        for child in player.children.allObjects as? [FIRDataSnapshot] ?? [] {
            if(deviceId == String(describing: child)){
                playerIsHost = true
            }
        }
    }

    @IBAction func quitGame(_ sender: AnyObject) {
    }
    
}
