//
//  TestZoomView.swift
//  3DCamera
//
//  Created by zhangxin on 2020/8/21.
//  Copyright © 2020 Zy. All rights reserved.
//

import UIKit

typealias ImageZoomViewLeftSwipCallBack = ()->()
typealias ImageZoomViewRightSwipCallBack = ()->()
class EditorImageZoomView: UIView,UIScrollViewDelegate{
    let maxScale: CGFloat = 3.0 // 最大缩放倍数
    let minScale: CGFloat = 0.5 // 最小倍数
    let scaleDuration = 0.38 // 缩放动画时间
    var lastScale: CGFloat = 1.0 // 最后一次的缩放比例
    var tapOffset: CGPoint? // 双击放大偏移的 point
    
    //记录图片到view边界的距离
    var paddingH : CGFloat = 0//水平距离
    var paddingV : CGFloat = 0//垂直距离

    var leftSwipCallBack : ImageZoomViewLeftSwipCallBack?
    var rightSwipCallBack : ImageZoomViewRightSwipCallBack?
    var isFeedbackGenerator : Bool = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    func setupUI() {
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(doubleTap(tap:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        //左右滑动手势
        let swipRightOrange = UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwipTap(_:)))
        swipRightOrange.direction = .right
        self.addGestureRecognizer(swipRightOrange)
        let swipLeftOrange = UISwipeGestureRecognizer.init(target: self, action: #selector(leftSwipTap(_:)))
        swipLeftOrange.direction = .left
        self.addGestureRecognizer(swipLeftOrange)
        
        self.addSubview(scrollView)
    }
    
    // MARK: - Customized
      /** 设置缩放比例 */
      fileprivate func setZoom(scale: CGFloat) {
          // 缩放比例限制（在最大最小中间）
          lastScale = max(min(scale, maxScale), minScale)
          imgView.transform = CGAffineTransform.init(scaleX: lastScale, y: lastScale)
          
          let imageW = imgView.frame.size.width
          let imageH = imgView.frame.size.height
          if lastScale > 1 {
              // 内边距是针对 scrollView 捏合缩放，图片居中设置的边距
              scrollView.contentInset = UIEdgeInsets.zero // 内边距清空
              // 修改中心点
              imgView.center = CGPoint.init(x: imageW / 2, y: imageH / 2)
              scrollView.contentSize = CGSize.init(width: imageW, height: imageH)
              if let offset = tapOffset {
                  scrollView.contentOffset = offset
              }
          } else {
              calculateInset()
              scrollView.contentSize = CGSize.zero
          }
      }
    
    /*
    /** 计算双击放大偏移量 */
    fileprivate func calculateOffset(tapPoint: CGPoint) {
        
        let viewSize = self.bounds.size
        let imgViewSize = imgView.bounds.size
        // 计算最大偏移 x y
        let maxOffsetX = imgViewSize.width * maxScale - viewSize.width
        let maxOffsetY = imgViewSize.height * maxScale - viewSize.height
        
        var tapX: CGFloat = tapPoint.x
        var tapY: CGFloat = tapPoint.y
        if imgViewSize.width == viewSize.width {
            // 将 tap superview 的 point 转换 tap 到 imageView 上的距离
            tapY = tapPoint.y - (viewSize.height - imgViewSize.height) / 2
        } else {
            tapX = tapPoint.x - (viewSize.width - imgViewSize.width) / 2
        }
        // 计算偏移量
        let offsetX = (tapX * maxScale - (self.superview?.center.x)!)
        let offsetY = (tapY * maxScale - (self.superview?.center.y)!)
        // 判断偏移量是否超出限制（0, maxOffset）
        let x = min(max(offsetX, 0), maxOffsetX)
        let y = min(max(offsetY, 0), maxOffsetY)
        
        tapOffset = CGPoint.init(x: x, y: y)
    }
    */
    
    /** 计算内边距 */
    fileprivate func calculateInset() {
        let imgViewSize = imgView.frame.size
        let scrollViewSize = scrollView.bounds.size
        // 垂直内边距
        let paddingV = imgViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imgViewSize.height) / 2 : 0
        // 水平内边距
        let paddingH = imgViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imgViewSize.width) / 2 : 0
        scrollView.contentInset = UIEdgeInsets.init(top: paddingV, left: paddingH, bottom: paddingV, right: 0)
        imgView.center = CGPoint.init(x: imgViewSize.width / 2, y: imgViewSize.height / 2)
        
        self.paddingH = paddingH
        self.paddingV = paddingV
    }
        
    /*
    // MARK: - Callbacks
    /** 单击复原 */
    @objc func singleTap(tap: UITapGestureRecognizer) {
        UIView.animate(withDuration: scaleDuration) {
            self.setZoom(scale: 1.0)
        }
    }
    
    /** 双击放大 */
    @objc func doubleTap(tap: UITapGestureRecognizer) {
        // 获取点击的位置
        let point = tap.location(in: self)
        // 根据点击的位置计算偏移量
        calculateOffset(tapPoint: point)
        
        if lastScale > 1 {
            lastScale = 1
        } else {
            lastScale = maxScale
            // 单击手势放在这里
            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(singleTap(tap:)))
            addGestureRecognizer(singleTap)
        }
        UIView.animate(withDuration: scaleDuration) {
            self.setZoom(scale: self.lastScale)
        }
    }
 */
    //MARK: - 左右滑动手势监听
    @objc func rightSwipTap(_ tab:UISwipeGestureRecognizer) {
        print("右滑手势触发了")
        self.rightSwipCallBack?()
        
    }
    @objc func leftSwipTap(_ tab:UISwipeGestureRecognizer) {
        print("左滑手势触发了")
        self.leftSwipCallBack?()
    }
    //双击恢复正常
    @objc func doubleTap(tap: UITapGestureRecognizer) {
        UIView.animate(withDuration: scaleDuration) {
            self.setZoom(scale: 1.0)
        }
    }
        
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if imgView.frame.size.width >= Device.screenWidth && self.isFeedbackGenerator == true{
            //震动
            let impactLight = UIImpactFeedbackGenerator(style: .medium)
            impactLight.impactOccurred()
            self.isFeedbackGenerator = false
        } else {
            if (imgView.frame.size.width < Device.screenWidth) {
                self.isFeedbackGenerator = true
            }
        }
       
        // 捏合动画完成计算内边距
        calculateInset()
    }
        
    // MARK: - Setter
    var image: UIImage? {
        didSet {
            // 以最短的边等比例缩小图片
            let imgSize = image?.size ?? CGSize(width: 200, height: 200)
            let scrollViewSize = scrollView.bounds.size
            /*
            var rect = scrollView.bounds
            rect.origin.x = 24.dpW
            rect.origin.y = 20.dpW
            rect.size.width = rect.size.width - 24.dpW * 2
            rect.size.height = rect.size.height - 20.dpW
            let scrollViewSize = rect.size
             */
            let widthScale = scrollViewSize.width / imgSize.width
            let heightScale = scrollViewSize.height / imgSize.height
            let imageMinScale = min(widthScale, heightScale)
            scrollView.minimumZoomScale = minScale
            //imgView.bounds = CGRect.init(x: 24.dpW, y: 20.dpW, width: imgSize.width * imageMinScale, height: imgSize.height * imageMinScale)
            imgView.bounds = CGRect.init(x: 0, y: 0, width: imgSize.width * imageMinScale, height: imgSize.height * imageMinScale)
            imgView.image = image
            
            self.paddingV = imgView.frame.y
            self.paddingH = imgView.frame.x
        }
    }
        
    // MARK: - Getter
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView.init(frame: self.bounds)
        view.delegate = self
        view.maximumZoomScale = maxScale
        view.minimumZoomScale = 1
        view.contentSize = self.bounds.size
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.addSubview(self.imgView)
        return view
    }()
    
    lazy var imgView: UIImageView = {
        let view = UIImageView.init(frame: self.bounds)
//        var rect = self.bounds
//        rect.origin.x = 24.dpW
//        rect.origin.y = 20.dpW
//        rect.size.width = rect.size.width - 24.dpW * 2
//        rect.size.height = rect.size.height - 20.dpW
//        let view = UIImageView.init(frame: rect)
        return view
    }()
}
