//Created by Lugalu on 09/12/24.

import SwiftUI

class RideListingModel: ObservableObject {
    let locator: ServiceLocator
    
    @Published var id = ""
    @Published var selectedDriverId = 0
    var drivers: [(Int, String)] = [
        (0, ""),
        (1, "Homer"),
        (2, "Dominic"),
        (3, "James"),
        (4, "Mostrar todos")
    ]
    
    @Published var isLoading = false
    @Published var shouldDisplayError = false
    @Published var errorMessage = "" {
        didSet {
            guard !errorMessage.isEmpty else { return }
            shouldDisplayError = true
        }
    }
    
    @Published var history: [HistoryData] = []
    
    init(locator: ServiceLocator) {
        self.locator = locator
    }
    
    func isButtonDisabled() -> Bool {
        return id.isEmpty || selectedDriverId == 0
    }
    
    func fetchHistory() {
        Task {
            do{
                setIsLoading(true)
                defer {
                    setIsLoading(false)
                }
                
                let data = try await selectedDriverId == 4 ? fetchAll() : fetchSingle(driverId: selectedDriverId)
                await setHistory(newValues: data)
            } catch NetworkErrors.emptyResponse {
                await setErrorMessage(NetworkErrors.emptyResponse.localizedDescription)
            } catch {
                await setErrorMessage("Um erro aconteceu")
            }
        }
    }
    
    
    private func fetchSingle(driverId: Int) async throws -> [HistoryData] {
        let downloadService = locator.getNetworkInterface()
        let decoderService = locator.getDecoderInterface()
        let data = try await downloadService.downloadAndCheck(for: .list(id: id, driverID: driverId), decoderService: decoderService) { errorDescription in
            await setErrorMessage(errorDescription)
        }
        
        guard let data else { return [] }
        
        let json = try decoderService.decode(data, class: HistoryEntryJSON.self)
        let result = try HistoryJSONtoHistoryData.map(json)
        
        guard !result.isEmpty else {
            throw NetworkErrors.emptyResponse
        }
        
        return result
    }
    
    private func fetchAll() async throws -> [HistoryData] {
        async let driverOne = fetchSingle(driverId: 1)
        async let driverTwo = fetchSingle(driverId: 2)
        async let driverThree = fetchSingle(driverId: 3)
        
        let (arrayOne, arrayTwo, arrayThree) = (try? await (driverOne, driverTwo, driverThree)) ?? (nil,nil,nil)
        
        let result = (arrayOne ?? []) + (arrayTwo ?? []) + (arrayThree ?? [])
        
        guard !result.isEmpty else {
            throw NetworkErrors.emptyResponse
        }
        
        return result
    }
    
    private func setIsLoading(_ value: Bool) {
        Task{ @MainActor in
            self.isLoading = value
        }
    }
    
    @MainActor
    private func setHistory(newValues: [HistoryData]) {
        history = newValues
    }
    
    @MainActor
    private func setErrorMessage(_ message: String){
        self.errorMessage = message
    }
    
    func formatMoney(_ value: Double) -> String {
        let asNumber = NSNumber(floatLiteral: value)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: asNumber) ?? ("R$" + String(value))
    }
    
}





