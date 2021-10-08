
import Foundation

final class DetailPresenter: PresenterProtocol {
    
    var view: DetailViewController!
    var wireframe: DetailWireframe!
    var interactor: AnyObject?
    
    var item: MainTabItemModel?
    
    // MARK: - Lifecycle
    
    func viewDidLoad() {
        guard let item = item else { return }
        view?.setValue(for: item)
    }
}
