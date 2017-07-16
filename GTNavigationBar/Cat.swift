import Foundation
import UIKit

struct Cat {
    
    var catName: String
    var catImage: UIImage
    var isLike: Bool = false
    
    init(name: String, img: UIImage, isLike: Bool) {
        self.catName = name
        self.catImage = img
        self.isLike = isLike
    }
}
