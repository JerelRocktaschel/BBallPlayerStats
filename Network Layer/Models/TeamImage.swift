//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

struct TeamImage {
    let image: UIImage
    let abbreviation: String
    
    //MARK: Init
    
    init(with image: UIImage, and abbreviation: String) {
        self.image = image
        self.abbreviation = abbreviation
    }
}
