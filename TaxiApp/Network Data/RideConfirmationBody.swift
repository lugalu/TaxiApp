//Created by Lugalu on 06/12/24.

import Foundation

struct RideConfirmationBody: Encodable {
    let id: String
    let origin: String
    let destination: String
    let distance: Double
    let duration: String
    let driver: DriverConfirmationInfo
    let value: Double
    
    struct DriverConfirmationInfo: Encodable {
        let id: Int
        let name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "customer_id"
        case origin
        case destination
        case distance
        case duration
        case driver
        case value
    }
    
    init(id: String, origin: String, destination: String, distance: Double, duration: String, driverID: Int, driverName: String, value: Double) {
        self.id = id
        self.origin = origin
        self.destination = destination
        self.distance = distance
        self.duration = duration
        self.driver = DriverConfirmationInfo(id: driverID, name: driverName)
        self.value = value
    }

    
}
