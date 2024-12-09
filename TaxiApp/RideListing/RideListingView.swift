//Created by Lugalu on 09/12/24.

import SwiftUI

struct RideListingView: View {
    @EnvironmentObject var viewModel: RideListingModel
    
    var body: some View {
            List {
                LazyVStack {
                    makeHeader()
                    
                    //TODO: List here
                }
            }
            .listStyle(.plain)
    }
    
    @ViewBuilder
    func makeHeader() -> some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                FormTextfield($viewModel.id,
                              title: "usuario",
                              placeholder: "CT01")
                Picker("Motorista", selection: $viewModel.selectedDriverId) {
                    ForEach(viewModel.drivers, id: \.0) { driver in
                        Text(driver.1)
                    }
                }
            }
            
            Button{
                
            } label: {
                
                Image(systemName: "magnifyingglass")
                    .font(.largeTitle)
                    .frame(maxHeight: .infinity)
            }
            .disabled(viewModel.isButtonDisabled())
            .buttonStyle(.bordered)
            .tint(.blue)
            
        }
    }
}


#Preview {
    RideListingView()
        .environmentObject(
            RideListingModel(locator: ServiceLocator(networkService: NetworkService(), decoderService: DecoderService(), mapService: MapService(), tabBarService: TabBarService()))
        )
}
