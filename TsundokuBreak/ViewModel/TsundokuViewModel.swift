//
//  TsundokuViewModel.swift
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

struct   TsundokuViewModelInput {
}

protocol   TsundokuViewModelOutput {
    var recordsChangeObservable: Observable<(AnyRealmCollection<Record>, RealmChangeset?)> {get}
    var tsundokuDataDriver: Driver<[BookDataTuple]> {get}

}

protocol  TsundokuViewModelType {
    var outputs: TsundokuViewModelOutput? { get }
    func setup(input: TsundokuViewModelInput)
}

final class   TsundokuViewModel: TsundokuViewModelType, Injectable {
    typealias Dependency = TsundokuModelType

    private let model: TsundokuModelType
    var outputs: TsundokuViewModelOutput?
    private let tsundokuDataRelay = BehaviorRelay<[BookDataTuple]>(value: [])
    private let disposeBag = DisposeBag()

    init(with dependency: Dependency) {
        model = dependency
        self.outputs = self
    }

    func setup(input: TsundokuViewModelInput) {

        let modelInput = TsundokuModelInput(
        )

        model.setup(input: modelInput)

        model.outputs?.recordsObservable
            .subscribe(onNext: { [weak self] records in
                guard let self = self else { return }
                self.tsundokuDataRelay.accept(self.makeDataTupleArray(records: records))
            })
            .disposed(by: disposeBag)

    }

    private func makeDataTupleArray(records: Results<Record>? ) ->( [BookDataTuple] ) {

        var dataArray = [BookDataTuple]()

        for record in records! {

            let dataTuple = BookDataTuple(
                thumbnailUrl: record.thumbnailUrl,
                title: record.title,
                author: record.author,
                publication: record.publication,
                pageCount: record.pageCount,
                readPage: record.readPage,
                dokuryoFlag: record.dokuryoFlag
            )

            dataArray.append(dataTuple)
        }
        return dataArray
    }

}

extension TsundokuViewModel: TsundokuViewModelOutput {
    var recordsChangeObservable: Observable<(AnyRealmCollection<Record>, RealmChangeset?)> {
        return  model.outputs!.recordsChangeObservable
    }

    var tsundokuDataDriver: Driver<[BookDataTuple]> {
        return tsundokuDataRelay.asDriver()
    }

}
