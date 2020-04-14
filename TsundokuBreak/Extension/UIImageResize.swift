//
//  UIImageResize.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/15.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable identifier_name
extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}

// swiftlint:enable identifier_name
