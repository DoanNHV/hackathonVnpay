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
  
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(sender:)))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
        if scrollView.zoomScale < scrollView.maximumZoomScale {
            let location = sender.location(in: sender.view)
            let rectToZoomTo = CGRect(x: location.x, y: location.y, width: 1, height: 1)
       //     scrollView.zoom(to: rectToZoomTo, animated: true)
            let currentZoomScale = scrollView.zoomScale

            let zoomRect = zoomRectForScale(currentZoomScale * 2, center: location)

            scrollView.zoom(to: zoomRect, animated: true)


        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.size.width = scrollView.frame.size.width / scale
        let newCenter = scrollView.convert(center, to: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale == 1.0 {
            onChangeState?(false)
        } else {
            onChangeState?(true)
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
          return imageView
      }
    
    func bindingImage(_ image: UIImage){
        imageView.image = image
    }
}
