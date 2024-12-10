//Created by Lugalu on 06/12/24.

import SwiftUI

protocol NetworkInterface {
    func downloadData(for: NetworkOptions) async throws -> (Data, Int)
    func isValidResponde(_ httpStatus: Int) -> Bool
    func downloadAndCheck(for option: NetworkOptions, decoderService: DecoderInterface, onError: (String) async -> Void) async throws -> Data?
}

enum NetworkOptions {
    case rideEstimate(id: String, start: String, end: String)
    case confirm(rideData: RideConfirmationBody)
    case list(id: String, driverID: Int)
}

class NetworkService: NetworkInterface {
    
    func executeRequest(for option: NetworkOptions) async throws -> (Data, URLResponse) {
        let urlRequest = try EndpointBuilder.build(for: option)
        return try await URLSession.shared.data(for: urlRequest)
    }
    
    func downloadData(for option: NetworkOptions) async throws -> (Data, Int) {
        let (data, response) = try await executeRequest(for: option)
      
        guard let httpResponse = (response as? HTTPURLResponse)?.statusCode else {
            let errorJSON = ErrorResponseJSON(error_code: "-1", error_description: "Resposta de server invalida")
            let data = try JSONSerialization.data(withJSONObject: errorJSON)
            return (data, -1)
        }
        
        return (data, httpResponse)
    }
    
    
    func downloadAndCheck(for option: NetworkOptions, decoderService: DecoderInterface, onError: (String) async -> Void) async throws -> Data? {
        let (data, response) = try await downloadData(for: option)
        
        guard isValidResponde(response) else {
            let error = try decoderService.decode(data, class: ErrorResponseJSON.self)
            await onError(error.error_description)
            return nil
        }
        return data
    }
    
    func isValidResponde(_ httpStatus: Int) -> Bool {
        return httpStatus == 200
    }
    
    
    
    
}


