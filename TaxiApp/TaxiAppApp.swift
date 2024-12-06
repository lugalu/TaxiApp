//Created by Lugalu on 06/12/24.

import SwiftUI

@main
struct TaxiAppApp: App {
    var serviceLocator = ServiceLocator(networkService: NetworkService(), decoderService: DecoderService())
    
    var body: some Scene {
        WindowGroup {
            TabView{
                RideRequestView()
                    .environmentObject(RideRequestModel(locator: serviceLocator))
                    .tabItem({
                        Image(systemName: "car.fill")
                        Text("Request a ride")
                    })
                
            }
            .environment(serviceLocator)
        }
    }
}
