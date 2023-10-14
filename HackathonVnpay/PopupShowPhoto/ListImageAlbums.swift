//
//  ListImageAlbums.swift
//  CoopBank
//
//  Created by pc on 29/07/2023.
//  Copyright © 2023 VNPAY. All rights reserved.
//

import Photos
import UIKit

class ListImageAlbums: UIViewController {
    private var allPhotos = PHFetchResult<PHAsset>()
    private var assetArray: [PhotoLocal] = []
    private var listIndexPathSelected = [IndexPath]()
    private var listIndexPathReload = [IndexPath]()
    private let imageManager = PHCachingImageManager()
    private var itemCount = 0
    private var indexPathToCount: [IndexPath: Int] = [:]
    private var count = 0
    private var isSelectedAll = false {
        didSet {
            if !isSelectedAll {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "select"), style: .plain, target: self, action: #selector(didTapTrashIcon))
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(didTapUncheck))
            }
        }
    }

    @IBOutlet weak var viewButtonSend: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var assetOption: PHFetchOptions = {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.includeHiddenAssets = false
        allPhotosOptions.includeAllBurstAssets = false
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        allPhotosOptions.includeAssetSourceTypes = [.typeUserLibrary, .typeiTunesSynced]
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return allPhotosOptions
    }()

    private lazy var imageOption: PHImageRequestOptions = {
        let imageOption = PHImageRequestOptions()
        imageOption.deliveryMode = .highQualityFormat
        imageOption.resizeMode = .exact
        return imageOption
    }()

    override func viewDidLoad() {
        // setup view
        viewButtonSend.layer.cornerRadius = 30
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        flowLayout.scrollDirection = .vertical
        allPhotos = PHAsset.fetchAssets(with: assetOption)
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(LibPhotoCollectionViewCell.self)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "select"), style: .plain, target: self, action: #selector(didTapTrashIcon))

        allPhotos.enumerateObjects { [weak self] asset, _, _ in
            self?.assetArray.append(.init(phaset: asset))
        }
        collectionView.reloadData()
    }
    
    @IBAction func actionSend(_ sender: Any) {
        if !getListImageSelected().isEmpty {
            let detailController = DetailImageViewController()
            detailController.listImage = getListImageSelected()
            navigationController?.pushViewController(detailController, animated: true)
        }
    }

    func getListImageSelected() -> [PhotoLocal] {
        return assetArray.filter { $0.isSelected == true }
    }

    @objc func didTapTrashIcon() {
        isSelectedAll.toggle()
        assetArray.removeAll()
        allPhotos.enumerateObjects { [weak self] asset, _, _ in
            self?.assetArray.append(.init(phaset: asset, isSelected: true))
        }

        for i in 0 ..< assetArray.count {
            let indexPath = IndexPath(row: i, section: 0)
            indexPathToCount[indexPath] = i + 1
        }

        collectionView.reloadData()
    }

    @objc func didTapUncheck() {
        isSelectedAll.toggle()
        assetArray.removeAll()
        allPhotos.enumerateObjects { [weak self] asset, _, _ in
            self?.assetArray.append(.init(phaset: asset, isSelected: false))
        }

        collectionView.reloadData()
    }
}

extension ListImageAlbums: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(LibPhotoCollectionViewCell.self, at: indexPath)
        let asset = assetArray[indexPath.item]
        cell.representedAssetIdentifier = asset.phaset.localIdentifier
        imageManager.requestImage(for: asset.phaset, targetSize: CGSize(width: 360, height: 360), contentMode: .aspectFill, options: imageOption, resultHandler: { [weak cell] image, _ in
            if cell?.representedAssetIdentifier == asset.phaset.localIdentifier {
                cell?.setImage(image: image ?? UIImage(), isCheck: asset.isSelected, count: self.itemCount)
            }

            if let countForCell = self.indexPathToCount[indexPath] {
                cell?.setImage(image: image ?? UIImage(), isCheck: asset.isSelected, count: countForCell)
            }
        })
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetArray.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width - 16
        let widthItem = CGFloat(screenWidth) / 5
        return CGSize(width: widthItem, height: widthItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.00001
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        assetArray[indexPath.row].isSelected.toggle()
        if assetArray[indexPath.row].isSelected {
            listIndexPathSelected.append(indexPath)
            itemCount = listIndexPathSelected.count
            indexPathToCount[indexPath] = itemCount
        } else {
            if let index = listIndexPathSelected.firstIndex(of: indexPath) {
                listIndexPathReload = Array(listIndexPathSelected[index...])
                listIndexPathSelected.remove(at: index)

                for subsequentIndexPath in listIndexPathReload {
                    if let currentCount = indexPathToCount[subsequentIndexPath] {
                        indexPathToCount[subsequentIndexPath] = currentCount - 1
                    }
                }
                collectionView.reloadItems(at: listIndexPathReload)
            }
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

struct PhotoLocal {
    var phaset: PHAsset
    var isSelected: Bool = false
}

struct Photo {
    let name: String
    let image: UIImage
    let typeLocal: Bool
    let assesst: PHAsset?
    let data: Data?
}
