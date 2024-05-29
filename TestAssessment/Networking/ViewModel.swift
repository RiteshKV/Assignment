import Foundation
import Combine

class ViewModel: ObservableObject {
    @Published var posts: PostModel = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private let postsPerPage = 10
    
    private var computationCache: [Int: PostModelElement] = [:]
    
    func fetchPosts(page: Int, limit: Int) {
        guard !isLoading else { return }
        
        isLoading = true
        let url = "posts?_page=\(page)&_limit=\(limit)"
        ResourceBuilder.getPostAPIResource(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }, receiveValue: { [weak self] newPosts in
                self?.posts.append(contentsOf: newPosts)
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func loadMorePosts() {
        currentPage += 1
        fetchPosts(page: currentPage, limit: postsPerPage)
    }
    
    func performHeavyComputation(for post: PostModelElement, completion: @escaping (PostModelElement) -> Void) {
        
        if let cachedResult = computationCache[post.id] {
            completion(cachedResult)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let startTime = CFAbsoluteTimeGetCurrent()
            
            // Simulate heavy computation
            var postCopy = post
            postCopy.body += " - Computed details"
            
            let endTime = CFAbsoluteTimeGetCurrent()
            let timeElapsed = endTime - startTime
            print("Heavy computation for post \(post.id) took \(timeElapsed) seconds")
            
            DispatchQueue.main.async {
                self.computationCache[post.id] = postCopy
                completion(postCopy)
            }
        }
    }
}

