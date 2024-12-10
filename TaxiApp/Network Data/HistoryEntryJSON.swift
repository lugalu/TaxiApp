//Created by Lugalu on 10/12/24.

import Foundation

struct HistoryEntryJSON: Decodable {
    let rides: [HistoryRideJSON]
    
    
    struct HistoryRideJSON: Decodable {
        let date: String
        let origin: String
        let destination: String
        let distance: Double
        let duration: String
        let driver: HistoryDriverJSON
        let value: Double
    }
    
    struct HistoryDriverJSON: Decodable {
        let name: String
    }
}

struct HistoryJSONtoHistoryData {
    private init() {}
    
    static func map(_ history: HistoryEntryJSON) throws -> [HistoryData] {
        var result: [HistoryData] = []
        
        for ride in history.rides {
            guard let date = formatDate(ride.date) else {
                print("failed To convert Data")
                continue
            }
            let name = ride.driver.name
            let newData = HistoryData(date: date,
                                      origin: ride.origin,
                                      destination: ride.destination,
                                      distance: ride.distance,
                                      duration: ride.duration,
                                      driverName: name,
                                      value: ride.value)
            
            result.append(newData)
        }
        
        return result
    }
    
    static private func formatDate(_ value: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: value)
    }
}
