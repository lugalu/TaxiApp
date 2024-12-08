//Created by Lugalu on 08/12/24.

import SwiftUI
import MapKit

class RideOptionsModel: ObservableObject {
    var locator: ServiceLocator
    @Binding var rideDetails: RideData?
    @Published var polyLine: MKPolyline? = nil
    @Published var isMapLoading: Bool = true
    
    init(rideDetails: Binding<RideData?> = .constant(nil), locator: ServiceLocator) {
        self._rideDetails = rideDetails
        self.locator = locator
        fetchPolyline()
    }
    
    func fetchPolyline() {
        Task {
            do{
                let mapService = locator.getMapInterface()
                guard let rideDetails else { return }
                let directions = mapService.getDirections(rideDetails.origin, rideDetails.destination)
                let route = try await mapService.makeRoute(directions: directions)
                let polyline = route.polyline
                
                await assignPolyline(new: polyline)
                
                
            } catch MapErrors.noAvaiableRoutes {
                print(MapErrors.noAvaiableRoutes.localizedDescription)
            } catch {
                print("wololo", error.localizedDescription)
            }
        }
    }
    
    @MainActor
    private func assignPolyline(new: MKPolyline) {
        self.polyLine = new
        isMapLoading = false
    }
    
}
