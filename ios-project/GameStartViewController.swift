//
//  GameStartViewController.swift
//  ios-project
//
//  Created by Andrew Lukonin on 2016-12-02.
//  Copyright © 2016 Manjot. All rights reserved.
//

import UIKit

class GameStartViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var autoProgBar: UIProgressView!
    @IBOutlet weak var autoProgLabel: UILabel!
    var secondCount : Int = 60
    var autoCounter: Int = 0 {
        didSet {
            let fraction = Float(autoCounter) / 60.0
            let animate = autoCounter != 0
            
            self.autoProgBar.setProgress(fraction, animated: animate)
            self.autoProgLabel.text = "Seconds till game starts: \(self.secondCount-self.autoCounter)"
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImage.image = #imageLiteral(resourceName: "Large_icon_no_bg-1")
        autoProgBar.setProgress(0, animated: true)

        startCountdown()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startCountdown(){
        DispatchQueue.global(qos: .utility).async {
            for _ in 0..<5 {
                sleep(1)
                DispatchQueue.main.async {
                    self.autoCounter += 1
                }
            }
            print("After the loop now")
        }
    }
    

}
