
import Foundation

final class MainTabPresenter: PresenterProtocol {
    
    var view: MainTabViewController!
    var wireframe: MainTabWireframe!
    var interactor: MainTabInteractor?
    
    var model: [MainTabSectionModel] = [] {
        didSet {
            view?.reloadView()
        }
    }
        
    // MARK: - Lifecycle
    
    func viewDidLoad() {
        requestSearch()
    }
    
    // MARK: - PRESENTER METHODS
    
    func userDidSelectItem(_ indexPath: IndexPath) {
        if let id = model[indexPath.section].items[indexPath.row].characterResponse?.id {
            requestSearch(id, navigateToDetail: true)
        }
    }
    
    func requestSearch(_ id: Int? = nil, navigateToDetail: Bool = false) {
        view.showSpinner()
        interactor?.executeSearch(id: id, completion: { [weak self] (response, error) in
            self?.view?.hideSpinner()
            if let error = error {
                self?.view?.showErrorNotification(with: error.localizedDescription, message: nil)
                return
            }
            
            if let response = response {
                self?.handleResponse(response: response, navigateToDetail: navigateToDetail)
            }
        })
    }
    
    func handleResponse(response: [Character], navigateToDetail: Bool = false) {
        switch navigateToDetail {
        case true:
            if let response = response.first, let item = interactor?.getModelForDetail(with: response) {
                wireframe.navigateToDetail(with: item)
            }
        default:
            if let model = try? interactor?.loadModel(with: response) {
                self.model = model
            }
        }
    }
}
