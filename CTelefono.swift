import Foundation
class CTelefono{
    var numero: String
    var operadora: String
    var esmovil: String
    var tienewhatsapp: String
    init(numero: String,operadora: String,esmovil: String,tienewhatsapp: String){
        self.numero = numero
        self.operadora = operadora
        self.esmovil = esmovil
        self.tienewhatsapp = tienewhatsapp
    }
}