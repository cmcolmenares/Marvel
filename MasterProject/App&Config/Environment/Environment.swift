
import Foundation

open class Enviroment {
    
    public enum DataEnviroment: String {
        case release
        case dev
    }
    
    static public var current: DataEnviroment = .release {
        didSet{
            switch current {
                case .release: //Production values
                    mainURL = "https://gateway.marvel.com:443"
                case .dev: //Development values
                    mainURL = "https://gateway.marvel.com:443"
            }
        }
    }
    
    //Production values
    static public var mainURL = "https://gateway.marvel.com:443"
    static public var logEnable = false
    static public var publicKey = "7801ba1cf7c50ee4efa3d0d77f4c834e"
    static public var privateKey = "cb8e2d80a4c7838cf5ecce6c880711a32689a9a2"
    
    static public var proccesEnviroment: String { current.rawValue }
    
}

