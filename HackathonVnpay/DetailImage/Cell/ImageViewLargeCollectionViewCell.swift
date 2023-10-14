//
//  ImageViewLargeCollectionViewCell.swift
//  HackathonVnpay
//
//  Created by Cao Tú Ân on 10/14/23.
//

import UIKit

class ImageViewLargeCollectionViewCell: UICollectionViewCell,UIScrollViewDelegate {
    static let indentifier = "ImageViewLargeCollectionViewCell"
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var onOpen: (()-> Void)?
    var onChangeState: ((Bool)-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.zoomScale = 1.0
  
 // let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
 // imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImage)))
        // Initialization code
    }
    @objc func openImage(){
       onOpen?()
    }
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//           if scale > 1.0 {
//               onChangeState?(true)
//               // ScrollView đang trong trạng thái zoom
//           } else {
//               onChangeState?(false)
//               // ScrollView không đang trong trạng thái zoom
//           }
//       }
 
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale == 1.0 {
            onChangeState?(false)

            // Đang ở trạng thái không zoom
        } else {
            // Đang ở trạng thái zoom
            onChangeState?(true)

        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
          return imageView
      }
    
    func bindingImage(_ image: UIImage){
        imageView.image = image
    }

    
//    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
//        if sender.state == .changed {
//            onChangeState?(true)
//            let currentScale = imageView.frame.size.width / imageView.bounds.size.width
//            var newScale = currentScale * sender.scale
//            if newScale < scrollView.minimumZoomScale {
//                newScale = scrollView.minimumZoomScale
//            }
//            if newScale > scrollView.maximumZoomScale {
//                newScale = scrollView.maximumZoomScale
//            }
//            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
//            imageView.transform = transform
//            sender.scale = 1
//        }
//        else {
//             onChangeState?(false)
//        }
//    }
}
