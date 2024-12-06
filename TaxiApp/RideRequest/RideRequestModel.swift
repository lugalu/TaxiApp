//Created by Lugalu on 06/12/24.

import SwiftUI

class RideRequestModel: ObservableObject {
    var serviceLocator: ServiceLocator
    @Published var shouldShowError: Bool = false
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
    
    
    init(locator: ServiceLocator) {
        self.serviceLocator = locator
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
                throw NetworkErrors.malformedURL
                let downloadService = serviceLocator.getNetworkInterface()
                
                guard let (data, response) = try await downloadService?.downloadData(
                    for: .rideEstimate(id: id, start: origin, end: destination)
                ), let responseStatus = (response as? HTTPURLResponse)?.statusCode
                else {
                    await setErrorMessage("Um erro desconhecido aconteceu!")
                    return
                }
                
                guard responseStatus == 200 else {
                    let error = try DecoderService().decode(data, class: ErrorResponseJSON.self)
                    await setErrorMessage(error.error_description)
                    return
                    
                }
                
                let decoderService = serviceLocator.getDecoderInterface()
                guard let result =  try decoderService?.decode(data, class: RideJSON.self) else {
                    await setErrorMessage("Um erro ocorreu! Por favor cheque se existe alguma atualização na loja e tente novamente")
                    return
                }
                
                print(result)
                // Aqui a gente termina isso
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
    func isSubmitButtonDisabled() -> Bool {
        return id.isEmpty || origin.isEmpty || destination.isEmpty
    }

    @MainActor
    private func setErrorMessage(_ message: String) {
        errorMessage = message
    }
    
}
