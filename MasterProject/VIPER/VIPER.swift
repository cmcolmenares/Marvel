
import Foundation

public protocol ViewProtocol {
    associatedtype Presenter

    var presenter: Presenter! { get set }
}

public protocol PresenterProtocol {
    associatedtype View
    associatedtype Wireframe
    associatedtype Interactor

    var view: View! { get set }
    var wireframe: Wireframe! { get set }
    var interactor: Interactor? { get set }

    func viewDidLoad()
    func viewWillAppear()
}

public extension PresenterProtocol {
    func viewDidLoad() { }
    func viewWillAppear() { }
}

public protocol WireframeProtocol {
    associatedtype View
    associatedtype Presenter
    associatedtype Interactor

    var view: View! { get set }
    var presenter: Presenter! { get set }
    var interactor: Interactor? { get set }
}

public protocol InteractorProtocol {
    associatedtype Wireframe
    associatedtype Presenter

    var wireframe: Wireframe? { get set }
    var presenter: Presenter? { get set }
}
