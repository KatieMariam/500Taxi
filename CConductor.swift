import Foundation
class CConductor{
    var idConductor :String
    var nombreApellido :String
    var movil :String
    var urlFoto :String
    init(){
        self.idConductor = ""
        self.nombreApellido = ""
        self.movil = ""
        self.urlFoto = ""
    }
    init(IdConductor :String, Nombre :String, Telefono :String, UrlFoto :String){
        self.idConductor = IdConductor
        self.nombreApellido = Nombre
        self.movil = Telefono
        if UrlFoto != "null"{
        self.urlFoto = UrlFoto
        }
        else{
        self.urlFoto = "chofer"}
    }
}