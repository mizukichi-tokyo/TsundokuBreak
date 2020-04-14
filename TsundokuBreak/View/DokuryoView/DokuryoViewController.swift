//
//  DokuryoViewController.swift
//  DokuryoBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm
import DZNEmptyDataSet

class DokuryoViewController: UIViewController, Injectable {

    typealias Dependency = DokuryoViewModelType
    private let viewModel: DokuryoViewModelType

    private var cellDataArray = [CellData]()
    private let cellDeleteRelay: PublishRelay<Int>
    private let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self

            tableView.register(
                UINib(nibName: R.string.dokuryoView.dokuryoTableViewCell(), bundle: nil),
                forCellReuseIdentifier: R.reuseIdentifier.customDokuryoTableCell.identifier
            )
        }
    }

    required init(with dependency: Dependency) {
        viewModel = dependency
        self.cellDeleteRelay = PublishRelay<Int>()
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
        let input = DokuryoViewModelInput(
            cellDeleteRelay: cellDeleteRelay
        )
        viewModel.setup(input: input)

        viewModel.outputs?.recordsChangeObservable
            .subscribe(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.outputs?.cellDataDriver
            .drive(onNext: { cellData in
                self.cellDataArray = cellData
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

    }

}

extension DokuryoViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return cellDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.customDokuryoTableCell.identifier) as! DokuryoTableViewCell
        // swiftlint:enable force_cast
        guard cellDataArray.count != 0 else { return cell }

        cell.delegate = self
        cell.indexPathRowTag = indexPath.row
        cell.setCell(cellData: cellDataArray[indexPath.row])

        return cell
    }
}

extension DokuryoViewController: CellDeleteDelegate {
    func deleteCell(indexPathRow: Int) {
        cellDeleteRelay.accept(indexPathRow)
    }
}

extension DokuryoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension DokuryoViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -60
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return R.image.box()
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(
            string: R.string.dokuryoViewController.alertTitle(),
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont.boldSystemFont(ofSize: 20)
        ])
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(
            string: R.string.dokuryoViewController.alertDescription(),
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 15)
        ])

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
