//Created by Lugalu on 08/12/24.

import MapKit


protocol MapInterface {
    func getDirections(_ origin: CLLocation, _ destination: CLLocation) -> MKDirections
    func makeRoute(directions: MKDirections) async throws -> MKRoute
}


enum MapErrors: LocalizedError {
    case noAvaiableRoutes
    
    var errorDescription: String? {
        return switch self {
        case .noAvaiableRoutes:
            "Infelizmente Ocorreu um erro buscando a rota do seu mapa, por favor tente novamente mais tarde ou peça a corrida novamente."
        
        }
    }
}


class MapService: MapInterface {

    func getDirections(_ origin: CLLocation, _ destination: CLLocation) -> MKDirections {
        let request = MKDirections.Request()
        request.source = generateMapItem(for: origin)
        request.destination = generateMapItem(for: destination)
        let directions = MKDirections(request: request)
        return directions
    }
    
    func generateMapItem(for location: CLLocation) -> MKMapItem {
        let placemark = generatePlacemarkFor(location)
        return  MKMapItem(placemark: placemark)
    }
    
    func generatePlacemarkFor(_ location: CLLocation) -> MKPlacemark {
        return MKPlacemark(coordinate: location.coordinate)
    }
    
    func makeRoute(directions: MKDirections) async throws -> MKRoute {
        let response = try await directions.calculate()
        guard response.routes.count > 0,
              let route = response.routes.first
        else {
            throw MapErrors.noAvaiableRoutes
        }
        return route
    }
}
