//
//  ViewController.swift
//  ZFPlayerSwift
//
//  Created by Radwa Khaled on 12/21/19.
//

import UIKit
import ZFPlayer
import MBProgressHUD

class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var imgPlacholder: UIImageView!
    @IBOutlet weak var videoView: UIView!
    let downloadManager = ZFDownloadManager.shared()
    
    //MARK: - Params
    let kVideoCover = "https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"
    let urlStr = "https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4"
    let urlStr2 = "http://flv3.bn.netease.com/tvmrepo/2018/6/H/9/EDJTRBEH9/SD/EDJTRBEH9-mobile.mp4"
    var controlView:ZFPlayerControlView!
    var player:ZFPlayerController!
    var playerManager = ZFAVPlayerManager()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if player != nil && player.isFullScreen {
            return .lightContent
        }
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        if player != nil {
            return player.isStatusBarHidden
        }
        
        return false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        if player != nil {
            return UIStatusBarAnimation.slide
        }
        
        return .slide
    }
    
    override var shouldAutorotate: Bool {
        if player != nil {
            return self.player.shouldAutorotate
        }
        
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        if player != nil && (self.player.isFullScreen) {
            return UIInterfaceOrientationMask.landscape
        }
        
        return UIInterfaceOrientationMask.portrait
        
    }
    
    
    //MARK: - View controller cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ZFDownloadManager.shared().maxCount = 2
        Utilities.shared.videoSetUp(thumbUrl: kVideoCover, title: "Video title", player: &player, playerManager: playerManager, controlView: &controlView, containerView: videoView, viewController: self, thumbnail: imgPlacholder)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if player != nil {
            self.player.isViewControllerDisappear = false
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if player != nil {
            self.player.isViewControllerDisappear = true
        }
        
    }
    
    
    //MARK: - Actions
    @IBAction func downloadVideo1Action(_ sender: UIButton) {
        DispatchQueue.global(qos: .userInitiated).async {
            let words = self.urlStr.components(separatedBy: "/").last
            ZFDownloadManager.shared().downFileUrl(self.urlStr, filename: words, fileimage: UIImage(named:"loading_bgView"), lessonname: "Video name", lessonid: "1")
        }
        
    }
    
    @IBAction func downloadVideo2Action(_ sender: UIButton) {
        DispatchQueue.global(qos: .userInitiated).async {
            let words = self.urlStr2.components(separatedBy: "/").last
            ZFDownloadManager.shared().downFileUrl(self.urlStr2, filename: words, fileimage: UIImage(named:"loading_bgView"), lessonname: "Video name2", lessonid: "2")
        }
    }
    
    @IBAction func playVideoAction(_ sender: UIButton) {
        
        player.assetURL = URL(string: urlStr)!
    }
}
