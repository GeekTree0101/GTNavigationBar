
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CatViewController: UIViewController {

    @IBOutlet var catName: UILabel!
    @IBOutlet var catImage: UIImageView!
    let cat: Cat
    
    @IBOutlet var dot3: UIView!
    @IBOutlet var dot2: UIView!
    @IBOutlet var dot1: UIView!
    let disposeBag = DisposeBag()
    let tapper = UITapGestureRecognizer()
        
    required init(cat: Cat) {
        self.cat = cat
        super.init(nibName: "CatViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.87, alpha: 1)
        self.catName.text = cat.catName
        self.catImage.image = cat.catImage
        self.catImage.layer.cornerRadius = 120.0
        self.catImage.transform = CGAffineTransform.init(translationX: 1, y: 2)
        self.catImage.alpha = 0
        self.catName.snp.remakeConstraints({ make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(30)
        })
        
        dot1.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        dot2.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        dot3.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        self.dot1.layer.cornerRadius = 40.0
        self.dot2.layer.cornerRadius = 40.0
        self.dot3.layer.cornerRadius = 40.0
        
        self.catImage.addGestureRecognizer(tapper)
        
        tapper.rx.event.subscribe(onNext: { _ in
            let vc = ViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.catImage.transform = .identity
            self.catName.center.y = self.view.center.y + self.catImage.frame.height / 2 + 30
            self.catImage.alpha = 1
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseIn, animations: {
            self.dot1.transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseIn, animations: {
            self.dot2.transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.7, options: .curveEaseIn, animations: {
            self.dot3.transform = .identity
        }, completion: nil)
        
        
        let titleView = UIView.init(frame: CGRect.init(x: 0,
                                                       y: 0,
                                                       width: UIScreen.main.bounds.width,
                                                       height: (self.navigationController?.navigationBar.frame.height)!))
        
        let label = UILabel.init(frame: titleView.frame)
        label.attributedText = boldAttributeString(cat.catName)
        
        titleView.addSubview(label)
        
        label.snp.makeConstraints({ make in
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(-19 + 10)
        })
        
        self.navigationItem.titleView = titleView
        
        let image1 = #imageLiteral(resourceName: "101-cloud").scaleImageToSize()
        let image2 = #imageLiteral(resourceName: "101-compass").scaleImageToSize()
        
        let customButton = UIButton.init(type: .system)
        customButton.setImage(image1, for: .normal)
        customButton.contentEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
        customButton.sizeToFit()
        
        let rightButton = UIBarButtonItem.init(customView: customButton)
        
        
        let customButton2 = UIButton.init(type: .system)
        customButton2.setImage(image2, for: .normal)
        customButton2.contentEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
        customButton2.sizeToFit()
        
        let rightButton2 = UIBarButtonItem.init(customView: customButton2)
        
        
        let fixed = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = -8
        
        
        self.navigationItem.setRightBarButtonItems([
            fixed,
            rightButton,
            rightButton2], animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func boldAttributeString(_ name: String) -> NSAttributedString {
        return NSAttributedString.init(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
                                                                  NSForegroundColorAttributeName: UIColor.black])
        
    }

}
