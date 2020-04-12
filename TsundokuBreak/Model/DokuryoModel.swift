//
//  DokuryoModel.swift
//  DokuryoBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

struct  DokuryoModelInput {
    let cellDeleteRelay: PublishRelay<Int>
}

protocol  DokuryoModelOutput {
    var recordsObservable: Observable<Results<Record>> {get}
    var recordsChangeObservable: Observable<(AnyRealmCollection<Record>, RealmChangeset?)> {get}
}

protocol DokuryoModelType {
    var outputs: DokuryoModelOutput? { get }
    func setup(input: DokuryoModelInput)
}

final class  DokuryoModel: DokuryoModelType, Injectable {
    struct Dependency {}
    private let disposeBag = DisposeBag()
    private var records: Results<Record>!

    var outputs: DokuryoModelOutput?

    init(with dependency: Dependency) {
        self.outputs = self
    }

    func setup(input: DokuryoModelInput) {
        let realm = createRealm()

        records = realm.objects(Record.self)
            .sorted(byKeyPath: "creationTime", ascending: true)
            .filter("dokuryoFlag == true")

        input.cellDeleteRelay
            .withLatestFrom(Observable.collection(from: records)) { indexPath, records in
                return records[indexPath]
        }.subscribe(Realm.rx.delete()).disposed(by: disposeBag)
        //        input.cellDeleteRelay
        //            .subscribe(onNext: { [weak self] deleteCell in
        //                guard let self = self else { return }
        //                let deleteCell = self.records[deleteCell]
        //                print("deleteCell@model")
        //                print(deleteCell)
        //                //                try? realm.write {
        //                //                    switchedCell.dokuryoFlag = true
        //                //                }
        //            })
        //            .disposed(by: disposeBag)

    }

}

extension DokuryoModel {
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

extension DokuryoModel: DokuryoModelOutput {
    var recordsObservable: Observable<Results<Record>> {
        return  Observable.collection(from: records)
    }

    var recordsChangeObservable: Observable<(AnyRealmCollection<Record>, RealmChangeset?)> {
        return  Observable.changeset(from: records)
    }

}
