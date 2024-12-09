//Created by Lugalu on 06/12/24.

import MapKit

struct RideJSON: Decodable {
    let origin: CoordinateJSON
    let destination: CoordinateJSON
    let distance: Double
    let duration: Int
    let options: [DriverJSON]
    
    struct CoordinateJSON: Decodable {
        let latitude: Double
        let longitude: Double
    }
    
    struct DriverJSON: Decodable {
        let id: Int
        let name: String
        let description: String
        let vehicle: String
        let review: ReviewJSON
        let value: Double
        
        struct ReviewJSON: Decodable {
            let rating: Double
            let comment: String
        }
    }
}

struct RideJSONtoData {
    private init() {}
    
    static func map(customerId: String, originName: String, destinationName: String, json: RideJSON) -> RideData {
        let origin = CLLocation(latitude: json.origin.latitude,
                                longitude: json.origin.longitude)
        let destination = CLLocation(latitude: json.destination.latitude,
                                     longitude: json.destination.longitude)
        
        let distance = json.distance
        let duration = String(json.duration)
        let drivers = json.options.map {
            let review = ReviewData(rating: $0.review.rating, comment: $0.review.comment)
            
            return DriverData(id: $0.id,
                       name: $0.name,
                       description: $0.description,
                       vehicle: $0.vehicle,
                       review: review,
                       value: $0.value
            )
        }
        
        return RideData(customerId: customerId,
                        originName: originName,
                        destinationName: destinationName,
                        origin: origin,
                        destination: destination,
                        distance: distance,
                        duration: duration,
                        drivers: drivers)
    }
}
