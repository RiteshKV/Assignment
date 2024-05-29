import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBg: UIView!{
        didSet{
            self.viewBg.layer.cornerRadius = 5
            self.viewBg.layer.masksToBounds = true
        }
    }
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
