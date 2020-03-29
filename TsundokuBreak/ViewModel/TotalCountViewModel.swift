//
//  TotalCountViewModel.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/28.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation

struct   TotalCountViewModelInput {
}

protocol   TotalCountViewModelOutput {
}

protocol  TotalCountViewModelType {
    var outputs: TotalCountViewModelOutput? { get }
    func setup(input: TotalCountViewModelInput)
}

final class   TotalCountViewModel: TotalCountViewModelType, Injectable, TotalCountViewModelOutput {
    typealias Dependency = TotalCountModelType

    private let model: TotalCountModelType
    var outputs: TotalCountViewModelOutput?

    init(with dependency: Dependency) {
        model = dependency
        self.outputs = self

    }

    func setup(input: TotalCountViewModelInput) {

    }

}
