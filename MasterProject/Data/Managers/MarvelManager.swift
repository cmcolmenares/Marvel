
import Foundation
import CryptoKit

// MARK: - MarvelCharactersParams

struct MarvelCharactersParams: Encodable {
    let apikey: String
    let timeStamp: String
    let hash: String
}

struct MarvelManager {
    
    private enum SearchCharactersService: String {
        case searchCharacters = "/v1/public/characters"
    }
    
    static private let ts = String(Date().timeIntervalSince1970)
    static private let hash = MD5(string: "\(ts)\(Enviroment.privateKey)\(Enviroment.publicKey)")
    
    static private var sharedSession: URLSession {
        return URLSession.shared
    }
    
    static private func getURL(service: SearchCharactersService, characterId: Int? = nil) -> String? {
        guard let _ = URL(string: Enviroment.mainURL + service.rawValue) else { return nil }
        var urlString = "\(Enviroment.mainURL)\(service.rawValue)"
        if let characterId = characterId { urlString.append("/\(characterId)") }
        
        urlString.append("?ts=\(ts)&apikey=\(Enviroment.publicKey)&hash=\(hash)")
        
        return urlString
    }
    
    static func buildModel(from data: Data) -> [Character]? {
        let model = try? JSONDecoder().decode(CharacterDataWrapper.self, from: data)
        return model?.data?.results
    }
    
    static private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    static func executeSearch(characterId: Int? = nil, completion: @escaping ([Character]?, Error?)->()) {

        guard let searchCharactersService = getURL(service: .searchCharacters, characterId: characterId), let url = URL(string: searchCharactersService) else { return }

        let task = sharedSession.dataTask(with: url) { (data, response, error) in

            if let error = error {
                completion(nil,NSError(domain: "", code: 000, userInfo: ["message": error.localizedDescription]))
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "", code: 000, userInfo: ["message": "Can't get data"]))
                return
            }

            guard let characterData = buildModel(from: data) else {
                completion(nil, NSError(domain: "", code: 000, userInfo: ["message": "Can't parse json"]))
                return
            }
            
            DispatchQueue.main.async { completion(characterData, nil) }
            return
        }

        task.resume()
    }
    
}
