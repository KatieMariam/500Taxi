import Foundation
import AVFoundation
import UIKit
class CBackSMS: UIViewController, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, AVAudioPlayerDelegate {
    var myPlayer = AVPlayer()
    var myMusica = AVAudioPlayer()
    var myAudioPlayer = AVAudioPlayer()
    var playSession = AVAudioSession()
    var vozConductor = AVAudioPlayer()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let myFilePathString = Bundle.main.path(forResource: "beep", ofType: "wav")
        if let myFilePathString = myFilePathString
        {
            let myFilePathURL = URL(fileURLWithPath: myFilePathString)
            do{
                try myMusica = AVAudioPlayer(contentsOf: myFilePathURL)
                myMusica.prepareToPlay()
                myMusica.volume = 1
            }catch
            {
                print("error")
            }
        }
        do{
            let session = AVAudioSession.sharedInstance()
            if #available(iOS 10.0, *) {
                try session.setCategory(.playAndRecord, mode: .default)
            } else {
                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playback.rawValue, with:  [])
            }
            try session.setActive(true)
        }catch{
            print("Problem")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func PlayForInternet(_ url: String){
        let url = url
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        myPlayer = AVPlayer(playerItem:playerItem)
        myPlayer.rate = 1.0
        myPlayer.play()
    }
    func ReproducirVozConductor(_ url: String){
        do {
            let fileURL = NSURL(string:url)
            let soundData = NSData(contentsOf:fileURL as! URL)
            try vozConductor = AVAudioPlayer(data: soundData as! Data)
            vozConductor.prepareToPlay()
            vozConductor.delegate = self
            vozConductor.volume = 1.0
            vozConductor.play()
        } catch {
            print("Nada de audio")
        }
    }
    func ReproducirMusica(){
        myMusica.play()
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.vozConductor.stop()
        self.ReproducirMusica()
    }
}
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}
