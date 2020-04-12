//
//  DokuryoViewModel.swift
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

struct   DokuryoViewModelInput {
    let cellDeleteRelay: PublishRelay<Int>
}

protocol   DokuryoViewModelOutput {
    var recordsChangeObservable: Observable<(AnyRealmCollection<Record>, RealmChangeset?)> {get}
    var cellDataDriver: Driver<[CellData]> {get}
}

protocol  DokuryoViewModelType {
    var outputs: DokuryoViewModelOutput? { get }
    func setup(input: DokuryoViewModelInput)
}

final class   DokuryoViewModel: DokuryoViewModelType, Injectable {
    typealias Dependency = DokuryoModelType

    private let model: DokuryoModelType
    var outputs: DokuryoViewModelOutput?

    private let cellDataRelay = BehaviorRelay<[CellData]>(value: [])
    private let disposeBag = DisposeBag()

    init(with dependency: Dependency) {
        model = dependency
        self.outputs = self

    }

    func setup(input: DokuryoViewModelInput) {
        let modelInput = DokuryoModelInput(
            cellDeleteRelay: input.cellDeleteRelay
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

extension DokuryoViewModel: DokuryoViewModelOutput {
    var recordsChangeObservable: Observable<(AnyRealmCollection<Record>, RealmChangeset?)> {
        return  model.outputs!.recordsChangeObservable
    }

    var cellDataDriver: Driver<[CellData]> {
        return cellDataRelay.asDriver()
    }
}
