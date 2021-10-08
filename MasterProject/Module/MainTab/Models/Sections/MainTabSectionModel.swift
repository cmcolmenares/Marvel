
import Foundation

struct MainTabSectionModel {
    var title: String
    var items: [MainTabItemModel]
    
    init(title: String, items: [MainTabItemModel] = [MainTabItemModel]()) {
        self.title = title
        self.items = items
    }
}
