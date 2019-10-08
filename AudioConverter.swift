import Foundation
import UIKit
import TSVoiceConverter
let kAudioFileTypeWav = "wav"
let kAudioFileTypeAmr = "amr"
private let kAmrRecordFolder = "ChatAudioAmrRecord"   
private let kWavRecordFolder = "ChatAudioWavRecord"  
class AudioConverter {
    let amrPath = NSBundle.mainBundle().pathForResource("audio", ofType: "amr")
    let wavPath = NSBundle.mainBundle().pathForResource("audio", ofType: "wav")
    let amrTargetPath = AudioFolderManager.amrPathWithName("test_amr").path!
    let wavTargetPath = AudioFolderManager.wavPathWithName("test_wav").path!
    init(){
    }
    func ConvertAmrToWav(urlOrigenAmr: String)->String{
        if TSVoiceConverter.convertAmrToWav(urlOrigenAmr, wavSavePath: wavTargetPath) {
            return wavTargetPath
        } else {
           return "false"
        }
    }
    func convertWavToAmr(urlOrigenWav: String)->String{
        if TSVoiceConverter.convertWavToAmr(urlOrigenWav, amrSavePath: amrTargetPath) {
            return amrTargetPath
        } else {
            return "false"
        }
    }
}
class AudioFolderManager {
    class func amrPathWithName(fileName: String) -> NSURL {
        let filePath = self.amrFilesFolder.URLByAppendingPathComponent("\(fileName).\(kAudioFileTypeAmr)")
        return filePath
    }
    class func wavPathWithName(fileName: String) -> NSURL {
        let filePath = self.wavFilesFolder.URLByAppendingPathComponent("\(fileName).\(kAudioFileTypeWav)")
        return filePath
    }
    private class var amrFilesFolder: NSURL {
        get { return self.createAudioFolder(kAmrRecordFolder)}
    }
    private class var wavFilesFolder: NSURL {
        get { return self.createAudioFolder(kWavRecordFolder)}
    }
    class private func createAudioFolder(folderName :String) -> NSURL {
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
        let folder = documentsDirectory.URLByAppendingPathComponent(folderName)
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(folder.absoluteString) {
            do {
                try fileManager.createDirectoryAtPath(folder.path!, withIntermediateDirectories: true, attributes: nil)
                return folder
            } catch let error as NSError {
                print("error:\(error)")
            }
        }
        return folder
    }
}
