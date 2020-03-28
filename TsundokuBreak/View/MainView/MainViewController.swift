//
//  MainViewController.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/28.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

//
//  TabViewController.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/28.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import ColorMatchTabs

class TabViewController: ColorMatchTabsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        colorMatchTabDataSource = self
    }

}

extension TabViewController: ColorMatchTabsViewControllerDataSource {

    func numberOfItems(inController controller: ColorMatchTabsViewController) -> Int {
        return TabItemsProvider.items.count
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, viewControllerAt index: Int) -> UIViewController {
        return StubContentViewControllersProvider.viewControllers[index]
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, titleAt index: Int) -> String {
        return TabItemsProvider.items[index].title
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, iconAt index: Int) -> UIImage {
        return TabItemsProvider.items[index].normalImage
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, hightlightedIconAt index: Int) -> UIImage {
        return TabItemsProvider.items[index].highlightedImage
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, tintColorAt index: Int) -> UIColor {
        return TabItemsProvider.items[index].tintColor
    }

}
