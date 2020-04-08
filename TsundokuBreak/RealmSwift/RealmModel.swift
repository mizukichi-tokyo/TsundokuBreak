//
//  RealmModel.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/09.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation
import RealmSwift

final class Record: Object {
    @objc dynamic var creationTime: TimeInterval = Date().timeIntervalSinceReferenceDate
    @objc dynamic var thumbnailUrl: String = "https://lh5.googleusercontent.com/k_OE9DYQ8pCYkfdhMEZBkrr59NbhzjLkTHe5g9fRVayIvgQLpnIbN-MRRAp0t2euLp2_tbFfAw=w1280"
    @objc dynamic var title: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var publication: String = ""
    @objc dynamic var pageCount: Int = 0
    @objc dynamic var readPage: Int = 0
}
