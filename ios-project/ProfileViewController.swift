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
    fileprivate var _refHandle: FIRDatabaseHandle!   // not observing anything
    
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    @IBOutlet weak var TotalPlayedLabel: UILabel!
    @IBOutlet weak var WonLabel: UILabel!
    @IBOutlet weak var WinStreakLabel: UILabel!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ReturnMainMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ReturnButtonController(_ sender: Any) {
        
    }
    
}
   
