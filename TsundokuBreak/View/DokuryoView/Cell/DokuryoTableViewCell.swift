//
//  DokuryoTableViewCell.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/04/12.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import AlamofireImage
import FaveButton

class DokuryoTableViewCell: UITableViewCell {

    var indexPathRowTag: Int?

    @IBOutlet weak var bookImage: UIImageView! {
        didSet {
            bookImage.image = UIImage.gif(name: "loading")
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(cellData: CellData) {
        titleLabel.text = cellData.title
        authorLabel.text = cellData.author
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

}
