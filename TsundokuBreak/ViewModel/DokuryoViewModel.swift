//
//  DokuryoViewModel.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation

struct   DokuryoViewModelInput {
}

protocol   DokuryoViewModelOutput {
}

protocol  DokuryoViewModelType {
    var outputs: DokuryoViewModelOutput? { get }
    func setup(input: DokuryoViewModelInput)
}

final class   DokuryoViewModel: DokuryoViewModelType, Injectable, DokuryoViewModelOutput {
    typealias Dependency = DokuryoModelType

    private let model: DokuryoModelType
    var outputs: DokuryoViewModelOutput?

    init(with dependency: Dependency) {
        model = dependency
        self.outputs = self

    }

    func setup(input: DokuryoViewModelInput) {

    }

}
