//
//  VideoFullscreenViewController.swift


import UIKit
import ZFPlayer

class VideoFullscreenViewController: UIViewController {
    
    
    //video params
    var controlView:ZFPlayerControlView!
    var player:ZFPlayerController!
    
    var urlName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let playerManager = ZFAVPlayerManager()
        player = ZFPlayerController.init(playerManager: playerManager, containerView: UIApplication.shared.keyWindow!)
        
        controlView = ZFPlayerControlView()
        controlView.fastViewAnimated = true
        controlView.effectViewShow = false
        controlView.prepareShowLoading = true
        
        controlView?.backBtnClickCallback = {
            self.player.enterFullScreen(false, animated: false)
            self.player.stop()
            self.navigationController?.popViewController(animated: false)
        }
        
        player.controlView = controlView
        player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMask.landscape
        player.enterFullScreen(true, animated: false)
        
        playerManager.assetURL = URL(string: "file://" + Helper().FILE_PATH(urlName))!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.player.isViewControllerDisappear = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.player.isViewControllerDisappear = true
    }
    
    
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
        return UIInterfaceOrientationMask.landscape
    }
    
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
