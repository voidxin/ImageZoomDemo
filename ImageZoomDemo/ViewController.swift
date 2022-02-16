//
//  ViewController.swift
//  ImageZoomDemo
//
//  Created by zhangxin on 2022/2/16.
//

import UIKit

class ViewController: UIViewController {
    lazy var ensureImageView : EditorImageZoomView = {
        let zoomView = EditorImageZoomView(frame: CGRect(x: 15, y: 150, width: Device.screenWidth - 30, height: 300))
        return zoomView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(ensureImageView)
        ensureImageView.frame = CGRect(x: 15, y: 150, width: Device.screenWidth - 30, height: 300)
        ensureImageView.image = UIImage.init(named: "image3")
    }


}

