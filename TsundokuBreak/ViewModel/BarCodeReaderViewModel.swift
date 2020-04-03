//
//  BarCodeReaderViewModel.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct BarCodeReaderViewModelInput {
    let isbnRelay: PublishRelay<String>
}

protocol BarCodeReaderViewModelOutput {
    var urlSignal: PublishRelay<URL> { get }
}

protocol BarCodeReaderViewModelType {
    var outputs: BarCodeReaderViewModelOutput? { get }
    func setup(input: BarCodeReaderViewModelInput)
}

final class BarCodeReaderViewModel: BarCodeReaderViewModelType, Injectable {
    typealias Dependency = BarCodeReaderModelType

    private let model: BarCodeReaderModelType
    var outputs: BarCodeReaderViewModelOutput?
    private let disposeBag = DisposeBag()

    init(with dependency: Dependency) {
        model = dependency
        self.outputs = self
    }

    func setup(input: BarCodeReaderViewModelInput) {

        let modelInput = BarCodeReaderModelInput(
            isbnRelay: input.isbnRelay
        )
        model.setup(input: modelInput)

        //        model.outputs?.urlRelay
        //            .subscribe(onNext: { url in
        //                print("viewModel")
        //                print(url)
        //            })
        //            .disposed(by: disposeBag)
    }
}

extension BarCodeReaderViewModel: BarCodeReaderViewModelOutput {
    var urlSignal: PublishRelay<URL> {
        return model.outputs!.urlRelay
    }

}
