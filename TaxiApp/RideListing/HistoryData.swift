//Created by Lugalu on 10/12/24.

import Foundation

struct HistoryData: Identifiable {
    let id = UUID()
    let date: Date
    let origin: String
    let destination: String
    let distance: Double
    let duration: String
    let driverName: String
    let value: Double
}
