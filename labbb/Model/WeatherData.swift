import Foundation

struct WeatherData: Codable {
    let approvedTime: String
    let timeSeries: [TimeSeries]
}

struct TimeSeries: Codable {
    let validTime: String
    let parameters: [Parameters]
}

struct Parameters: Codable {
    let name: String
    let levelType: String
    let level: Int
    let unit: String
    let values: [Double]
}
