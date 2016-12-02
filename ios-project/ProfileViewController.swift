//
//  ProfileViewController.swift
//  ios-project
//
//  Created by Mike Han on 2016-12-02.
//  Copyright © 2016 Manjot. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var db: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    
    @IBOutlet weak var TotalPlayedLabel: UILabel!
    @IBOutlet weak var WonLabel: UILabel!
    @IBOutlet weak var WinStreakLabel: UILabel!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ReturnMainMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(deviceId)
        configureDatabase()
        
        //TotalPlayedLabel.text = String(describing: gamesPlayed)
    }
    
    func configureDatabase(){
        db = FIRDatabase.database().reference()
        self.db.child("profile").child(deviceId).observe(.value, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            //            strongSelf.locationsSnapshot = snapshot
            strongSelf.parseDevicesForHost(devices: snapshot)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ReturnButtonController(_ sender: Any) {
        
    }
    
    func parseDevicesForHost(devices: FIRDataSnapshot){
        let gameCount = devices.childSnapshot(forPath: "totalPlayed").value as! String
        let winCount = devices.childSnapshot(forPath: "winCount").value as! String
        let recentUserName = devices.childSnapshot(forPath: "recentUserName").value as! String
        TotalPlayedLabel.text = gameCount
        WonLabel.text = winCount
        let ratio = (Double(winCount)! / Double(gameCount)!) * 100
        WinStreakLabel.text = String(ratio) + "%"
        UserName.text = recentUserName
    }
    
}

