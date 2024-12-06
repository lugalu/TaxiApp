//Created by Lugalu on 06/12/24.

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            do {
                let id = "CT03"
                let start = "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031"
                let end = "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200"
                
                let rideDetails = try await test1(id, origin: start, destination: end)
                
                guard let firstDriver = rideDetails.options.first else {
                    print("no valid drivers")
                    return
                }
                let rideConfirmation = RideConfimation(id: "CT03", origin: start, destination: end, distance: rideDetails.distance, duration: String(rideDetails.duration), driverID: firstDriver.id, driverName: firstDriver.name, value: firstDriver.value)
                
                let (rideData, rideResponse) = try await NetworkService().downloadData(for: .confirm(rideData: rideConfirmation))
                
                guard let rideStatus = (rideResponse as? HTTPURLResponse)?.statusCode else {
                    throw NetworkErrors.responseError
                }
                
                guard rideStatus == 200 else {
                    let error = try DecoderService().decode(rideData, class: ErrorResponseJSON.self)
                     print(error)
                     return
                }
                
                
                let result = try DecoderService().decode(rideData, class: [String: Bool].self)
                print(result)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func test1(_ id: String, origin: String, destination: String) async throws -> RideJSON {
        let (data, response) = try await NetworkService().downloadData(for: .rideEstimate(id: id, start: origin, end: destination))
        
        guard let responseStatus = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkErrors.responseError
        }
        
        guard responseStatus == 200 else {
           let error = try DecoderService().decode(data, class: ErrorResponseJSON.self)
            print(error)
            throw NetworkErrors.responseError
        }

        return try DecoderService().decode(data, class: RideJSON.self)
    }
    
}

#Preview {
    ContentView()
}







