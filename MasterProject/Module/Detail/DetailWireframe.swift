
import UIKit

class DetailWireframe: WireframeProtocol {

    var view: DetailViewController!
    var interactor: AnyObject?
    var presenter: DetailPresenter! = DetailPresenter()

    var navigationController: UINavigationController!
    
    init(item: MainTabItemModel) {
        view = View.load(presenter: presenter)

        presenter.view = view
        presenter.wireframe = self
        presenter.item = item
    }

}

