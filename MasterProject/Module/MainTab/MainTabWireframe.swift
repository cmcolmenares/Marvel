
import UIKit

class MainTabWireframe: WireframeProtocol {
    static let shared: MainTabWireframe = MainTabWireframe()

    var view: MainTabViewController!
    var interactor: MainTabInteractor? = MainTabInteractor()
    var presenter: MainTabPresenter! = MainTabPresenter()

    var navigationController: UINavigationController!

    init() {
        view = View.load(presenter: presenter)

        presenter.view = view
        presenter.wireframe = self
        presenter.interactor = interactor
        
        interactor?.presenter = presenter
        interactor?.wireframe = self
    }
    
    func navigateToDetail(with item: MainTabItemModel) {
        let detailWireframe = DetailWireframe(item: item)
        detailWireframe.push(in: navigationController)
    }

}

