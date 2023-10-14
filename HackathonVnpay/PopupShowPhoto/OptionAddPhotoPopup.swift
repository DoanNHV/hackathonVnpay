//
//  OptionAddPhotoPopup.swift
//  CoopBank
//
//  Created by pc on 29/07/2023.
//  Copyright © 2023 VNPAY. All rights reserved.
//

import Photos
import UIKit

class OptionAddPhotoPopup: UIViewController {
    private var allPhotos: PHFetchResult<PHAsset>!
    var getListPhotoLocal: (([PhotoLocal]) -> Void)?
    var listImageSelected: [PhotoLocal] = []
    private var assetArray: [PhotoLocal] = []
    var listImagePhoto: [Photo] = []
    var listImageCommon: [Photo] = []
    private var listIndexPathSelected = [IndexPath]()
    private var listIndexPathReload = [IndexPath]()
    private let imageManager = PHCachingImageManager()
    private var itemCount = 0

    var count = 0

    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var assetOption: PHFetchOptions = {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.includeHiddenAssets = false
        allPhotosOptions.includeAllBurstAssets = false
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        allPhotosOptions.includeAssetSourceTypes = [.typeCloudShared, .typeUserLibrary, .typeiTunesSynced]
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
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .vertical
        allPhotos = PHAsset.fetchAssets(with: assetOption)
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(LibPhotoCollectionViewCell.self)
        for index in 0 ..< allPhotos.count {
            let asset = allPhotos.object(at: index)
            if listImageCommon.contains(where: { poo in
                poo.assesst == asset
            }) {
                assetArray.append(.init(phaset: asset, isSelected: true))
            } else {
                assetArray.append(.init(phaset: asset))
            }
        }

        collectionView.reloadData()
    }

    init(listImageSelected: [PhotoLocal], listImageCommon: [Photo], listImageShopName: [Photo]) {
        self.listImageSelected = listImageSelected
        self.listImageCommon = listImageCommon
        listImagePhoto = listImageShopName
        super.init(nibName: "OptionAddPhotoPopup", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func didTapDoneAction(_ sender: Any) {
        getListPhotoLocal?(assetArray)
    }
}

extension OptionAddPhotoPopup: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(LibPhotoCollectionViewCell.self, at: indexPath)
        let asset = assetArray[indexPath.item]
        cell.representedAssetIdentifier = asset.phaset.localIdentifier
        imageManager.requestImage(for: asset.phaset, targetSize: CGSize(width: 1000, height: 1000), contentMode: .aspectFit, options: imageOption, resultHandler: { [weak cell] image, _ in
            if cell?.representedAssetIdentifier == asset.phaset.localIdentifier {
                cell?.setImage(image: image ?? UIImage(), isCheck: asset.isSelected, count: self.itemCount)
            }
        })
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetArray.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width - 20
        return CGSize(width: screenWidth / 3, height: screenWidth / 3)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listImageSelected.contains(where: { poo in
            poo.phaset == assetArray[indexPath.row].phaset
        }) {}
        assetArray[indexPath.row].isSelected.toggle()
        if assetArray[indexPath.row].isSelected {
            listIndexPathSelected.append(indexPath)
            itemCount = listIndexPathSelected.count
        } else {
            if let index = listIndexPathSelected.firstIndex(of: indexPath) {
                listIndexPathReload = Array(listIndexPathSelected[index...])
                listIndexPathSelected.remove(at: index)
                for indexPath in listIndexPathSelected {
                    itemCount -= 1
                    collectionView.reloadItems(at: [indexPath])
                }
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
