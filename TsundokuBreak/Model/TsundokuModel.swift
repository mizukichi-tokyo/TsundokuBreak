//
//  TsundokuModel.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation

struct  TsundokuModelInput {
}

protocol  TsundokuModelOutput {
}

protocol TsundokuModelType {
    var outputs: TsundokuModelOutput? { get }
    func setup(input: TsundokuModelInput)
}

final class  TsundokuModel: TsundokuModelType, Injectable, TsundokuModelOutput {
    struct Dependency {}

    var outputs: TsundokuModelOutput?

    init(with dependency: Dependency) {
        self.outputs = self
    }

    func setup(input: TsundokuModelInput) {

    }

}
