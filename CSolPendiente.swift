import Foundation
class CSolPendiente {
    var idSolicitud : String
    var idTaxi : String
    var codigo : String
    var FechaHora : String
    var Latitudtaxi : String
    var Longitudtaxi : String
    var Latitudorigen : String
    var Longitudorigen : String
    var Latituddestino : String
    var Longituddestino : String
    var tarifa : Double
    var distancia : Double
    var tiempo : String
    var Costo : String
    init(idSolicitud : String, idTaxi : String, codigo : String, FechaHora : String, Latitudtaxi : String, Longitudtaxi : String, Latitudorigen : String, Longitudorigen : String, Latituddestino : String, Longituddestino : String){
        self.idSolicitud = idSolicitud
        self.idTaxi = idTaxi
        self.codigo = codigo
        self.FechaHora = FechaHora        
        self.Latitudtaxi = Latitudtaxi
        self.Longitudtaxi = Longitudtaxi
        self.Latitudorigen = Latitudorigen
        self.Longitudorigen = Longitudorigen
        self.Latituddestino = Latituddestino
        self.Longituddestino = Longituddestino
        self.tarifa = 0.0
        self.distancia = 2.0
        self.tiempo = "0"
        self.Costo = ""
    }
    func AgregarDistanciaTiempo(datos: [String]){
        self.distancia = Double(datos[0])!
        self.tiempo = datos[1]
    }
    func FijarTarifa(tarifario : [CTarifa]){
        let origenCoord = Latitudorigen + "," + Longitudorigen
        let destinoCoord = Latituddestino + "," + Longituddestino
        let ruta = CRuta(origin: origenCoord, destination: destinoCoord)
        let distanciatemp = ruta.totalDistance
        var temporal = String(FechaHora).componentsSeparatedByString(" ")
        temporal = String(temporal[1]).componentsSeparatedByString(":")
        for var tarifatemporal in tarifario{
            if (Int(tarifatemporal.horaInicio) <= Int(temporal[0])) && (Int(temporal[0]) <= Int(tarifatemporal.horaFin)){
                self.tarifa = Double(tarifatemporal.valorKilometro)
            }
            if Double(distanciatemp) >= 1{
                self.Costo = String(Double(distanciatemp)! * self.tarifa)
            }
            else{
                self.Costo = String(tarifatemporal.valorMinimo)
            }
        }
        self.distancia = Double(distanciatemp)!
        self.tiempo = ruta.totalDuration
    }
    func CalcularCosto()->String{
        self.Costo = String(distancia * self.tarifa)
        return self.Costo
    }
}