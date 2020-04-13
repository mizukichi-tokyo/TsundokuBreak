//
//  String+Hex.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/13.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit

public extension String {

    var hexColor: UIColor {

        let hexString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        // swiftlint:disable identifier_name
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        // swiftlint:enable identifier_name
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
