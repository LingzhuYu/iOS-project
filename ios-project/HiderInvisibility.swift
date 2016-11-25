//
//  HiderInvisibility.swift
//  ios-project
//
//  Created by Kevin Le on 2016-10-19.
//  Copyright © 2016 Manjot. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HiderInvisibility : MKPointAnnotation, PowerUp {
    
    static let DEFAULT_NAME  = "Invisibility"
    static let DEFAULT_ROLE  = "Hider"
    static let DEFAULT_DESC  = "Keeps you hidden from seekers for a period of time"
    
    var name : String
    var role : String
    var duration : Int
    var expireTime : Int
    var energyCost : Int
    var isActive : Bool
    var powerDescription : String
    var icon : UIImage
    
    required override init(){
        
        self.name        = HiderInvisibility.DEFAULT_NAME
        self.role        = HiderInvisibility.DEFAULT_ROLE
        self.powerDescription = HiderInvisibility.DEFAULT_DESC
        
        self.duration    = 60 * 3
        self.expireTime  = 60 * 3
        self.energyCost  = 60 * 3
        self.isActive    = false
        self.icon        = UIImage(named: "invisible")!
        super.init()
        self.icon        = self.resizeImage(image: UIImage(named: "invisible")!, targetSize: CGSize(30, 30))
        
    }
    
    required init(duration: Int, expireTime: Int, energyCost: Int, isActive: Bool) throws{
        
        self.name        = HiderInvisibility.DEFAULT_NAME
        self.role        = HiderInvisibility.DEFAULT_ROLE
        self.powerDescription = HiderInvisibility.DEFAULT_DESC
        self.icon        = UIImage(named: "invisible")!
        
        
        if(duration <= 0 || expireTime <= 0 || energyCost <= 0){
            throw PowerUpError.illegalArgument
        }else{
            self.duration    = duration
            self.expireTime  = expireTime
            self.energyCost  = energyCost
            self.isActive    = isActive
        }
        super.init()
        self.icon = self.resizeImage(image: UIImage(named: "invisible")!, targetSize: CGSize(30, 30))
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
