//
//  TsundokuTableViewCell.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/09.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import AlamofireImage

class TsundokuTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView! {
        didSet {
            bookImage.image = UIImage.gif(name: "loading")
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setCell(cellData: CellData) {
        self.titleLabel.text = cellData.title
        self.authorLabel.text = cellData.author
        setImageUrl(cellData.thumbnailUrl)
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

}
