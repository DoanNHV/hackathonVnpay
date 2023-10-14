//
//  ViewController.swift
//  HackathonVnpay
//
//  Created by Nguyen Hong Doan on 12/10/2023.
//

import Photos
import UIKit

class ViewController: UIViewController {
    private var imageNotRequirement: [Photo] = []
    lazy var listAssesSelected: [PhotoLocal] = []
    var listImagePhotoShopName = [Photo]()
    lazy var dispatchGroup = DispatchGroup()
    private lazy var imageOption: PHImageRequestOptions = {
        let imageOption = PHImageRequestOptions()
        imageOption.deliveryMode = .highQualityFormat
        imageOption.resizeMode = .exact
        return imageOption
    }()
    
    let imageManager = PHImageManager.default()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func checkPhotoLibraryAuthorization() {
        let permissionPhotoStatus: PHAuthorizationStatus
        if #available(iOS 14, *) {
            permissionPhotoStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            permissionPhotoStatus = PHPhotoLibrary.authorizationStatus()
        }
        switch permissionPhotoStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                guard status == .denied else {
                    DispatchQueue.main.async {
                        self?.fetchAllPhotos()
                    }
                    return
                }
            }
        case .restricted, .denied:
            DispatchQueue.main.async { [weak self] in
//                self?.presentLibraryPermissionAlert()
            }
        case .authorized:
            fetchAllPhotos()
        case .limited:
            DispatchQueue.main.async {
                self.fetchAllPhotos()
            }
        @unknown default:
            print("Some case missing", #line)
        }
    }
    
    private func fetchAllPhotos() {
        let vc = OptionAddPhotoPopup(listImageSelected: listAssesSelected, listImageCommon: listImagePhotoShopName, listImageShopName: listImagePhotoShopName)
        imageNotRequirement.removeAll()
        vc.getListPhotoLocal = { [weak self] listAsses in
            guard let self = self else { return }
            self.listAssesSelected = listAsses.filter { $0.isSelected }
            
            self.listAssesSelected.forEach { assesst in
                self.dispatchGroup.enter()
                self.imageManager.requestImage(for: assesst.phaset, targetSize: CGSize(width: 1000, height: 1000), contentMode: .aspectFit, options: self.imageOption) { image, _ in
                    if let originalImage = image {
                        let resizedImage = self.resizeImage(image: originalImage, maxFileSize: 600)
                        if let resizedImage = resizedImage {
                            let existingImage = self.listImagePhotoShopName.filter { $0.assesst?.localIdentifier == assesst.phaset.localIdentifier }.first
                            if existingImage == nil {
                                debugPrint("size", assesst.phaset.fileSize)
                            }
                        }
                    }
                    self.dispatchGroup.leave()
                }
            }
            
            self.dispatchGroup.notify(queue: .main) {
//                self.collectionView.reloadData()
            }
            // xoá ảnh khi người dùng bấm tích chọn lại
            self.listImagePhotoShopName.removeAll { photo in
                !(self.listAssesSelected.contains(where: { imageSelected in
                    imageSelected.phaset == photo.assesst
                })) && photo.assesst != nil
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func resizeImage(image: UIImage, maxFileSize: Int) -> UIImage? {
        var compressionQuality: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compressionQuality)
           
        while let data = imageData, Double(data.count) / 1024.0 > Double(maxFileSize) {
            compressionQuality -= 0.1
            if compressionQuality <= 0.0 {
                break
            }
            imageData = image.jpegData(compressionQuality: compressionQuality)
        }
           
        if let finalImageData = imageData, let resizedImage = UIImage(data: finalImageData) {
            let imageSizeInBytes = finalImageData.count
            let imageSizeInKB = Double(imageSizeInBytes) / 1024.0
            print("Dung lượng ảnh: \(imageSizeInKB) KB")
            return resizedImage
        }
           
        return nil
    }
    
    @IBAction func didTapGetPhoto(_ sender: Any) {
        checkPhotoLibraryAuthorization()
    }
}

extension PHAsset {
    var fileSize: Float {
        let resource = PHAssetResource.assetResources(for: self)
        let imageSizeByte = resource.first?.value(forKey: "fileSize") as? Float ?? 0.0
        let imageSizeMB = imageSizeByte / (1024.0 * 1024.0)
        return imageSizeMB
    }
}
