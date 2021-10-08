
import UIKit

final class MainWireframe: WireframeProtocol {

    var view: MainViewController!
    var interactor: AnyObject?
    var presenter: MainPresenter! = MainPresenter()

    var mainNavigationController: UINavigationController!

    var mainTabWireframe = MainTabWireframe.shared

    init() {
        view = MainViewController.load(presenter: presenter)

        presenter.view = view
        presenter.wireframe = self

        mainNavigationController = UINavigationController(rootViewController: mainTabWireframe.view)
        mainTabWireframe.navigationController = mainNavigationController
    }

    func present(in window: UIWindow) {
        window.rootViewController = mainNavigationController
    }

}
