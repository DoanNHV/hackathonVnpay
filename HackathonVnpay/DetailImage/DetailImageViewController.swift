//
//  DetailImageViewController.swift
//  HackathonVnpay
//
//  Created by Cao Tú Ân on 10/14/23.
//

import UIKit

class DetailImageViewController: UIViewController {
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    var itemSelectedIndex = 0 {
        didSet {
            collectionView2.reloadData()
        }
       
    }
    private let widthImageNho : CGFloat =  80
    var listImage = [UIImage(named: "ImageTest1"),
                     UIImage(named: "ImageTest2"),
                     UIImage(named: "ImageTest3"),
                     UIImage(named: "ImageTest1"),
                     UIImage(named: "ImageTest2"),
                     UIImage(named: "ImageTest3"),
                     UIImage(named: "ImageTest1"),
                     UIImage(named: "ImageTest2"),
                     UIImage(named: "ImageTest3"),
                     UIImage(named: "ImageTest1"),
                     UIImage(named: "ImageTest2"),
                     UIImage(named: "ImageTest3"),
                     UIImage(named: "ImageTest1"),
                                      UIImage(named: "ImageTest2"),
                                      UIImage(named: "ImageTest3"),
                                      UIImage(named: "ImageTest1"),
                                      UIImage(named: "ImageTest2"),
                                      UIImage(named: "ImageTest3"),
                                      UIImage(named: "ImageTest1"),
                                      UIImage(named: "ImageTest2"),
                                      UIImage(named: "ImageTest3"),
                                      UIImage(named: "ImageTest1"),
                                      UIImage(named: "ImageTest2"),
                                      UIImage(named: "ImageTest3")]
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectViewTo()
        configCollectViewNho()
      
        
        // Do any additional setup after loading the view.
    }
    func configCollectViewNho(){
        collectionView2.register(UINib(nibName: ImageViewSmallCollectionViewCell.indentifier, bundle: .main), forCellWithReuseIdentifier: ImageViewSmallCollectionViewCell.indentifier)
        collectionView2.dataSource = self
        collectionView2.delegate = self
        if let layout = collectionView2.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
        }
    }
    
    func configCollectViewTo(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: self.view.frame.width, height: collectionView1.frame.size.height)
        collectionView1.collectionViewLayout = layout
       
        collectionView1.isPagingEnabled = true
        collectionView1.showsHorizontalScrollIndicator = false

        collectionView1.register(UINib(nibName: ImageViewLargeCollectionViewCell.indentifier, bundle: .main), forCellWithReuseIdentifier: ImageViewLargeCollectionViewCell.indentifier)
       
        collectionView1.dataSource = self
        collectionView1.delegate = self
        collectionView1.isUserInteractionEnabled =  true
        collectionView1.allowsSelection = true
    }



}
extension DetailImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewSmallCollectionViewCell.indentifier, for: indexPath) as! ImageViewSmallCollectionViewCell
             
            cell.selectedView.isHidden = !(indexPath.item == itemSelectedIndex)
   
            cell.bindingImage(listImage[indexPath.item] ?? UIImage())
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewLargeCollectionViewCell.indentifier, for: indexPath) as! ImageViewLargeCollectionViewCell
        cell.bindingImage(listImage[indexPath.item] ?? UIImage())
        cell.onChangeState = {[weak self] check in
           // UIView.animate(withDuration: 0.5) { [weak self] in
            self?.collectionView1.isScrollEnabled = !check
                self?.collectionView2.isHidden = check
            //}
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView2 == collectionView {
            collectionView1.scrollToItem(at: indexPath, at: .top, animated: true)
            itemSelectedIndex = indexPath.item
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView1 == collectionView {
            itemSelectedIndex = indexPath.row
            let visibleIndexPaths = collectionView2.indexPathsForVisibleItems
            if !visibleIndexPaths.contains(indexPath) {
                collectionView2.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView1 {
            return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: widthImageNho, height: collectionView2.frame.size.height)
        }
    }

}
