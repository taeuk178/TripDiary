//
//  Extension.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/20.
//

import UIKit


extension UIColor {
    
    func rgb(red: Int, green: Int, blue: Int) -> UIColor{
        return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1.0)
    }
    
    static let naviGreenColor = UIColor(red: 97/255, green: 192/255, blue: 124/255, alpha: 1.0)
}
