//Created by Lugalu on 06/12/24.

import Foundation

enum NetworkErrors: LocalizedError {
    case malformedURL
    case responseError
    case emptyResponse
    
    var errorDescription: String? {
        return switch self {
        case .malformedURL:
            "A operação não pode ser concluida por um erro nosso!"
            
        case .responseError:
            "O servidor retornou dados invalidos, tente novamente"

        case .emptyResponse:
            "Não existem dados com os critérios definidos"
        }
    }
}
