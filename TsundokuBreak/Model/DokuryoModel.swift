//
//  DokuryoModel.swift
//  DokuryoBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import Foundation

struct  DokuryoModelInput {
}

protocol  DokuryoModelOutput {
}

protocol DokuryoModelType {
    var outputs: DokuryoModelOutput? { get }
    func setup(input: DokuryoModelInput)
}

final class  DokuryoModel: DokuryoModelType, Injectable, DokuryoModelOutput {
    struct Dependency {}

    var outputs: DokuryoModelOutput?

    init(with dependency: Dependency) {
        self.outputs = self
    }

    func setup(input: DokuryoModelInput) {

    }

}
