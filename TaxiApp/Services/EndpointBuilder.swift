//Created by Lugalu on 06/12/24.

import Foundation

class EndpointBuilder {
    private init() {}
    
    static func build(for option: NetworkOptions) throws -> URLRequest {
        let (components, type, body) = try getURLComponents(for: option)
        
        guard let url = components.url else {
            throw NetworkErrors.malformedURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type
        if let body{
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        return request
    }
    
    private static func getURLComponents(for option: NetworkOptions) throws -> (component: URLComponents,type: String, body: Data?) {
        let urlScheme = "https"
        let hostURL = "xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws"
        
        var urlBody: Data? = nil
        var urlType = ""
        var urlComponents = URLComponents()
        urlComponents.scheme = urlScheme
        urlComponents.host = hostURL
        
        switch option {
        case .rideEstimate(let id, let start, let end):
            let body: [String: String] = [
                            "customer_id": id,
                            "origin": start,
                            "destination": end
                        ]
            urlBody = try serialize(with: body)
            urlComponents.path = "/ride/estimate"
            urlType = "POST"
            
        case .confirm(let rideData):
            let data = try serialize(with: rideData)
            urlBody = data
            urlType = "PATCH"
            urlComponents.path = "/ride/confirm"
            
        case .list(let id, let driverID):
            let query = [
                URLQueryItem(name: "driver_id", value: String(driverID))
            ]
            urlComponents.path = "/ride/\(id)"
            urlComponents.queryItems = query
            urlType = "GET"
            
        }
        
        
        return (urlComponents, urlType, urlBody)
    }
    
    
    private static func serialize<T: Encodable>(with dict: T) throws -> Data {
        let encoder = JSONEncoder()
        let data = try encoder.encode(dict)
        return data
    }
    
}
