//Created by Lugalu on 06/12/24.

import Foundation

protocol DecoderInterface {
    func decode<T: Decodable>(_ data: Data, class: T.Type) throws -> T
}

class DecoderService: DecoderInterface {
    init() {}
    
    func decode<T:Decodable>(_ data: Data, class: T.Type) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
