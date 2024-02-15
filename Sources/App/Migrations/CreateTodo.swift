import Fluent

struct CreateVehicles: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("vehiculos")
            .id()
            .field("marca", .string, .required)
            .field("modelo", .string, .required)
            .field("num_ruedas", .int, .required)
            .field("tipo_combustible", .string, .required)
            .field("pantalla_central", .bool, .required)
            .field("tamaño_pantalla", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("vehiculos").delete()
    }
}
