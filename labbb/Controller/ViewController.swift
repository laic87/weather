import UIKit
import Network

class ViewController: UIViewController {
    
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var approveLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loaded = PersistenceManager.shared.load() {
            notes = loaded
        }
        
        monitorNetwork(approveLabel)
        weatherManager.delegate = self
    }
    
    @IBAction func coordinatesPressed(_ sender: UIButton) {
        
        if let doubleLon = Double(longitude.text!), let doubleLat = Double(latitude.text!) {
            print("long: \(doubleLon)")
            print("lat: \(doubleLat)")
            weatherManager.fetchWeather(longitude: doubleLon, latitude: doubleLat)
        } else {
            approveLabel.text = "Please insert Decimal types"
        }
        /*
        if let long = longitude.text, let lat = latitude.text {
            weatherManager.fetchWeather(longitude: Double(long)!, latitude: Double(lat)!)
        }
         */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func monitorNetwork(_ label: UILabel) -> Void {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected")
                DispatchQueue.main.async {
                    label.text = "Approved Time: "
                    self.view.backgroundColor = .green
                }
            } else {
                print("Disconnected")
                PersistenceManager.shared.save()
                DispatchQueue.main.async {
                    label.textColor = .red
                    label.text = "data out of date"
                    self.view.backgroundColor = .red
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
}

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.approveLabel.text = "Approved Time: \(weather.approvedTime)"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension ViewController: UITextFieldDelegate {
    // kolla mina inputs så jag ej skickar sträng eller tomma inputs
}



