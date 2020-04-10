//
//  TsundokuTableViewCell.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/09.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import AlamofireImage
import fluid_slider

class TsundokuTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView! {
        didSet {
            bookImage.image = UIImage.gif(name: "loading")
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var slider: Slider!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setCell(cellData: CellData) {
        self.titleLabel.text = cellData.title
        self.authorLabel.text = cellData.author
        setImageUrl(cellData.thumbnailUrl)
        setSlider()
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

    private func setSlider() {
        slider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 3
            formatter.maximumFractionDigits = 0
            let string = formatter.string(from: (fraction * 500) as NSNumber) ?? ""
            return NSAttributedString(string: string)
        }
        slider.setMinimumLabelAttributedText(NSAttributedString(string: "0"))
        slider.setMaximumLabelAttributedText(NSAttributedString(string: "500"))
        slider.fraction = 0.5
        slider.shadowOffset = CGSize(width: 0, height: 10)
        slider.shadowBlur = 5
        slider.shadowColor = UIColor(white: 0, alpha: 0.1)
        slider.contentViewColor = UIColor(red: 0.15, green: 0.67, blue: 0.99, alpha: 1.00)
        slider.valueViewColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
