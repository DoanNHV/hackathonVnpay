//
//  ImageViewSmallCollectionViewCell.swift
//  HackathonVnpay
//
//  Created by Cao Tú Ân on 10/14/23.
//

import UIKit

class ImageViewSmallCollectionViewCell: UICollectionViewCell {
    
    static let indentifier = "ImageViewSmallCollectionViewCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var selectedView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedView.isHidden = true
        contentBgView.clipsToBounds = true
        contentBgView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        selectedView.clipsToBounds = true
        selectedView.layer.cornerRadius = 8
        selectedView.layer.borderColor = UIColor.white.cgColor
        selectedView.layer.borderWidth = 2
    }
    
    func bindingImage(_ image: UIImage){
        imageView.image = image
    }

}
