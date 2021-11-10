import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(longitude: Double, latitude: Double) -> Void {
        let urlString = "\(weatherURL)lon/\(longitude)/lat/\(latitude)/data.json"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) -> Void {
        // 1. Create a URL
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                
                // 2. Create a URL Session
                let session = URLSession(configuration: .default)
                
                // 3. Give the session a task
                let task = session.dataTask(with: url) { data, response, error in
                    if error != nil {
                        delegate?.didFailWithError(error: error!)
                        return
                    }
            
                    if let safeData = data {
                        if let weather = parseJSON(safeData) {
                            for item in weather.timeSeries {
                                print(item)
                            }
                            delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
                // 4. Start the task
                task.resume()
            }
        }
    }
    
    // 14.333 60.383
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        var weather = WeatherModel(approvedTime: "", timeSeries: [], parameters: [])
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let approvedTime = decodedData.approvedTime
            
            print("count: \(decodedData.timeSeries.count)")
            
            for item in decodedData.timeSeries {
                weather = WeatherModel(approvedTime: approvedTime, timeSeries: decodedData.timeSeries, parameters: item.parameters)
            }
            return weather
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

