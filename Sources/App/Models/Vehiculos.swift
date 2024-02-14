import Fluent
import Vapor

final class Vehiculos: Model, Content {

    static let schema = "vehiculos";
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "marca")
    var marca: String

    @Field(key: "modelo")
    var modelo: String

    @Field(key: "num_ruedas")
    var num_ruedas: Int

    @Field(key: "tipo_combustible")
    var tipo_combustible: String

    @Field(key: "pantalla_central")
    var pantalla_central: Bool

    @Field(key: "tamaño_pantalla")
    var tamaño_pantalla: Int

    init() { }

    init(id: UUID? = nil, marca: String, modelo: String, num_ruedas: Int, tipo_combustible: String, pantalla_central: Bool, tamaño_pantalla: Int) {
    self.id = id
    self.marca = marca
    self.modelo = modelo
    self.num_ruedas = num_ruedas
    self.tipo_combustible = tipo_combustible
    self.pantalla_central = pantalla_central
    self.tamaño_pantalla = tamaño_pantalla
}


}
