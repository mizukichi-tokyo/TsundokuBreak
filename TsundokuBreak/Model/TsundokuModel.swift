//
//  TsundokuModel.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

struct  TsundokuModelInput {
    let changeFlagRelay: PublishRelay<Int>
    let changeReadPageRelay: PublishRelay<[Int]>
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
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        records = realm.objects(Record.self).sorted(byKeyPath: "creationTime", ascending: true).filter("dokuryoFlag == false")

        input.changeFlagRelay
            .subscribe(onNext: { [weak self] flag in
                guard let self = self else { return }
                let switchedCell = self.records[flag]
                do {
                    return try realm.write {
                        switchedCell.dokuryoFlag = true
                        switchedCell.switchedTime = Date().timeIntervalSinceReferenceDate
                    }
                } catch let error as NSError {
                    assertionFailure("realm error: \(error)")
                }

            })
            .disposed(by: disposeBag)

        input.changeReadPageRelay
            .subscribe(onNext: { [weak self] changeData in
                guard let self = self else { return }
                let changedCell = self.records[changeData[0]]
                do {
                    return try realm.write {
                        changedCell.readPage = changeData[1]
                    }
                } catch let error as NSError {
                    assertionFailure("realm error: \(error)")
                }
            })
            .disposed(by: disposeBag)

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
