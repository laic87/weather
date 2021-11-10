import Foundation

struct Note: Codable {
    let title: String
    let text: String
}

class PersistenceManager {
    static let shared = PersistenceManager()
    
    let note1 = Note(title: "Daniel", text: "Laic")
    let note2 = Note(title: "LOI", text: "kalas")
    let note3 = Note(title: "hej", text: "då")
    
    private init() { }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        let documentsDirectory = paths[0]
        //print(documentsDirectory)
        return documentsDirectory
    }
    
    func save() -> Void {
        let notes = [note1, note2, note3]
        let path = documentsDirectory().appendingPathComponent("weather.plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedWeather = try? propertyListEncoder.encode(notes)
        try? encodedWeather?.write(to: path, options: .noFileProtection)
    }
    
    func load() -> [Note]? {
        let path = documentsDirectory().appendingPathComponent("weather.plist")
        let plistDecoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: path) {
            let decoded = try! plistDecoder.decode(Array<Note>.self, from: data)
            return decoded
        }
        return nil
    }
}
