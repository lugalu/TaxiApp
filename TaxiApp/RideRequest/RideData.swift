//Created by Lugalu on 08/12/24.

import MapKit

struct RideData {
    let customerId: String
    let originName: String
    let destinationName: String
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

struct RideDataToConfirmation {
    private init(){}
    
    static func map(data: RideData, driver: DriverData) -> RideConfirmationBody {
        let customerId = data.customerId
        let originName = data.originName
        let destinationName = data.destinationName
        let distance = data.distance
        let duration = data.duration
        let driverId = driver.id
        let driverName = driver.name
        let value = driver.value
        
        return RideConfirmationBody(id: customerId,
                                    origin: originName,
                                    destination: destinationName,
                                    distance: distance,
                                    duration: duration,
                                    driverID: driverId,
                                    driverName: driverName,
                                    value: value)
    }
}
