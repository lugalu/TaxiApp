//Created by Lugalu on 06/12/24.

import SwiftUI

@main
struct TaxiAppApp: App {
    
    var serviceLocator: ServiceLocator
    @ObservedObject var tabBarService: TabBarService
    
    init() {
        let service = ServiceLocator(networkService: NetworkService(), decoderService: DecoderService(), mapService: MapService(), tabBarService: TabBarService())
        self.serviceLocator = service
        self.tabBarService = service.getTabBarService()
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
