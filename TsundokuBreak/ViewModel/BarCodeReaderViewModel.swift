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
    var zeroItemSignal: Signal<Bool> { get }
    var urlSignal: Signal<URL> { get }
    var titleSignal: Signal<String> { get }
    var authorSignal: Signal<String> { get }
    var publicationSignal: Signal<String> { get }
    var pageCountSignal: Signal<String> { get }
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
    }
}

extension BarCodeReaderViewModel: BarCodeReaderViewModelOutput {
    var zeroItemSignal: Signal<Bool> {
        return model.outputs!.zeroItemRelay.asSignal()
    }

    var urlSignal: Signal<URL> {
        return model.outputs!.urlRelay.asSignal()
    }

    var titleSignal: Signal<String> {
        return model.outputs!.titleRelay.asSignal()
    }

    var authorSignal: Signal<String> {
        return model.outputs!.authorRelay.asSignal()
    }

    var publicationSignal: Signal<String> {
        return model.outputs!.publicationRelay.asSignal()
    }

    var pageCountSignal: Signal<String> {
        return model.outputs!.pageCountRelay.asSignal()
    }

}
