//Created by Lugalu on 09/12/24.

import SwiftUI

class RideListingModel: ObservableObject {
    let locator: ServiceLocator
    
    init(locator: ServiceLocator) {
        self.locator = locator
    }
}
