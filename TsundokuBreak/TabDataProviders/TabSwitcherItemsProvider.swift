import UIKit
import ColorMatchTabs

class TabItemsProvider {

    static let items = {
        return [
            TabItem(
                title: "積読リスト",
                tintColor: UIColor.rgba(red: 253, green: 150, blue: 187, alpha: 1),
                normalImage: UIImage(named: "tsundoku_normal")!,
                highlightedImage: UIImage(named: "tsundoku_highlighted")!
            ),
            TabItem(
                title: "読了リスト",
                tintColor: UIColor.rgba(red: 245, green: 154, blue: 95, alpha: 1),
                normalImage: UIImage(named: "check_normal")!,
                highlightedImage: UIImage(named: "check_highlighted")!
            )
        ]
    }()

}
