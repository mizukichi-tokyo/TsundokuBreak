import UIKit
import ColorMatchTabs

class StubContentViewControllersProvider {

    static let viewControllers: [UIViewController] = {

        let productsViewController = TotalCountViewController.makeVC()

        let venuesViewController = TotalCountViewController.makeVC()

        let reviewsViewController = FirstViewController()

        let usersViewController = FirstViewController()

        return [productsViewController, venuesViewController, reviewsViewController, usersViewController]
    }()

}

extension TotalCountViewController {
    static func makeVC () -> TotalCountViewController {
        let model = TotalCountModel(with: TotalCountModel.Dependency.init())
        let viewModel =  TotalCountViewModel(with: model)
        let viewControler =  TotalCountViewController(with: viewModel)
        return viewControler
    }
}
