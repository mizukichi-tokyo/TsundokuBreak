import UIKit
import ColorMatchTabs

class StubContentViewControllersProvider {

    static let viewControllers: [UIViewController] = {
        //        let productsViewController = StubContentViewController()
        //        productsViewController.type = .products

        let productsViewController = FirstViewController()

        //        let venuesViewController = StubContentViewController()
        //        venuesViewController.type = .venues

        let venuesViewController = FirstViewController()

        //        let reviewsViewController = StubContentViewController()
        //        reviewsViewController.type = .reviews

        let reviewsViewController = FirstViewController()

        //        let usersViewController = StubContentViewController()
        //        usersViewController.type = .users

        let usersViewController = FirstViewController()

        return [productsViewController, venuesViewController, reviewsViewController, usersViewController]
    }()

}
