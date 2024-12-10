//Created by Lugalu on 09/12/24.

import SwiftUI

public struct InvertedLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 2) {
            configuration.title
            configuration.icon
        }
    }
}
