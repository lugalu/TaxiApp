//Created by Lugalu on 06/12/24.


struct RideJSON: Decodable {
    let origin: CoordinateJSON
    let destination: CoordinateJSON
    let distance: Double
    let duration: Int
    let options: [DriverJSON]
    
    struct CoordinateJSON: Decodable {
        let latitude: Double
        let longitude: Double
    }
    
    struct DriverJSON: Decodable {
        let id: Int
        let name: String
        let description: String
        let vehicle: String
        let review: ReviewJSON
        let value: Double
        
        struct ReviewJSON: Decodable {
            let rating: Double
            let comment: String
        }
    }
    
    
}
