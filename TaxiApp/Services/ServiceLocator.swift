//Created by Lugalu on 06/12/24.

import SwiftUI

class ServiceLocator: ObservableObject, Observable {
    private let networkService: NetworkInterface
    private let decoderService: DecoderInterface
    private let mapService: MapInterface
    
    init(networkService: NetworkInterface, decoderService: DecoderInterface, mapService: MapInterface) {
        self.networkService = networkService
        self.decoderService = decoderService
        self.mapService = mapService
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
}
