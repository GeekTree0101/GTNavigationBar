import UIKit
import Foundation
import RxSwift

protocol AutoHideNavigationBar {
    func setAutoHide() -> UIScrollView!
}

extension UINavigationController {
    
    static func setAppearence() {
        UINavigationBar.appearance().tintColor = .black
        
        let image = #imageLiteral(resourceName: "101-back").scaleImageToSize().withAlignmentRectInsets(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0.0, -1000.0), for: .default)
        
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
    }
    
    func setAutoHideNavigationBar(_ scrollView: UIScrollView) {
      
        let userInteraction = scrollView.panGestureRecognizer
        var prevValue: CGFloat?
        
        _ = userInteraction.rx.event
            .takeUntil(scrollView.rx.deallocated)
            .subscribe(onNext: { context in
                let dy = context.location(in: self.view).y
                switch context.state {
                case .began:
                    prevValue = dy
                    break
                case .changed:
                    guard let prev = prevValue else { return }
                    
                    let limitCheck = self.navigationBar.frame.origin.y
                    if dy > prev && limitCheck < 24 {
                        self.navigationBar.frame.origin.y += 1
                    } else if dy < prev && limitCheck > -64 {
                        self.navigationBar.frame.origin.y -= 1
                    } else { return }
                    print(self.navigationBar.frame.origin.y )
                    prevValue = dy
                    
                    break
                case .ended:
                    prevValue = nil
                    let isScrollDown = context.translation(in: scrollView).y > 0
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.navigationBar.frame.origin.y = isScrollDown ? 24 : -64
                    })
                    
                    break
                default: break
                }
                
                
            })
        
    }
}

extension UIImage {
    
    func scaleImageToSize(size: CGSize = CGSize.init(width: 24, height: 24)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        return image
    }
}
