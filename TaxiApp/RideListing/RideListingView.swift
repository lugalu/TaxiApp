//Created by Lugalu on 09/12/24.

import SwiftUI

struct RideListingView: View {
    @EnvironmentObject var viewModel: RideListingModel
    @FocusState var isKeyboardOnScreen: Bool

    var body: some View {
            List {
                    makeHeader()
                
                    if viewModel.history.isEmpty {
                        Text("Não há informações disponiveis")
                    }else {
                        ForEach(viewModel.history) { entry in
                            makeCell(entry: entry)
                                .listRowSeparator(.visible)
                                .listRowSeparatorTint(.secondary)
                        }
                    }
            }
            .addLoadingOverlay($viewModel.isLoading)
            .listStyle(.plain)
            .alert("Erro", isPresented: $viewModel.shouldDisplayError, actions: {
                Button {
                    viewModel.errorMessage = ""
                } label: {
                    Text("Ok")
                }

            }, message: {
                Text(viewModel.errorMessage)
            })
    }
    
    @ViewBuilder
    func makeHeader() -> some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                FormTextfield($viewModel.id,
                              title: "usuario",
                              placeholder: "CT01")
                .focused($isKeyboardOnScreen)
                
                Picker("Motorista", selection: $viewModel.selectedDriverId) {
                    ForEach(viewModel.drivers, id: \.0) { driver in
                        Text(driver.1)
                    }
                }
            }
            
            Button{
                isKeyboardOnScreen = false
                viewModel.fetchHistory()
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
    
    @ViewBuilder
    func makeCell(entry: HistoryData) -> some View {
        HStack(alignment: .lastTextBaseline) {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(entry.driverName)")
                Text("De: \(entry.origin)")
                Text("Ate: \(entry.destination)")
            }
            
            Divider()
            
            VStack(alignment: .trailing, spacing: 8) {
                Group {
                    Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                    Text("Duração: \(entry.duration)")
                }
                .font(.caption)
                .foregroundStyle(Color.secondary)
                .padding(.bottom, 2)
                Text("Total: \(viewModel.formatMoney(entry.value))")
            }
        }
        .padding(8)
        .lineLimit(1)
    }
}


#Preview {
    RideListingView()
        .environmentObject(
            RideListingModel(locator: ServiceLocator(networkService: NetworkService(), decoderService: DecoderService(), mapService: MapService(), tabBarService: TabBarService()))
        )
}
