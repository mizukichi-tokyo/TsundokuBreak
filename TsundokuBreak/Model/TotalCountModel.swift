//
//  TotalCountModel.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/28.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation

struct  TotalCountModelInput {
}

protocol  TotalCountModelOutput {
}

protocol TotalCountModelType {
    var outputs: TotalCountModelOutput? { get }
    func setup(input: TotalCountModelInput)
}

final class  TotalCountModel: TotalCountModelType, Injectable, TotalCountModelOutput {
    struct Dependency {}

    var outputs: TotalCountModelOutput?

    init(with dependency: Dependency) {
        self.outputs = self
    }

    func setup(input: TotalCountModelInput) {

    }

}
