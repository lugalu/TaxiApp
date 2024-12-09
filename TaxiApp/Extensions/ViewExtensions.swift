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
    
    func isHidden(_ isHidden: Bool) -> some View {
        self.opacity(isHidden ? 1 : 0)
    }
}



public struct InvertedLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            configuration.title
            configuration.icon
        }
    }
}

public extension LabelStyle where Self == InvertedLabelStyle {
    @MainActor @preconcurrency static var invertedLabelStyle: InvertedLabelStyle { InvertedLabelStyle()}
}
