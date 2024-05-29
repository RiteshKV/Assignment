import UIKit
import Combine

class ViewController: UIViewController {
    
    private var viewModel = ViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var tblPosts: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblPosts.delegate = self
        tblPosts.dataSource = self
        
        tblPosts.estimatedRowHeight = 120.0
        tblPosts.rowHeight = UITableView.automaticDimension
        
        bindViewModel()
        viewModel.fetchPosts(page: 1, limit: 10)
    }

    private func bindViewModel() {
        viewModel.$posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] posts in
                self?.handlePostsUpdate(posts)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.handleError(errorMessage)
            }
            .store(in: &cancellables)
    }
        
    private func handlePostsUpdate(_ posts: PostModel) {
        print("Posts updated: \(posts.count) posts")
        tblPosts.reloadData()
    }
    
    private func handleError(_ errorMessage: String?) {
        if let errorMessage = errorMessage {
            print("Error: \(errorMessage)")
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tblPosts.indexPathForSelectedRow {
                let selectedPost = viewModel.posts[indexPath.row]
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.post = selectedPost
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.posts.count
        print("Number of rows: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblPosts.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostsTableViewCell else {
            fatalError("Unable to dequeue PostsTableViewCell")
        }
        
        let post = viewModel.posts[indexPath.row]
        cell.lblId.text = "ID : \(post.id)"
        cell.lblTitle.text = "Title : " + post.title
        cell.lblBody.text = "Body : " + post.body
        
        // Perform heavy computation
        viewModel.performHeavyComputation(for: post) { [weak self] updatedPost in
            // Update the cell after computation is done
            guard let cell = tableView.cellForRow(at: indexPath) as? PostsTableViewCell else { return }
            cell.lblBody.text = updatedPost.body
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.posts[indexPath.row]
        print("Selected post: \(post.title)")
        
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if !viewModel.isLoading {
                viewModel.loadMorePosts()
            }
        }
    }
}
