//
//  TsundokuModel.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

struct  TsundokuModelInput {
}

protocol  TsundokuModelOutput {
    var recordsObservable: Observable<Results<Record>> {get}
    var recordsChangeObservable: Observable<(AnyRealmCollection<Record>, RealmChangeset?)> {get}
}

protocol TsundokuModelType {
    var outputs: TsundokuModelOutput? { get }
    func setup(input: TsundokuModelInput)
}

final class  TsundokuModel: TsundokuModelType, Injectable {
    struct Dependency {}

    var outputs: TsundokuModelOutput?
    private let disposeBag = DisposeBag()
    private var records: Results<Record>!

    init(with dependency: Dependency) {
        self.outputs = self
    }

    func setup(input: TsundokuModelInput) {
        let realm = createRealm()

        records = realm.objects(Record.self).sorted(byKeyPath: "creationTime", ascending: true).filter("dokuryoFlag == false")
    }
}

extension TsundokuModel {
    private func createRealm() -> Realm {
        do {
            return try Realm()
        } catch let error as NSError {
            assertionFailure("realm error: \(error)")
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            // swiftlint:disable:next force_try
            return try! Realm(configuration: config)
            // swiftlint:disable:previous force_try
        }
    }
}

extension TsundokuModel: TsundokuModelOutput {
    var recordsObservable: Observable<Results<Record>> {
        return  Observable.collection(from: records)
    }

    var recordsChangeObservable: Observable<(AnyRealmCollection<Record>, RealmChangeset?)> {
        return  Observable.changeset(from: records)
    }

}
