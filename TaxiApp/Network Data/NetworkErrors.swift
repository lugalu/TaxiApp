//Created by Lugalu on 06/12/24.

import Foundation

enum NetworkErrors: LocalizedError {
    case malformedURL
    case responseError
    case error400
    case error404(name: String)
    case error406
    
    var errorDescription: String? {
        return switch self {
        case .malformedURL:
            "The operation couldn't be completed due to an error in url formation"
        case .responseError:
            "The server response is not correct"
        case .error400:
            "Invalid data was supplied to the server"
        case .error404(let name):
            "The \(name) couldn't be found"
        case .error406:
            "Invalid distance supplied"
        }
    }
}
