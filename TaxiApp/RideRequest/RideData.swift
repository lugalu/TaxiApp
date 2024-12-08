//Created by Lugalu on 08/12/24.

import MapKit

struct RideData {
    let origin: CLLocation
    let destination: CLLocation
    let distance: Double
    let duration: String
    let drivers: [DriverData]
    
    func getCoordinates2DArray() -> [CLLocationCoordinate2D] {
        return [origin.coordinate, destination.coordinate]
    }
    
}

struct DriverData: Decodable {
    let id: Int
    let name: String
    let description: String
    let vehicle: String
    let review: ReviewData
    let value: Double
}
struct ReviewData: Decodable {
    let rating: Double
    let comment: String
}
