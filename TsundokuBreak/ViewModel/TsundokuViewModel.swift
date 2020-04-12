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
    let changeFlagRelay: PublishRelay<Int>
    let changeReadPageRelay: PublishRelay<[Int]>
}

protocol   TsundokuViewModelOutput {
    var recordsChangeObservable: Observable<(AnyRealmCollection<Record>, RealmChangeset?)> {get}
    var cellDataDriver: Driver<[CellData]> {get}
}

protocol  TsundokuViewModelType {
    var outputs: TsundokuViewModelOutput? { get }
    func setup(input: TsundokuViewModelInput)
}

final class   TsundokuViewModel: TsundokuViewModelType, Injectable {
    typealias Dependency = TsundokuModelType

    private let model: TsundokuModelType
    var outputs: TsundokuViewModelOutput?
    private let cellDataRelay = BehaviorRelay<[CellData]>(value: [])
    private let disposeBag = DisposeBag()

    init(with dependency: Dependency) {
        model = dependency
        self.outputs = self
    }

    func setup(input: TsundokuViewModelInput) {

        let modelInput = TsundokuModelInput(
            changeFlagRelay: input.changeFlagRelay,
            changeReadPageRelay: input.changeReadPageRelay
        )

        model.setup(input: modelInput)

        model.outputs?.recordsObservable
            .subscribe(onNext: { [weak self] records in
                guard let self = self else { return }
                self.cellDataRelay.accept(self.makeCellDataArray(records: records))
            })
            .disposed(by: disposeBag)

    }

    private func makeCellDataArray(records: Results<Record>? ) ->( [CellData] ) {
        print("makecelldataArray")
        var dataArray = [CellData]()

        for record in records! {

            let cellData = CellData(
                thumbnailUrl: record.thumbnailUrl,
                title: record.title,
                author: record.author,
                publication: record.publication,
                pageCount: record.pageCount,
                readPage: record.readPage,
                dokuryoFlag: record.dokuryoFlag
            )

            dataArray.append(cellData)
        }
        return dataArray
    }

}

extension TsundokuViewModel: TsundokuViewModelOutput {
    var recordsChangeObservable: Observable<(AnyRealmCollection<Record>, RealmChangeset?)> {
        return  model.outputs!.recordsChangeObservable
    }

    var cellDataDriver: Driver<[CellData]> {
        return cellDataRelay.asDriver()
    }

}
