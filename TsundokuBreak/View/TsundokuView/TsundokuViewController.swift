//
//  TsundokuViewController.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit

class TsundokuViewController: UIViewController, Injectable {

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

        // Do any additional setup after loading the view.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}

extension TsundokuViewController {
    static func makeVC () -> TsundokuViewController {
        let model = TsundokuModel(with: TsundokuModel.Dependency.init())
        let viewModel =  TsundokuViewModel(with: model)
        let viewControler =  TsundokuViewController(with: viewModel)
        return viewControler
    }
}
