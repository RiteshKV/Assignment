import Foundation

struct RequestURL {
    
    static let baseURL = "https://jsonplaceholder.typicode.com/"
    
    static func postURL(url: String) -> String {
        return baseURL + url
    }
}
