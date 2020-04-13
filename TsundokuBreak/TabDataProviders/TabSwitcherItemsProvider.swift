import UIKit
import ColorMatchTabs

class TabItemsProvider {

    static let items = {
        return [
            TabItem(
                title: R.string.tabSwitcherItemsProvider.tsundokuList(),
                tintColor: UIColor.rgba(red: 253, green: 150, blue: 187, alpha: 1),
                normalImage: R.image.tsundoku_normal()!,
                highlightedImage: R.image.tsundoku_highlighted()!
            ),
            TabItem(
                title: R.string.tabSwitcherItemsProvider.tsundokuList(),
                tintColor: UIColor.rgba(red: 245, green: 154, blue: 95, alpha: 1),
                normalImage: R.image.check_normal()!,
                highlightedImage: R.image.check_highlighted()!
            )
        ]
    }()

}
