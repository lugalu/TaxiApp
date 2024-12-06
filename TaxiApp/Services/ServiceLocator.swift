//Created by Lugalu on 06/12/24.

import SwiftUI

class ServiceLocator {
    private let networkService: NetworkInterface
    private let decoderService: DecoderInterface
    
    init(networkService: NetworkInterface, decoderService: DecoderInterface) {
        self.networkService = networkService
        self.decoderService = decoderService
    }
}
