//Created by Lugalu on 06/12/24.

import SwiftUI

class ServiceLocator: ObservableObject, Observable {
    private let networkService: NetworkInterface
    private let decoderService: DecoderInterface
    private let mapService: MapInterface
    private let tabBarService: TabBarService
    
    init(networkService: NetworkInterface, decoderService: DecoderInterface, mapService: MapInterface, tabBarService: TabBarService) {
        self.networkService = networkService
        self.decoderService = decoderService
        self.mapService = mapService
        self.tabBarService = tabBarService
    }
    
    func getNetworkInterface() -> NetworkInterface {
        return networkService
    }
    
    func getDecoderInterface() -> DecoderInterface {
        return decoderService
    }
    
    func getMapInterface() -> MapInterface {
        return mapService
    }
    
    func getTabBarService() -> TabBarService {
        return tabBarService
    }
}




