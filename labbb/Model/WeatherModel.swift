import Foundation

struct WeatherModel {
    let approvedTime: String
    let timeSeries: [TimeSeries]
    let parameters: [Parameters]
    
    init(approvedTime: String, timeSeries: [TimeSeries], parameters: [Parameters]) {
        self.approvedTime = approvedTime
        self.timeSeries = timeSeries
        self.parameters = parameters
    }
    
    // göra om date och time format
    /*
    var approvedTimeString: String {
        return String(format: ".%1f", approvedTime)
    }
    */

}



