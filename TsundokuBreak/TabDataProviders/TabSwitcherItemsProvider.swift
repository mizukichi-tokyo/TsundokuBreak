import UIKit
import ColorMatchTabs

class TabItemsProvider {

    static let items = {
        return [
            TabItem(
                title: "積読リスト",
                tintColor: UIColor(red: 0.51, green: 0.72, blue: 0.25, alpha: 1.00),
                normalImage: UIImage(named: "products_normal")!,
                highlightedImage: UIImage(named: "products_highlighted")!
            ),
            TabItem(
                title: "読了リスト",
                tintColor: UIColor(red: 0.15, green: 0.67, blue: 0.99, alpha: 1.00),
                normalImage: UIImage(named: "venues_normal")!,
                highlightedImage: UIImage(named: "venues_highlighted")!
            )
        ]
    }()

}
