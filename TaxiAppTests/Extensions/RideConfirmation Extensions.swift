//Created by Lugalu on 10/12/24.

import Foundation
@testable import TaxiApp


extension RideConfirmationBody.DriverConfirmationInfo: @retroactive Decodable{
    enum CodingKeys: String, CodingKey {
            case id
            case name
        }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        self.init(id: id, name: name)
    }
    
    
}
extension RideConfirmationBody: @retroactive Decodable {
 

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let origin = try container.decode(String.self, forKey: .origin)
        let destination = try container.decode(String.self, forKey: .destination)
        let distance = try container.decode(Double.self, forKey: .distance)
        let duration = try container.decode(String.self, forKey: .duration)
        let driver = try container.decode(DriverConfirmationInfo.self, forKey: .driver)
        let value = try container.decode(Double.self, forKey: .value)
        
        self.init(id: id, origin: origin, destination: destination, distance: distance, duration: duration, driverID: driver.id, driverName: driver.name, value: value)
        
    }
}

extension RideConfirmationBody: @retroactive Equatable {
    static func < (lhs: RideConfirmationBody, rhs: RideConfirmationBody) -> Bool {
        return false
    }
    
    public static func == (lhs: RideConfirmationBody, rhs: RideConfirmationBody) -> Bool {
        return lhs.id == rhs.id &&
               lhs.origin == rhs.origin &&
               lhs.destination == rhs.destination &&
               lhs.distance == rhs.distance &&
               lhs.duration == rhs.duration &&
               lhs.driver == rhs.driver &&
               lhs.value == rhs.value
    }
}
extension RideConfirmationBody.DriverConfirmationInfo: @retroactive Equatable {
    static func < (lhs: RideConfirmationBody.DriverConfirmationInfo, rhs: RideConfirmationBody.DriverConfirmationInfo) -> Bool {
        return false
    }

    public static func == (lhs: RideConfirmationBody.DriverConfirmationInfo, rhs: RideConfirmationBody.DriverConfirmationInfo) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

