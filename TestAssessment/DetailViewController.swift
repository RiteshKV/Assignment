import UIKit

class DetailViewController: UIViewController {
    var post: PostModelElement?
    
    @IBOutlet weak var lblId: UILabel!{
        didSet {
            lblId.numberOfLines = 0
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet {
            lblTitle.numberOfLines = 0
        }
    }
    @IBOutlet weak var lblBody: UILabel!{
        didSet {
            lblBody.numberOfLines = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display the post details
        if let post = post {
            lblId.text = "ID: \(post.id)"
            lblTitle.text = "Title: \(post.title)"
            lblBody.text = "Body: \(post.body)"
        }
    }
}

