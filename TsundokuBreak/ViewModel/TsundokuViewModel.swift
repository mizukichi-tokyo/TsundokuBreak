//
//  TsundokuViewModel.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation

struct   TsundokuViewModelInput {
}

protocol   TsundokuViewModelOutput {
}

protocol  TsundokuViewModelType {
    var outputs: TsundokuViewModelOutput? { get }
    func setup(input: TsundokuViewModelInput)
}

final class   TsundokuViewModel: TsundokuViewModelType, Injectable, TsundokuViewModelOutput {
    typealias Dependency = TsundokuModelType

    private let model: TsundokuModelType
    var outputs: TsundokuViewModelOutput?

    init(with dependency: Dependency) {
        model = dependency
        self.outputs = self

    }

    func setup(input: TsundokuViewModelInput) {

    }

}
