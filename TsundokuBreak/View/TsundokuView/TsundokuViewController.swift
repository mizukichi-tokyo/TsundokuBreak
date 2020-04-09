//
//  TsundokuViewController.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import MaterialComponents

class TsundokuViewController: UIViewController, Injectable {

    @IBAction func buttonTouch(_ sender: Any) {
        self.view.window?.rootViewController?.present(BarCodeReaderViewController.makeVC(), animated: true, completion: nil)
    }
    typealias Dependency = TsundokuViewModelType
    private let viewModel: TsundokuViewModelType

    required init(with dependency: Dependency) {
        viewModel = dependency
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        let input = TsundokuViewModelInput(
        )
        viewModel.setup(input: input)
    }

}

extension TsundokuViewController {
    static func makeVC () -> TsundokuViewController {
        let model = TsundokuModel(with: TsundokuModel.Dependency.init())
        let viewModel =  TsundokuViewModel(with: model)
        let viewControler =  TsundokuViewController(with: viewModel)
        return viewControler
    }
}
