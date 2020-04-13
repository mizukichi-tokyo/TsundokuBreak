import UIKit
import ColorMatchTabs

class StubContentViewControllersProvider {

    static let viewControllers: [UIViewController] = {

        let tsundokuViewController = TsundokuViewController.makeVC()

        let dokuryoViewController = DokuryoViewController.makeVC()

        return [tsundokuViewController, dokuryoViewController]
    }()

}
