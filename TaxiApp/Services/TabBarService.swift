//Created by Lugalu on 09/12/24.

import SwiftUI

protocol TabBarInterface: AnyObject, ObservableObject {
    @MainActor func goToHistoryPage()
}


class TabBarService: ObservableObject, TabBarInterface {
    @Published var tabBarIndex: Int = 1
    
    @MainActor
    func goToHistoryPage() {
        tabBarIndex = 2
    }
}
