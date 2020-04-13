//
//  TableState+Format.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/13.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import EmptyStateKit

extension TableState {

    var format: EmptyStateFormat {
        switch self {

        case .noTsundoku:

            var format = EmptyStateFormat()
            format.buttonColor = "44CCD6".hexColor
            format.position = EmptyStatePosition(view: .center, text: .center, image: .top)
            format.animation = EmptyStateAnimation.fade(0.3, 0.3)
            format.verticalMargin = -10
            format.horizontalMargin = 40
            format.imageSize = CGSize(width: 320, height: 200)
            format.buttonShadowRadius = 10
            return format

        case .noDokuryo:

            var format = EmptyStateFormat()
            format.buttonColor = "FF386C".hexColor
            format.buttonColor = UIColor.systemBackground
            format.position = EmptyStatePosition(view: .center, text: .center, image: .bottom)
            format.animation = EmptyStateAnimation.fade(0.3, 0.3)
            format.verticalMargin = -10
            format.horizontalMargin = 40
            format.imageSize = CGSize(width: 320, height: 200)
            format.buttonShadowRadius = 10
            return format

        case .noInternet:

            var format = EmptyStateFormat()
            format.buttonColor = "44CCD6".hexColor
            format.position = EmptyStatePosition(view: .bottom, text: .left, image: .top)
            format.verticalMargin = 40
            format.horizontalMargin = 40
            format.imageSize = CGSize(width: 320, height: 200)
            format.buttonShadowRadius = 10
            format.gradientColor = ("3854A5".hexColor, "2A1A6C".hexColor)
            //            format.titleAttributes = [.font: UIFont(name: "AvenirNext-DemiBold", size: 26)!, .foregroundColor: UIColor.white]
            //            format.descriptionAttributes = [.font: UIFont(name: "Avenir Next", size: 14)!, .foregroundColor: UIColor.white]
            return format

        }
    }
}
