//Created by Lugalu on 09/12/24.

import SwiftUI

class RideListingModel: ObservableObject {
    let locator: ServiceLocator
    
    @Published var id: String = ""
    @Published var selectedDriverId: Int = 0
    var drivers: [(Int, String)] = [
        (0, ""),
        (1, "Homer"),
        (2, "Dominic"),
        (3, "James"),
        (4, "Mostrar todos")
    ]
    
//    @Published var history: []
    
    init(locator: ServiceLocator) {
        self.locator = locator
    }
    
    func isButtonDisabled() -> Bool {
        return id.isEmpty || selectedDriverId == 0
    }
    
    
    func fetchHistory() {
        Task {
            do{
                let data = try await selectedDriverId == 4 ? fetchAll() : fetchSingle(driverId: selectedDriverId)
                
            } catch {
                print("hm")
            }
        }
    }
    
    
    func fetchSingle(driverId: Int) async throws -> HistoryData? {
        let downloadService = locator.getNetworkInterface()
        let (data, response) = try await downloadService.downloadData(for: .list(id: self.id, driverID: driverId))
        
        return nil
    }
    
    func fetchAll() async throws -> HistoryData? {
        return nil
    }
    
}

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
        
        try history.rides.forEach { ride in
            let date = try Date(ride.date, strategy: .dateTime)
            let time = try Date(ride.duration, strategy: .dateTime)
            let name = ride.driver.name
            
            let newData = HistoryData(date: date, origin: ride.origin, destination: ride.destination, distance: ride.distance, duration: time, driverName: name, value: ride.value)
            result.append(newData)
        }
        
        return result
    }
}

struct HistoryData {
    let date: Date
    let origin: String
    let destination: String
    let distance: Double
    let duration: Date
    let driverName: String
    let value: Double
}
