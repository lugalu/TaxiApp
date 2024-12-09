//Created by Lugalu on 08/12/24.

import SwiftUI

extension View {
    func addLoadingOverlay(_ isLoading: Binding<Bool>) -> some View {
        self
            .overlay {
                if isLoading.wrappedValue {
                    ZStack {
                        Color.clear.background(.ultraThinMaterial)
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(3, anchor: .center)
                            .tint(.blue)
                    }
                }
            }
    }

}




