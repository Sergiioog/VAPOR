import Fluent
import Vapor

struct ControladorVehiculos: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let rutaVehiculos = routes.grouped("api", "vehiculos")

        rutaVehiculos.get("getVehiculos", use: getVehiculos)
        rutaVehiculos.post("postVehiculos", use: postVehiculos)
        rutaVehiculos.put("putVehiculo", ":vehiculoID", use: putVehiculo)
        rutaVehiculos.delete("deleteVehiculo",":vehiculoID", use: deleteVehiculo)

        //-------------------------------------------------------------------------
        rutaVehiculos.get("getIDVehiculo", ":id", use: getIDVehiculo)
        rutaVehiculos.get("getMarcaVehiculo" , ":marca", use: getMarcaVehiculo)
        rutaVehiculos.get("getModeloVehiculo" , ":modelo", use: getModeloVehiculo)
        rutaVehiculos.get("getNumeroRuedas" , ":num_ruedas", use: getNumeroRuedas)
        rutaVehiculos.get("getTipoCombustible" , ":tipo_combustible", use: getTipoCombustible)
        rutaVehiculos.get("getPantallaCentral" , ":pantalla_central", use: getPantallaCentral)
        rutaVehiculos.get("getTamanoPantalla" , ":tamaño_pantalla", use: getTamanoPantalla)

        rutaVehiculos.get("getVehiculosPantalla", use: getVehiculosPantallaHandler)    }
    

    func getVehiculosPantallaHandler(req: Request) throws -> EventLoopFuture<View> {
    return Vehiculos.query(on: req.db).all().flatMap { coches in
        let cochesContext = coches.map { coche in
            return [
                "marca": coche.marca,
                "modelo": coche.modelo,
                "num_ruedas": coche.num_ruedas
                // Agrega más campos según sea necesario
            ]
        }
        let context: [String: Encodable] = [
            "title": "Lista de Vehículos",
            "coches": cochesContext
        ]
        return req.view.render("index", context)
    }
}


    func getVehiculos(req: Request) async throws -> [Vehiculos] { //Obtienes todos los vehiculos de la db
        let coches = try await Vehiculos.query(on: req.db).all()
        return coches
    }

    func postVehiculos(req: Request) async throws -> Vehiculos { //añade un nuevo vehículo
        let coche = try req.content.decode(Vehiculos.self)
        try await coche.save(on: req.db)
        return coche
    }

    func deleteVehiculo(req: Request) async throws -> HTTPStatus { //Elimina el vehiculo en concreto
        guard let vehiculoID = req.parameters.get("vehiculoID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        guard let cocheEliminar = try await Vehiculos.find(vehiculoID, on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await cocheEliminar.delete(on: req.db)
        return .noContent
    }

    func putVehiculo(req: Request) async throws -> [Vehiculos] { //Modifica un vehiculo en croncreto
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

    //--------------------------------------------------------------------
    func getIDVehiculo(req: Request) async throws -> Vehiculos { //coge el id del vehiculo
        guard let id = req.parameters.get("id", as: UUID.self),
              let vehiculoID = try await Vehiculos.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "No se ha encontrado dicho ID")
        }
        return vehiculoID
    }

    func getMarcaVehiculo(req: Request) async throws -> [Vehiculos] { //Coger la marca del vehiculo
        guard let marca = req.parameters.get("marca") else {
            throw Abort(.badRequest, reason: "Se necesita especificar marca")
        }

        let vehiculosMarca = try await Vehiculos.query(on: req.db)
                                                .filter(\.$marca == marca)
                                                .all()
        return vehiculosMarca
    }

    func getModeloVehiculo(req:Request) async throws -> [Vehiculos] { //Coge el modelo del coche
        guard let modelo = req.parameters.get("modelo") else {
            throw Abort(.badRequest, reason: "No existe dicho modelo")
        }
        let vehiculosModelo = try await Vehiculos.query(on:req.db)
                                                 .filter(\.$modelo == modelo)
                                                 .all()
        return vehiculosModelo
    }

    //num_ruedas
    func getNumeroRuedas (req:Request) async throws -> [Vehiculos] {
        guard let num_ruedas = req.parameters.get("num_ruedas"), 

            let intRuedas = Int(num_ruedas) else {
                throw Abort(.badRequest, reason: "Tienes que meter el numero de ruedas como un entero")
            }

        
        let vehiculosRuedas = try await Vehiculos.query(on:req.db).filter(\.$num_ruedas == intRuedas).all()
        return vehiculosRuedas;
    }

    func getTipoCombustible (req:Request) async throws -> [Vehiculos] {
        guard let tipo_combustible = req.parameters.get("tipo_combustible") else {
            throw Abort(.notFound);
        }
        let vehiculoCombustible = try await Vehiculos.query(on:req.db)
                                                      .filter(\.$tipo_combustible == tipo_combustible)
                                                      .all()
        return vehiculoCombustible;
    }

    func getPantallaCentral (req:Request) async throws -> [Vehiculos] {
        guard let pantalla_central = req.parameters.get("pantalla_central"),

            let pantallaBoolean = Bool(pantalla_central) else {
                throw Abort(.notFound);
            }
            
        let pantallaCoche = try await Vehiculos.query(on:req.db)
                                                .filter(\.$pantalla_central == pantallaBoolean)
                                                .all()
        return pantallaCoche;
    }

    //REVISAR
  func getTamanoPantalla (req:Request) async throws -> [Vehiculos] {
        guard let tamaño_pantalla = req.parameters.get("tamaño_pantalla"), 

            let intPantalla = Int(tamaño_pantalla) else {
                throw Abort(.badRequest, reason: "Tienes que meter el numero de ruedas como un entero")
            }

        
        let vehiculoPantalla = try await Vehiculos.query(on:req.db)
                                            .filter(\.$tamaño_pantalla == intPantalla)
                                            .all()

        return vehiculoPantalla;
    }
   
    //tamaño_pantalla





}
