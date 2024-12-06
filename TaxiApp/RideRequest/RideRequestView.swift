//Created by Lugalu on 06/12/24.

import SwiftUI

struct RideRequestView: View {
    @EnvironmentObject var viewModel: RideRequestModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "car.side.fill")
                    .font(.system(size: 96))
                
                Text("Fazer Pedido de viagem")
                    .font(.title)
                    .fontWeight(.bold)
                
                makeFormsField($viewModel.id, title: "Insira a identificação do usuário", placeholder: "CT01")
                
                makeFormsField($viewModel.origin, title: "Insira o local de partida", placeholder: "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031")

                makeFormsField($viewModel.destination, title: "Insira o destino da corrida", placeholder: "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200")
                
                Button {
                    viewModel.fetchRide()
                } label: {
                    Text("Calcular preço")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
                .disabled(viewModel.isSubmitButtonDisabled())
                
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .navigationDestination(isPresented: $viewModel.openOptions, destination: {
                Text("This is a placeholder")
            })
            

        }
        .overlay {
            viewModel.isLoading ? makeLoading() : nil
        }
    }
    
    
    @ViewBuilder
    func makeLoading() -> some View {
        ZStack{
            Color.gray.background(.ultraThinMaterial)
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(3, anchor: .center)
        }
    }
    
    @ViewBuilder
    func makeFormsField(_ textBinding: Binding<String>, title: String?, placeholder: String?) -> some View {
        VStack(alignment: .leading){
            if let title {
                Text(title)
            }
            
            TextField(text: textBinding, label: {
                if let placeholder {
                    Text(placeholder)
                }
            })
            .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    RideRequestView()
        .environmentObject(RideRequestModel(locator: ServiceLocator(networkService: nil, decoderService: nil)))
}
