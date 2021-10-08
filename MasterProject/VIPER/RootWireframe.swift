
import UIKit

final class RootWireframe {
    
    static let shared = RootWireframe()
    
    var window: UIWindow!
    
    var mainWireframe: MainWireframe?
    
    private init() {}
    
    func installRootViewControllerIntoWindow(_ window: UIWindow!){
        self.window = window
        mainWireframe = MainWireframe()
        mainWireframe?.present(in: window)
    }
    
}







