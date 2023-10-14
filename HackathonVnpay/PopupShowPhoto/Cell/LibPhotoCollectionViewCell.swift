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
    @IBOutlet weak var viewNumber: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clickImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewNumber.layer.cornerRadius = 10
    }
    
    func setImage(image: UIImage, isCheck: Bool, count: Int) {
        imageView.image = image
        if isCheck {
            countLabel.text = String(count)
            viewNumber.isHidden = false
            clickImageView.image = UIImage(named: "ic_qr_check")
        } else {
            clickImageView.image = UIImage(named: "ic_qr_uncheck")
            viewNumber.isHidden = true
        }
    }

}
