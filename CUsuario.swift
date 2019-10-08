import Foundation
class CUsuario{
    var idusuario :String
    init(idusuario :String){
        self.idusuario = idusuario
    }
    func GetIdusuario()-> String{
     return idusuario
    }
    func SetIdusuario(newusuario :String){
        idusuario = newusuario
    }
    func Autenticacion(){
    }
}