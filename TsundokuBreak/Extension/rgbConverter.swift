//
//  rgbConverter.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/14.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
