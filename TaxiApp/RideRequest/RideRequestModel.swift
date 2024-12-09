//Created by Lugalu on 06/12/24.

import SwiftUI
import Combine

class RideRequestModel: ObservableObject {
    var serviceLocator: ServiceLocator
    @Published var shouldShowError: Bool = false
    @Published var selectedHistory = 0 {
        didSet {
            guard selectedHistory != 0 else { return }
            updateFieldsOnSelection()
        }
    }
    @Published var history: [(id: String,origin: String,destination: String)] = [
        ("", "", ""),
        ("CT01", "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031", "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200"),
        ("CT03", "Av. Thomas Edison, 365 - Barra Funda, São Paulo - SP, 01140-000", "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200"),
        ("CT02", "Av. Brasil, 2033 - Jardim America, São Paulo - SP, 01431-001", "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200")
    ]
    
    @Published var errorMessage: String = "" {
        didSet {
            shouldShowError = !errorMessage.isEmpty
        }
    }
    @Published var isLoading: Bool = false
    @Published var openOptions: Bool = false
    
    @Published var id: String = ""
    @Published var origin: String = ""
    @Published var destination: String = ""
    @Published var rideContents: RideData? = nil
    
    @Published var isButtonEnabled: Bool = false
    
    init(locator: ServiceLocator) {
        self.serviceLocator = locator
        $id
            .combineLatest($origin, $destination)
            .map({ ($0.0.isEmpty || $0.1.isEmpty || $0.2.isEmpty) })
            .removeDuplicates()
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .assign(to: &$isButtonEnabled)
    }
    
    private func updateFieldsOnSelection() {
        let (newID, newOrigin, newDestination) = history[selectedHistory]
        id = newID
        origin = newOrigin
        destination = newDestination
    }
    
    func fetchRide() {
        Task {
            do {
                await toggleLoading()
                defer {
                    Task { @MainActor in
                        toggleLoading()
                    }
                }

                let downloadService = serviceLocator.getNetworkInterface()
                let (data, response) = try await downloadService.downloadData(for:
                        .rideEstimate(
                            id: id,
                            start: origin,
                            end: destination
                        )
                )
                
                guard let responseStatus = (response as? HTTPURLResponse)?.statusCode else {
                    await setErrorMessage("Um erro desconhecido aconteceu!")
                    return
                }
                
                let decoderService = serviceLocator.getDecoderInterface()
                guard responseStatus == 200 else {
                    let error = try decoderService.decode(data, class: ErrorResponseJSON.self)
                    await setErrorMessage(error.error_description)
                    return
                    
                }
                
                let json = try decoderService.decode(data, class: RideJSON.self)
                
                guard !json.options.isEmpty else {
                    await setErrorMessage("não há motoristas disponiveis para esta viagem, por favor verifique os dados")
                    return
                }
                
                let result = RideJSONtoData.map(customerId: id, originName: origin, destinationName: destination, json: json)
                await goToNextScreen(ride: result)

            } catch NetworkErrors.malformedURL {
                await setErrorMessage(NetworkErrors.malformedURL.localizedDescription)
                
            } catch {
                await setErrorMessage("algum erro ocorreu com seu pedido, por favor tente novamente.")
               
                
            }
            
        }
        
    }
    
    @MainActor
    private func toggleLoading() {
        isLoading.toggle()
    }
    
    @MainActor
    private func goToNextScreen(ride: RideData) {
            self.rideContents = ride
            self.openOptions = true
    }

    @MainActor
    private func setErrorMessage(_ message: String) {
        errorMessage = message
    }
    
    @MainActor
    func isSubmitButtonDisabled() -> Bool {
        return id.isEmpty || origin.isEmpty || destination.isEmpty
    }
}
