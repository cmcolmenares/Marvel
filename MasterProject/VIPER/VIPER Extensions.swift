
import UIKit

public extension WireframeProtocol where View: UIViewController {

    func push(in navigationController: UINavigationController) {
        navigationController.pushViewController(view, animated: true)
    }

    func present(in viewController: UIViewController, completion: (() -> Void)? = nil) {
        viewController.present(view, animated: true, completion: completion)
    }

}

public extension Navigable where View: UIViewController {

    func push(in navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.pushViewController(view, animated: true)
    }

    func present(in viewController: UIViewController, modalPresentationStyle: UIModalPresentationStyle? = nil, completion: (() -> Void)? = nil) {
        if navigationController == nil {
            self.navigationController = UINavigationController(rootViewController: view)
        }
        navigationController?.modalPresentationStyle = modalPresentationStyle ?? iPadModalPresentationStyle
        navigationController?.preferredContentSize = CGSize(width: 600, height: 800)
        navigationController!.viewControllers = [view]
        viewController.present(navigationController!, animated: true, completion: completion)
    }

    func close(completion: (() -> Void)? = nil) {
        navigationController?.dismiss(animated: true, completion: completion)
    }

    func pop() {
        navigationController?.popViewController(animated: true)
    }

}

public protocol Navigable: WireframeProtocol, AnyObject {

    var navigationController: UINavigationController? { get set }

    //var iPadModalPresentationStyle: UIModalPresentationStyle! { get set }

}

public extension Navigable {

    var iPadModalPresentationStyle: UIModalPresentationStyle { return .formSheet }

}
