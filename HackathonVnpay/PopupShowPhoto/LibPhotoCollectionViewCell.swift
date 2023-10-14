//
//  LibPhotoCollectionViewCell.swift
//  CoopBank
//
//  Created by pc on 08/08/2023.
//  Copyright © 2023 VNPAY. All rights reserved.
//

import UIKit
import Photos

class LibPhotoCollectionViewCell: UICollectionViewCell {
    var representedAssetIdentifier: String!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clickImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImage(image: UIImage, isCheck: Bool) {
        imageView.image = image
        if isCheck {
            clickImageView.image = UIImage(named: "ic_qr_check")
        } else {
            clickImageView.image = UIImage(named: "ic_qr_uncheck")
        }
    }

}
