import Fluent
import Vapor

struct ControladorVehiculos: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let rutaVehiculos = routes.grouped("api", "vehiculos")

        rutaVehiculos.get("getVehiculos", use: getVehiculos)
        rutaVehiculos.post("postVehiculos", use: postVehiculos)
        rutaVehiculos.put("putVehiculo", use: putVehiculo)
        rutaVehiculos.delete("deleteVehiculo", use: deleteVehiculo)
    }
    

    func getVehiculos(req: Request) async throws -> [Vehiculos] {
        let coches = try await Vehiculos.query(on: req.db).all()
        return coches
    }

    func postVehiculos(req: Request) async throws -> Vehiculos {
        let coche = try req.content.decode(Vehiculos.self)
        try await coche.save(on: req.db)
        return coche
    }

    func deleteVehiculo(req: Request) async throws -> HTTPStatus {
        guard let vehiculoID = req.parameters.get("vehiculoID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        guard let cocheEliminar = try await Vehiculos.find(vehiculoID, on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await cocheEliminar.delete(on: req.db)
        return .noContent
    }

    func putVehiculo(req: Request) async throws -> [Vehiculos] {
        guard let vehiculoID = req.parameters.get("vehiculoID", as: UUID.self) else {
            throw Abort(.notFound)
        }
        guard let cocheModificar = try await Vehiculos.find(vehiculoID, on: req.db) else {
            throw Abort(.notFound)
        }
        let cocheActualizado = try req.content.decode(Vehiculos.self)

        cocheModificar.marca = cocheActualizado.marca
        cocheModificar.modelo = cocheActualizado.modelo
        cocheModificar.num_ruedas = cocheActualizado.num_ruedas
        cocheModificar.tipo_combustible = cocheActualizado.tipo_combustible
        cocheModificar.pantalla_central = cocheActualizado.pantalla_central
        cocheModificar.tamaño_pantalla = cocheActualizado.tamaño_pantalla

        try await cocheModificar.save(on: req.db)
        return [cocheModificar]
    }
}
