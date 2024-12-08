//Created by Lugalu on 08/12/24.

import SwiftUI
import MapKit

struct RideOptionsView: View {
    @EnvironmentObject var viewModel: RideOptionsModel
    
    var body: some View {
        VStack{
            if let rideDetails = viewModel.rideDetails {
                makeMainUI(rideDetails)
            }else {
                makeErrorUI()
            }
        }
        .navigationTitle("Detalhes da Viagem")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func makeMainUI(_ rideDetails: RideData) -> some View {
        Map {
     
            
            Marker("Origem", systemImage: "person.fill", coordinate: rideDetails.origin.coordinate)
            
            Marker("Destino", systemImage: "star.fill", coordinate: rideDetails.destination.coordinate)

            
            if let polyLine = viewModel.polyLine {
                MapPolyline(polyLine)
                    .stroke(.tint, lineWidth: 3)
            }
        }
        .tint(.blue)
        .addLoadingOverlay($viewModel.isMapLoading)
        Text("Hey!")
    }
    
    func makeErrorUI() -> some View {
        Text("Algum erro serio aconteceu e nao sera possivel concluir essa viagem")
    }
    
    
}




