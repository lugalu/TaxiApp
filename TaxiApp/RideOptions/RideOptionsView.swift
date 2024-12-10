//Created by Lugalu on 08/12/24.

import SwiftUI
import MapKit

struct RideOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: RideOptionsModel
    
    var body: some View {
        List{
            if let rideDetails = viewModel.rideDetails {
                makeMainUI(rideDetails)
            }else {
                makeErrorUI()
            }
        }
        .listStyle(.plain)
        .navigationTitle("Detalhes da Viagem")
        .navigationBarTitleDisplayMode(.inline)
        .addLoadingOverlay($viewModel.isMapLoading)
        .addLoadingOverlay($viewModel.isNetworkLoading)
        .alert("Erro", isPresented: $viewModel.shouldShowError, actions: {
            Button {
                viewModel.errorMessage = ""
            } label: {
                Text("Ok")
            }
            
        }, message: {
            Text(viewModel.errorMessage)
        })
        .alert("Sucesso", isPresented: $viewModel.shouldShowRideFinished, actions: {
            Button {
                viewModel.changeTab()
                dismiss()
            } label: {
                Text("Ok")
            }
            
        }, message: {
            Text("Viagem concluida com sucesso, você sera redirecionado para a tela de Historico")
        })
    }
    
    @ViewBuilder
    func makeErrorUI() -> some View {
        Text("Algum erro serio aconteceu e nao sera possivel concluir essa viagem")
    }
    
    @ViewBuilder
    func makeMainUI(_ rideDetails: RideData) -> some View {
        Map {
            Marker("Origem", systemImage: "person.fill", coordinate: rideDetails.origin.coordinate)
            Marker("Destino", systemImage: "star.fill", coordinate: rideDetails.destination.coordinate)
            
            if let polyLine = viewModel.polyLine, polyLine.pointCount > 0 {
                   MapPolyline(polyLine)
                       .stroke(.tint, lineWidth: 3)
                
               }
        }
        .frame(height: 350)
        .tint(.blue)
        .sheet(isPresented: $viewModel.showDriverDetails){
            Group {
                if let driver = rideDetails.drivers.first(where: { $0.id == viewModel.selectedDriver }) {
                        makeDriverSheet(driver)
                    }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
 
        makeDriverList(rideDetails)
    }
    
    @ViewBuilder
    func makeDriverList(_ rideDetail : RideData) -> some View {
        let drivers = rideDetail.drivers.filter({ viewModel.isDriverElegible($0.id, rideDetail.distance)})
        
        ForEach(drivers, id: \.id) { driver in
            HStack{
                Button {
                    viewModel.selectedDriver = driver.id
                    viewModel.showDriverDetails = true
                } label: {
                    Image(systemName: "eye")
                }
                .buttonStyle(.borderless)
                
                
                VStack(alignment: .leading){
                    HStack(alignment: .firstTextBaseline) {
                        Text(driver.name)
                        Spacer()
                        Label(viewModel.formatNumber(driver.review.rating), systemImage: "star.fill")
                            .tint(.yellow)
                            .labelStyle(.invertedLabelStyle)
                            .font(.callout)
                    }
                    .font(.callout)
                    
                    
                    Text(driver.vehicle)
                        .font(.callout)
                        .foregroundStyle(Color.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text(viewModel.formatMoney(driver.value))
                }
                .padding(.horizontal, 4)
                
                Button {
                    viewModel.confirmRide(driver: driver)
                } label: {
                    Text("Pedir")
                }
                .buttonStyle(.bordered)
                
            }
        }
        .lineLimit(1)
    }
    
    @ViewBuilder
    func makeDriverSheet(_ driver: DriverData) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(driver.name)
                .font(.largeTitle)
            
            Divider()
            
            Section(header: Text("Dados").font(.title2)) {
                Text("Veiculo: \(driver.vehicle)")
                Label("Avaliações: " + viewModel.formatNumber(driver.review.rating), systemImage: "star.fill")
                    .labelStyle(.invertedLabelStyle)
            }
            
            Divider()
            
            Section(header: Text("Comentarios").font(.title2)) {
                Text(driver.review.comment)
            }
            
            Spacer()
        }
        .padding(16)
    }
    

}
