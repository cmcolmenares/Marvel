
import Foundation

final class MainTabInteractor: InteractorProtocol {
    
    weak var wireframe: MainTabWireframe?
    weak var presenter: MainTabPresenter?
    
    // MARK: - Load Model
    func loadModel(with response: [Character]) throws -> [MainTabSectionModel] {
        var model = [MainTabSectionModel]()

        model.append(MainTabSectionModel(title: "Marvel Heroes", items: loadMainTabItems(with: response)))
        return model
    }
    
    private func loadMainTabItems(with response: [Character]) -> [MainTabItemModel] {
        var items = [MainTabItemModel]()
        
        response.forEach({ element in
            items.append(MainTabItemModel(characterResponse: element, type: .infoCell))
        })
        
        return items
    }
    
    func getModelForDetail(with response: Character) -> MainTabItemModel {
        return MainTabItemModel(characterResponse: response, type: .infoCell)
    }
    
    // MARK: - Request Management
    
    func executeSearch(id: Int? = nil, completion: @escaping ([Character]?, Error?)->()) {
        MarvelManager.executeSearch(characterId: id, completion: { (response, error) in
            completion(response,error)
        })
    }
}
