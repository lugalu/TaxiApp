//Created by Lugalu on 06/12/24.

import SwiftUI
import UIKit

@main
struct TaxiAppApp: App {
    
    var serviceLocator: ServiceLocator
    @ObservedObject var tabBarService: TabBarService
    
    init() {
        let tabBar = TabBarService()
        let serviceLocator = ServiceLocator(networkService: NetworkService(), decoderService: DecoderService(), mapService: MapService(), tabBarService: tabBar)
        self.serviceLocator = serviceLocator
        self.tabBarService = tabBar
    }

    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabBarService.tabBarIndex){
                RideRequestView()
                    .environmentObject(RideRequestModel(locator: serviceLocator))
                    .tabItem({
                        Image(systemName: "car.fill")
                        Text("Pedir uma viagem")
                    })
                    .tag(1)

                RideListingView()
                    .environmentObject(RideListingModel(locator: serviceLocator))
                    .tabItem({
                        Image(systemName: "list.bullet.clipboard.fill")
                        Text("Historico de viagens")
                    })
                    .tag(2)

            }
            .environment(serviceLocator)
        }

    }
}
