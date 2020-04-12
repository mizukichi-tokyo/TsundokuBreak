//
//  CellValueChangeDelegate.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/12.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation

protocol CellValueChangeDelegate: AnyObject {
    func changeDokuryoFlag(indexPathRow: Int)
    func changeReadPage(indexPathRow: Int, readPage: Int)
}
