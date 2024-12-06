//Created by Lugalu on 06/12/24.

import SwiftUI

class ServiceLocator: ObservableObject, Observable {
    private let networkService: NetworkInterface?
    private let decoderService: DecoderInterface?
    
    init(networkService: NetworkInterface?, decoderService: DecoderInterface?) {
        self.networkService = networkService
        self.decoderService = decoderService
    }
    
    func getNetworkInterface() -> NetworkInterface? {
        return networkService
    }
    
    func getDecoderInterface() -> DecoderInterface? {
        return decoderService
    }
}
