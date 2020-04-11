//
//  DokuryoViewController.swift
//  DokuryoBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import MaterialComponents

class DokuryoViewController: UIViewController, Injectable {
    @IBAction func buttonTouch(_ sender: Any) {
        self.view.window?.rootViewController?.present(BarCodeReaderViewController.makeVC(), animated: true, completion: nil)
    }

    typealias Dependency = DokuryoViewModelType
    private let viewModel: DokuryoViewModelType

    required init(with dependency: Dependency) {
        viewModel = dependency
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension DokuryoViewController {
    static func makeVC () -> DokuryoViewController {
        let model = DokuryoModel(with: DokuryoModel.Dependency.init())
        let viewModel =  DokuryoViewModel(with: model)
        let viewControler =  DokuryoViewController(with: viewModel)
        return viewControler
    }
}
