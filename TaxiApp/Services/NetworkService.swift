//Created by Lugalu on 06/12/24.

import Foundation

protocol NetworkInterface {
    func downloadData(for: NetworkOptions) async throws -> (Data, URLResponse)
}

enum NetworkOptions {
    case rideEstimate(id: String, start: String, end: String)
    case confirm(rideData: RideConfimation)
    case list(id: String, driverID: Int)
}

class NetworkService: NetworkInterface {
    
    func downloadData(for option: NetworkOptions) async throws -> (Data, URLResponse) {
        let urlRequest = try EndpointBuilder.build(for: option)
        return try await URLSession.shared.data(for: urlRequest)
    }
    
}


