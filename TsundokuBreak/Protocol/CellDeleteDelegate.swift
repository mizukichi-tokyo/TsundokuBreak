//
//  CellDeleteDelegate.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/12.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation

protocol CellDeleteDelegate: AnyObject {
    func deleteCell(indexPathRow: Int)
}
