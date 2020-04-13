//
//  TsundokuViewController.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/31.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import MaterialComponents
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm
import DZNEmptyDataSet

class TsundokuViewController: UIViewController, Injectable {

    @IBAction func buttonTouch(_ sender: Any) {
        self.view.window?.rootViewController?.present(BarCodeReaderViewController.makeVC(), animated: true, completion: nil)
    }
    typealias Dependency = TsundokuViewModelType
    private let viewModel: TsundokuViewModelType

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self

            tableView.register(
                UINib(nibName: R.string.tsundokuView.tsundokuTableViewCell(), bundle: nil),
                forCellReuseIdentifier: R.reuseIdentifier.customTsundokuTableCell.identifier
            )
        }
    }

    private var cellDataArray = [CellData]()
    private let changeFlagRelay: PublishRelay<Int>
    private let changeReadPageRelay: PublishRelay<[Int]>
    private let disposeBag = DisposeBag()

    required init(with dependency: Dependency) {
        viewModel = dependency
        self.changeFlagRelay = PublishRelay<Int>()
        self.changeReadPageRelay = PublishRelay<[Int]>()
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
            changeFlagRelay: changeFlagRelay,
            changeReadPageRelay: changeReadPageRelay
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
            })
            .disposed(by: disposeBag)

    }

}

extension TsundokuViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return cellDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.customTsundokuTableCell.identifier) as! TsundokuTableViewCell
        // swiftlint:enable force_cast
        guard cellDataArray.count != 0 else { return cell }

        cell.delegate = self
        cell.indexPathRowTag = indexPath.row
        cell.setCell(cellData: cellDataArray[indexPath.row])

        return cell
    }
}

extension TsundokuViewController: CellValueChangeDelegate {
    func changeDokuryoFlag(indexPathRow: Int) {
        changeFlagRelay.accept(indexPathRow)
    }
    func changeReadPage(indexPathRow: Int, readPage: Int) {
        changeReadPageRelay.accept([indexPathRow, readPage])
    }
}

extension TsundokuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension TsundokuViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -60
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Search")
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "積読本を探そう！", attributes: [
            .foregroundColor: UIColor.gray,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ])
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "積読リストに登録しよう！", attributes: [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 15)
        ])

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
