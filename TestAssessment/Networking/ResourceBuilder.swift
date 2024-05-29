import Foundation
import Combine

struct ResourceBuilder {
    
    static func getPostAPIResource(url: String) -> AnyPublisher<PostModel, Error> {
        let url = URL(string: RequestURL.postURL(url: url))!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{ $0.data}
            .decode(type: PostModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
