import UIKit
import RxSwift

class testTableViewCell: UITableViewCell {

    @IBOutlet var catImage: UIImageView!
    @IBOutlet var catName: UILabel!
    @IBOutlet var coverView: UIView!
    @IBOutlet var likeButton: UIButton!
    
    let tapper = UITapGestureRecognizer()
    
    var disposeBag = DisposeBag()
    
    var isLiked: (state: Bool, animate: Bool) = (state: false, animate: false) {
        didSet {
            if isLiked.state {
                UIView.animate(withDuration: isLiked.animate ? 0.2 : 0.0,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: {
                    self.likeButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
                }, completion: { isFinished in
                    if isFinished {
                        self.likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                        self.likeButton.tintColor = UIColor.init(red: 0.9, green: 0.3, blue: 0.6, alpha: 1.0)
                        UIView.animate(withDuration: self.isLiked.animate ? 0.5 : 0.0,
                                       delay: 0,
                                       usingSpringWithDamping: 0.8,
                                       initialSpringVelocity: 0.2,
                                       options: .curveEaseIn,
                                       animations: {
                                 self.likeButton.transform = .identity
                        }, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: isLiked.animate ? 0.2 : 0.0,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: {
                                self.likeButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
                }, completion: { isFinished in
                    if isFinished {
                        self.likeButton.setImage(#imageLiteral(resourceName: "unlike"), for: .normal)
                        self.likeButton.tintColor = .white
                        UIView.animate(withDuration: self.isLiked.animate ? 0.5 : 0.0,
                                       delay: 0,
                                       usingSpringWithDamping: 0.8,
                                       initialSpringVelocity: 0.2,
                                       options: .curveEaseIn,
                                       animations: {
                                        self.likeButton.transform = .identity
                        }, completion: nil)
                    }
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverView.backgroundColor = UIColor.clear
        catName.alpha = 0
        likeButton.alpha = 0
        self.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.87, alpha: 1)
        
        self.coverView.addGestureRecognizer(tapper)
    }
    
    func setTableCell(cat: Cat) {
        self.catName.text = cat.catName
        self.catImage.image = cat.catImage
        self.isLiked = (state: cat.isLike, animate: false)
    }
    
    override func draw(_ rect: CGRect) {
        coverView.backgroundColor = UIColor.clear
        catName.alpha = 0
        likeButton.alpha = 0
        self.fadeIn()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
        self.draw(.zero)
    }
    
    private func fadeIn() {
        likeButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options: .curveEaseIn,
                       animations: {
            self.coverView.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.5,
                       options: .curveEaseIn,
                       animations: {
            self.catName.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.7,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 2.0,
                       options: .curveEaseIn,
                       animations: {
                        self.likeButton.alpha = 1.0
                        self.likeButton.transform = .identity
        }, completion: nil)
    }
}

extension testTableViewCell: CatFeedSizing {
    static func height(with cat: Cat, width: CGFloat) -> CGFloat {
        return 250
    }
}
