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

struct   BarCodeReaderViewModelInput {
    let isbnSignal: PublishRelay<String>
}

protocol   BarCodeReaderViewModelOutput {
}

protocol  BarCodeReaderViewModelType {
    var outputs: BarCodeReaderViewModelOutput? { get }
    func setup(input: BarCodeReaderViewModelInput)
}

final class   BarCodeReaderViewModel: BarCodeReaderViewModelType, Injectable, BarCodeReaderViewModelOutput {
    typealias Dependency = BarCodeReaderModelType

    private let model: BarCodeReaderModelType
    var outputs: BarCodeReaderViewModelOutput?

    init(with dependency: Dependency) {
        model = dependency
        self.outputs = self

    }

    func setup(input: BarCodeReaderViewModelInput) {

        let modelInput = BarCodeReaderModelInput(
            isbnSignal: input.isbnSignal
        )
        model.setup(input: modelInput)
    }

}
