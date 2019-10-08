import Foundation
class CCliente{
    var idUsuario: String!
    var idCliente: String!
    var user : String!
    var nombreApellidos : String!
    var email: String!
    var empresa: String!
    init(){
        self.idCliente = ""
        self.user = ""
        self.nombreApellidos = ""
    }
    init(idUsuario: String, idcliente: String, user: String, nombre: String, email: String, empresa: String){
        self.idUsuario = idUsuario
        self.idCliente = idcliente
        self.user = user
        self.nombreApellidos = nombre
        self.email = email
        self.empresa = empresa
    }
    func AgregarDatosCliente(idUsuario: String,idcliente: String, user: String, nombre: String){
        self.idCliente = idcliente
        self.idUsuario = idUsuario
        self.user = user
        self.nombreApellidos = nombre
    }
}
