//
//  TsundokuTableViewCell.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/09.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import AlamofireImage
import FaveButton
import RxSwift
import RxCocoa
import CDAlertView

class TsundokuTableViewCell: UITableViewCell, FaveButtonDelegate {
    weak var delegate: CellValueChangeDelegate?
    var indexPathRowTag: Int?
    private var pageCount: Int = 0
    private let readPageRelay = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var bookImage: UIImageView! {
        didSet {
            bookImage.image = UIImage.gif(name: "loading")
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var pickerView: BalloonPickerView!
    @IBOutlet weak var checkButton: FaveButton!

    @IBAction func checkTouchUp(_ sender: Any) {
        checkButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
            //print("2.0秒後に実行")
            self.delegate?.changeDokuryoFlag(indexPathRow: self.indexPathRowTag!)
            let alert = CDAlertView(title: "読了おめでとう！", message: "読了リストに本を追加しました", type: .custom(image: R.image.popper()!))
            alert.circleFillColor = UIColor.systemGray5
            alert.hideAnimationDuration = 0.88
            alert.show()
        }
    }

    @IBAction func sliderChangeValue(_ sender: Any) {
        let readPage = Int(floor(pickerView.value))
        readPageRelay.accept(readPage)
    }

    @IBAction func touchUpSlider(_ sender: Any) {
        let readPage = Int(floor(pickerView.value))
        self.delegate?.changeReadPage(indexPathRow: self.indexPathRowTag!, readPage: readPage)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let balloonView = BalloonView()
        balloonView.image = #imageLiteral(resourceName: "balloon")
        pickerView.baloonView = balloonView
        pickerView.value = 0

        readPageRelay
            .subscribe(onNext: { [weak self] readPage in
                guard let self = self else {return}
                self.pageCountLabel.text = "読書進捗: "+String(readPage)+"/"+String(self.pageCount)
            })
            .disposed(by: disposeBag)

    }

    func setCell(cellData: CellData) {
        titleLabel.text = cellData.title
        authorLabel.text = cellData.author
        setImageUrl(cellData.thumbnailUrl)
        setPicker(cellData)
        setCheckButton()
        pageCount = cellData.pageCount
        pageCountLabel.text = "読書進捗: "+String(cellData.readPage)+"/"+String(pageCount)
    }

    private func setImageUrl(_ urlString: String) {
        let url = URL(string: urlString)!
        let filter = AspectScaledToFillSizeFilter(size: self.bookImage.frame.size)
        let placeFolder = UIImage.gif(name: "loading")
        bookImage.af.setImage(
            withURL: url,
            placeholderImage: placeFolder,
            filter: filter,
            imageTransition: .crossDissolve(0.5)
        )
    }

    private func setPicker(_ cellData: CellData) {
        pickerView.maximumValue = Double(cellData.pageCount)
        pickerView.value = Double(cellData.readPage)
    }

    private func setCheckButton() {
        checkButton.isEnabled = true
        checkButton.setSelected(selected: false, animated: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
    }

}
