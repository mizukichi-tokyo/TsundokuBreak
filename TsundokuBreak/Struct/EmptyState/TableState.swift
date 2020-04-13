//
//  TableState.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/13.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import EmptyStateKit

enum TableState: CustomState {

    case noDokuryo
    case noTsundoku
    case noInternet

    var image: UIImage? {
        switch self {
        case .noDokuryo: return UIImage(named: "Box")
        case .noTsundoku: return UIImage(named: "Search")
        case .noInternet: return UIImage(named: "Internet")
        }
    }

    var title: String? {
        switch self {
        case .noDokuryo: return "読了した本がありません！"
        case .noTsundoku: return "積読本を探そう！"
        case .noInternet: return "We’re Sorry"
        }
    }

    var description: String? {
        switch self {
        case .noDokuryo: return "本を読み終えたら表示されます"
        case .noTsundoku: return "読んでない本を探して登録しましょう"
        case .noInternet: return "Our staff is still working on the issue for better experience"
        }
    }

    var titleButton: String? {
        switch self {
        case .noDokuryo: return ""
        case .noTsundoku: return "登録する"
        case .noInternet: return "Try again?"
        }
    }
}
