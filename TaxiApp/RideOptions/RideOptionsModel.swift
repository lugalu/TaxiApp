//Created by Lugalu on 08/12/24.

import SwiftUI
import MapKit

class RideOptionsModel: ObservableObject {
    var locator: ServiceLocator
    @Binding var rideDetails: RideData?
    
    @Published var polyLine: MKPolyline? = nil
    @Published var isMapLoading: Bool = true
    
    @Published var showDriverDetails: Bool = false
    @Published var selectedDriver: Int = -1
    
    @Published var isNetworkLoading: Bool = false
    
    @Published var shouldShowError: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            shouldShowError = !errorMessage.isEmpty
        }
    }
    
    @Published var shouldShowRideFinished: Bool = false
    
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
    
    func confirmRide(driver: DriverData) {
        Task {
            do{
                guard let rideDetails else {
                    return
                }
                
                await setLoading(status: true)
                defer{
                    Task{ @MainActor in
                        setLoading(status: false)
                    }
                }
                
                let networkService = locator.getNetworkInterface()
                
                let confirmationBody = RideDataToConfirmation.map(data: rideDetails, driver: driver)
                let (data, response) = try await networkService.downloadData(for: .confirm(rideData: confirmationBody))
                
                guard let responseStatus = (response as? HTTPURLResponse)?.statusCode else {
                    await setErrorMessage("Um erro desconhecido aconteceu!")
                    return
                }
                
                let decoderService = locator.getDecoderInterface()
                guard responseStatus == 200 else {
                    let error = try decoderService.decode(data, class: ErrorResponseJSON.self)
                    await setErrorMessage(error.error_description)
                    return
                }
            
                await didFinishRequest()
                
                
            }  catch NetworkErrors.malformedURL {
                await setErrorMessage(NetworkErrors.malformedURL.localizedDescription)
                
            } catch {
                await setErrorMessage("algum erro ocorreu com seu pedido, por favor tente novamente.")
               
                
            }
        }
    }
    
   
    
    @MainActor func setLoading(status: Bool) {
        self.isNetworkLoading = status
    }
    
    @MainActor
    private func setErrorMessage(_ message: String) {
        self.errorMessage = message
    }
    
    @MainActor
    private func didFinishRequest() {
        shouldShowRideFinished = true
    }
    
    func formatMoney(_ value: Double) -> String {
        let asNumber = NSNumber(floatLiteral: value)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: asNumber) ?? ("R$" + String(value))
    }
    
    func formatDistance(_ value: Double) -> String {
        let value = Measurement(value: value, unit: UnitLength.kilometers)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter.maximumFractionDigits = 2
        
        return formatter.string(from: value)
    }
    
    func formatNumber(_ value: Double) -> String {
        let number = NSNumber(value: value)
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter.string(from: number) ?? String(format: "%2f", value)
    }
    
    func isDriverElegible(_ driverId: Int, _ distance: Double) -> Bool {
        switch driverId {
        case 1:
            return distance >= 1
        case 2:
            return distance >= 5
        case 3:
            return distance >= 10
        default:
            return false
        }
    }
    
}
