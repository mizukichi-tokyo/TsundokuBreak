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
    @objc dynamic var thumbnailUrl: URL = URL(string: "")!
    @objc dynamic var title: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var publication: String = ""
    @objc dynamic var pageCount: Int = 0
    @objc dynamic var readPage: Int = 0
}
