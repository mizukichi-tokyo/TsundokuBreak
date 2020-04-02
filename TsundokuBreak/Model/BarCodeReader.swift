//
//  BarCodeReader.swift
//  BarCodeReaderBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct  BarCodeReaderModelInput {
    let isbnRelay: PublishRelay<String>
}

protocol  BarCodeReaderModelOutput {
}

protocol BarCodeReaderModelType {
    var outputs: BarCodeReaderModelOutput? { get }
    func setup(input: BarCodeReaderModelInput)
}

final class  BarCodeReaderModel: BarCodeReaderModelType, Injectable, BarCodeReaderModelOutput {
    struct Dependency {}

    var outputs: BarCodeReaderModelOutput?

    private let disposeBag = DisposeBag()

    init(with dependency: Dependency) {
        self.outputs = self
    }

    func setup(input: BarCodeReaderModelInput) {
        input.isbnRelay.subscribe(onNext: { isbn in
            print(isbn)
        }).disposed(by: disposeBag)

    }

}
