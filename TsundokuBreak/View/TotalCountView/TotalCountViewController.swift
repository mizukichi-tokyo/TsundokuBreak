//
//  TotalCountViewController.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/28.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import Cards

class TotalCountViewController: UIViewController, Injectable {

    typealias Dependency = TotalCountViewModelType
    private let viewModel: TotalCountViewModelType

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
