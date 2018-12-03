//
//  ExtensionUIColor.swift
//  GreatAmericaTracking
//
//  Created by Shubham on 06/10/18.
//  Copyright © 2018 Shubham. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

extension UIColor{
    static var colorBrownReject: UIColor {
        return UIColor.init(red: 175/255.0, green: 35/255.0, blue: 40/255.0, alpha: 1.0)
    }
    
    static var colorGreenAccept: UIColor {
        return UIColor.init(red: 45/255.0, green: 215/255.0, blue: 115/255.0, alpha: 1.0)
    }
    
    static var colorRedUpcoming: UIColor {
        return UIColor.init(red: 255/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1.0)
    }
    
    static var colorBlueOnTheWay: UIColor {
        return UIColor.init(red: 5/255.0, green: 190/255.0, blue: 250/255.0, alpha: 1.0)
    }
    static var colorYellowReached: UIColor {
        return UIColor.init(red: 255/255.0, green: 201/255.0, blue: 60/255.0, alpha: 1.0)
    }
    
}
