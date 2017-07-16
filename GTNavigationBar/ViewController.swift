import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {

    let tableView = UITableView.init(frame: .zero)
    let identifier = "testCell"
    var item: [Cat]?
    var loadingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createModel()
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "testTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.87, alpha: 1)
        self.view.addSubview(tableView)
        self.hackNavigation()
        
        tableView.snp.remakeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    func hackNavigation() {
        self.title = "Cat"
        self.navigationController?.setAutoHideNavigationBar(self.setAutoHide())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: AutoHideNavigationBar {
    func setAutoHide() -> UIScrollView! {
        return self.tableView
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let item = self.item else { return 0 }
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                         for: indexPath)
        
        guard let cell = reusableCell as? testTableViewCell,
            let item = self.item else { return reusableCell }
        
        cell.setTableCell(cat: item[indexPath.item])
        
        cell.likeButton.rx.tap.subscribe(onNext: { _ in
            let likeState = cell.isLiked.state
            cell.isLiked = (state: !likeState, animate: true)
            self.item?[indexPath.item].isLike = !likeState
        }).disposed(by: cell.disposeBag)
        
        cell.tapper.rx.event.subscribe(onNext: { _ in
            let vc = CatViewController.init(cat: item[indexPath.item])
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: cell.disposeBag)
        
        return cell
    }
}

protocol CatFeedSizing: class {
    static func height(with cat: Cat, width: CGFloat) -> CGFloat
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = self.item else { return 0 }
        return testTableViewCell.height(with: item[indexPath.item], width: tableView.frame.width)
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset > self.tableView.contentSize.height - self.tableView.frame.height {
            guard let view = self.loadingView else {
                let createView = UIView.init(frame: .zero)
                let helloCat = UIImageView.init(frame: .zero)
                helloCat.image = #imageLiteral(resourceName: "loading").withRenderingMode(.alwaysTemplate)
                helloCat.tintColor = UIColor.init(red: 0.95, green: 0.5, blue: 0.14, alpha: 1)
                createView.addSubview(helloCat)
                createView.alpha = 0.0
                helloCat.snp.makeConstraints({ make in
                    make.edges.equalToSuperview()
                })
                
                self.loadingView = createView
                self.view.addSubview(createView)
                
                createView.snp.makeConstraints({ make in
                    make.centerX.equalToSuperview()
                    make.height.width.equalTo(200)
                })
                return
            }
            
            let height = self.tableView.contentSize.height
            view.alpha = min(1, 1 - (height - offset) / 800)
            view.center = CGPoint.init(x: self.tableView.center.x, y: UIScreen.main.bounds.height + 200 - 400 * (view.alpha * 1.8))
        } else {
            guard self.loadingView != nil else { return }
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }
}


extension ViewController {
    func createModel() {
        let name = ["Tiger", "Puss", "Smokey", "Misty", "Tigger", "Kitty", "Oscar"]
        var cat = [Cat]()
        
        name.enumerated().forEach({ index, name in
            let createdCat = Cat.init(name: name,
                                      img: UIImage.init(named: "cat\(index + 1)") ?? #imageLiteral(resourceName: "cat1"),
                                      isLike: false)
            cat.append(createdCat)
        })
        
        self.item = cat
    }
}

