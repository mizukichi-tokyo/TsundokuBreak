import UIKit
import ColorMatchTabs

class StubContentViewControllersProvider {

    static let viewControllers: [UIViewController] = {

        //        let totalCountViewController = TotalCountViewController.makeVC()
        let totalCountViewController = TsundokuViewController.makeVC()

        let tsundokuViewController = DokuryoViewController.makeVC()

        let dokuryoViewController = DokuryoViewController.makeVC()

        return [totalCountViewController, tsundokuViewController, dokuryoViewController]
    }()

}
