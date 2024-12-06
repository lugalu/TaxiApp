//Created by Lugalu on 06/12/24.

import Foundation

class EndpointBuilder {
    private init() {}
    
    static func build(for option: NetworkOptions) throws -> URLRequest {
        let urlScheme = "https"
        let hostURL = "xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws"
        let (type, urlPath, urlBody) = try getRequestData(for: option)
        
        var components = URLComponents()
        components.scheme = urlScheme
        components.host = hostURL
        components.path = urlPath
        
        guard let url = components.url else {
            throw NetworkErrors.malformedURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = urlBody
        
        return request
    }

    
    private static func getRequestData(for option: NetworkOptions) throws -> (type: String, path: String, body: Data)  {
        switch option {
        case .rideEstimate(let id,let start, let end):
            let body: [String: String] = [
                "customer_id": id,
                "origin": start,
                "destination": end
            ]
            let bodyData = try serialize(with: body)
            
            return ("POST","/ride/estimate", bodyData)
        case .confirm(let info):
            let data = try serialize(with: info)
            return ("PATCH","/ride/confirm", data)
        case .list:
            return ("GET", "/ride/", Data())
        }
    }
    
    
    private static func serialize<T: Encodable>(with dict: T) throws -> Data {
        let encoder = JSONEncoder()
        let data = try encoder.encode(dict)
        return data
    }
    
}
