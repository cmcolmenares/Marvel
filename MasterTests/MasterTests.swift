
import XCTest
@testable import MasterDEV

// MARK: - Testing mappers from json

class MasterTests: XCTestCase {
    private func loadJson(fileName: String) -> Data? {
       guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"), let data = try? Data(contentsOf: url) else {
            return nil
       }
       return data
    }
    
    func testBuildModelFromJsonSuccess() {
        guard let data: Data = loadJson(fileName: "MarvelResponse") else { return }
        let result = MarvelManager.buildModel(from: data)
        XCTAssertNotNil(result)
    }
    
    func testBuildModelFromJsonFailure() {
        guard let data: Data = loadJson(fileName: "MarvelResponseFailure") else { return }
        let result = MarvelManager.buildModel(from: data)
        XCTAssertNil(result)
    }
    
}
