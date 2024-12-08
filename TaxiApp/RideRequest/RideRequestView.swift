//Created by Lugalu on 06/12/24.

import SwiftUI

struct RideRequestView: View {
    @EnvironmentObject var viewModel: RideRequestModel
    @FocusState var isKeyboardOnScreen: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section{
                    makeHeader()
                }
                .listRowBackground(Color.clear)
                
                makeHistoryDropDown()
                
                Section("Informações") {
                    makeFormsField($viewModel.id,
                                   title: "Insira a identificação do usuário",
                                   placeholder: "CT01")
                    
                    makeFormsField($viewModel.origin,
                                   title: "Insira o local de partida",
                                   placeholder: "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031")
                    
                    makeFormsField($viewModel.destination,
                                   title: "Insira o destino da corrida",
                                   placeholder: "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200")
                    
                    makeConfirmButton()
                }
                .focused($isKeyboardOnScreen)

            }
            .scrollContentBackground(.hidden)
            .navigationDestination(isPresented: $viewModel.openOptions) {
                RideOptionsView()
                    .environmentObject(RideOptionsModel(rideDetails: $viewModel.rideContents,
                                                        locator: viewModel.serviceLocator)
                    )
             }
            
            

        }
        .addLoadingOverlay($viewModel.isLoading)
        .alert("Erro", isPresented: $viewModel.shouldShowError, actions: {
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
        VStack {
            Image(systemName: "car.side.fill")
                .font(.system(size: 96))
            
            Text("Fazer Pedido de viagem")
                .font(.title)
                .fontWeight(.bold)
        }
    }
    
    @ViewBuilder
    func makeHistoryDropDown() -> some View {
        Section("Historico de Viagens") {
            VStack {
                Picker("Origem", selection: $viewModel.selectedHistory) {
                    ForEach(Array(zip(viewModel.history, viewModel.history.indices)), id: \.1) { value, _ in
                        let title = value.origin.split(separator: ",").first ?? value.origin.prefix(17)
                        Text(title.isEmpty ? title : "\(title)...")                        
                    }
                }
                .pickerStyle(.menu)
            }
        }
        
    }
    
    @ViewBuilder
    func makeConfirmButton() -> some View {
        Button {
            isKeyboardOnScreen = false
            viewModel.fetchRide()
        } label: {
            Text("Calcular preço")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.isButtonEnabled)
    }
    
    @ViewBuilder
    func makeLoading() -> some View {
        ZStack{
            Color.clear.background(.ultraThinMaterial)
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(3, anchor: .center)
        }
    }
    

    
    @ViewBuilder
    func makeFormsField(_ textBinding: Binding<String>, title: String?, placeholder: String?) -> some View {
        LazyVStack(alignment: .leading){
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

