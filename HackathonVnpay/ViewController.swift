//
//  ViewController.swift
//  HackathonVnpay
//
//  Created by Nguyen Hong Doan on 12/10/2023.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func open(){
        let vc = DetailImageViewController()
        self.present(vc, animated: true)
      //  self.navigationController?.pushViewController(vc, animated: true)
    }


}

