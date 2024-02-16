import Vapor
// No necesitas importar el módulo 'Controllers' si 'VehiculoController.swift' está en la misma carpeta

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }


    // Ahora puedes registrar directamente VehiculoController sin importar Controllers
    try app.register(collection: ControladorVehiculos())
}
