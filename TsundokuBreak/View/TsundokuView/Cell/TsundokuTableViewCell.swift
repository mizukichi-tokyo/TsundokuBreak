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

class TsundokuTableViewCell: UITableViewCell, FaveButtonDelegate {

    @IBOutlet weak var bookImage: UIImageView! {
        didSet {
            bookImage.image = UIImage.gif(name: "loading")
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pickerView: BalloonPickerView!

    weak var delegate: CellSwitchDelegate?
    var indexPathRowTag: Int?

    @IBOutlet weak var checkButton: FaveButton!

    @IBAction func checkTOuchUp(_ sender: Any) {
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
        //            print("2.0秒後に実行")
        //            self.delegate?.changeDokuryoFlag(indexPathRow: self.indexPathRowTag!)
        //        }
    }

    @IBAction func touchUpSlider(_ sender: Any) {
        print("Touch Up!")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let balloonView = BalloonView()
        balloonView.image = #imageLiteral(resourceName: "balloon")
        pickerView.baloonView = balloonView
        pickerView.value = 30
        //        pickerView.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

    }

    func setCell(cellData: CellData) {
        self.titleLabel.text = cellData.title
        self.authorLabel.text = cellData.author
        setImageUrl(cellData.thumbnailUrl)
        checkButton.isSelected = false
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
    }

}
