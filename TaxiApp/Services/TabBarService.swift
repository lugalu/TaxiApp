//Created by Lugalu on 09/12/24.


import SwiftUI

class TabBarService: ObservableObject {
    @Published var tabBarIndex: Int = 1
    
    @MainActor
    func goToHistoryPage() {
        tabBarIndex = 2
    }
}
