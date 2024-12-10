//Created by Lugalu on 09/12/24.

import SwiftUI

struct FormTextfield: View {
    var title: String?
    @Binding var textBinding: String
    var placeholder: String?
    
    init(_ textBinding: Binding<String>, title: String? = nil, placeholder: String? = nil) {
        self.title = title
        self._textBinding = textBinding
        self.placeholder = placeholder
    }
    
    var body: some View {
        LazyVStack(alignment: .leading){
            if let title {
                Text(title)
            }
            
            TextField(text: $textBinding, label: {
                if let placeholder {
                    Text(placeholder)
                }
            })
            .textFieldStyle(.roundedBorder)
        }
    }
}
