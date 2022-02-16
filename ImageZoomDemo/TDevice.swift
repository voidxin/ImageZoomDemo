//
//  TDevice.swift
//  ImageZoomDemo
//
//  Created by zhangxin on 2022/2/16.
//

import UIKit

public struct Device {
    
    /// 是否为模拟器
    public static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
    
    /// 是否为iPad
    public static let isIpad: Bool = {
        return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
    }()
    
    ///判断是不是iOS 11
    public static let iOS11 : Bool = {
        var state = false
        if #available(iOS 11, *) {
            state = true
            if #available(iOS 12.0, *) {
                state = false
            }
        }
        return state
    }()
    
    /// 是否为全面屏手机
    public static let isFullScreen: Bool = {
        return (Screen.is4_0 == false && Screen.is4_7 == false && Screen.is5_5 == false) && (Device.isIpad == false)
    }()
    
    /// 屏幕宽度
    public static let screenWidth: CGFloat = {
        return Screen.main.bounds.width
    }()
    /// 屏幕高度
    public static let screenHeight: CGFloat = {
        return Screen.main.bounds.height
    }()
    
    //判断是否是刘海屏幕（上面的方法判断不对）
    public static var isLiuHai: Bool {
        if #available(iOS 11, *) {
              guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                  return false
              }
              
              if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
//                  print(unwrapedWindow.safeAreaInsets)
                  return true
              }
        }
        return false
    }
    
    /// 导航栏高度
    public static let navBarH: CGFloat = 44
    
    //默认tabbar高度(非刘海屏)
    public static let defaultTabBarH: CGFloat = {
        return 56.0
    }()
    
    /// tabbar高度
    public static let tabBarH: CGFloat = {
        return Device.defaultTabBarH + Device.bottomSafeAreaH
    }()
    
    /// 状态栏高度
    public static let statusBarH: CGFloat = {
        if Device.isLiuHai == true {
            return 44
        }
        return 20
    }()
    
    
    /// 底部安全栏高度
    public static let bottomSafeAreaH: CGFloat = {
        if Device.isLiuHai {
            return 34
        }
        return 0
    }()
    
    
}
public typealias Screen = UIScreen

public extension UIScreen {
    
    class var width : CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class var  height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    class var  centerX: CGFloat {
        return UIScreen.main.bounds.width * 0.5
    }
    
    class var  centerY: CGFloat {
        return UIScreen.main.bounds.height * 0.5
    }
    
    class var  center: CGPoint {
        return CGPoint(x: UIScreen.centerX, y: UIScreen.centerY)
    }
    
    class var  isiPhoneXScreen: Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        return UIApplication.shared.windows[0].safeAreaInsets.top > 20.0
    }
    
    class var statusBarHeight: CGFloat {
        return isiPhoneXScreen ? 44.0 : 20.0
    }
    
    class var  bottomSafeMargin: CGFloat {
        return isiPhoneXScreen ? 34.0 : 0.0
    }
    
    /// 4.0寸屏幕
    class var is4_0: Bool {
        return (Screen.width == 320.0 && Screen.height == 568.0)
    }
    
    
    /// 4.7寸
    class var is4_7: Bool {
        return (Screen.width == 375.0 && Screen.height == 667.0)
    }
    
    
    /// 5.5寸
    class var is5_5: Bool {
        return (Screen.width == 414.0 && Screen.height == 736.0)
    }
    
    
    /// 5.8寸
    class var is5_8: Bool {
        return (Screen.width == 375.0 && Screen.height == 812.0)
    }
    
    
    /// 6.1寸
    class var is6_1: Bool {
        return (Screen.width == 414.0 && Screen.height == 896.0)
    }
    
    
    /// 6.5寸
    class var is6_5: Bool {
        return (Screen.width == 414.0 && Screen.height == 896.0)
    }
}
public extension CGRect {
    
    var x: CGFloat {
        get {
            return origin.x
        }
        
        set {
            origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return origin.y
        }
        
        set {
            origin.y = newValue
        }
    }
    
    
    var width: CGFloat {
        get {
            return size.width
        }
        
        set {
            size.width = newValue
        }
    }
    
    
    var height: CGFloat {
        get {
            return size.height
        }
        
        set {
            size.height = newValue
        }
    }
    
    
    var center: CGPoint {
        get {
            return  CGPoint(x: x + width/2, y: y + height/2)
        }
        
        set {
            origin.x = newValue.x - width/2
            origin.y = newValue.y - height/2
        }
    }

    
    var centerX: CGFloat {
        get {
            return  center.x
        }
        
        set {
            origin.x = newValue - width/2
        }
    }
    
    var centerY: CGFloat {
        get {
            return  center.y
        }
        
        set {
            origin.y = newValue - height/2
        }
    }

}
