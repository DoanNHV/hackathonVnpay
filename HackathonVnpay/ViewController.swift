//
//  ViewController.swift
//  HackathonVnpay
//
//  Created by Nguyen Hong Doan on 12/10/2023.
//

import Photos
import UIKit

class ViewController: UIViewController {
   
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
        case .restricted, .denied: break
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
        let vc = ListImageAlbums()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapGetPhoto(_ sender: Any) {
        checkPhotoLibraryAuthorization()
    }
}
