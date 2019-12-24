//
//  Utilities.swift
//  ZFPlayerSwift
//
//  Created by Radwa Khaled on 12/24/19.
//

import Foundation
import ZFPlayer

public class  Utilities {
    
    private init() {}
    static let shared = Utilities()
    
    //MARK:- ZF library Video player setting
    func videoSetUp(thumbUrl:String, title:String, player:inout ZFPlayerController?, playerManager: ZFAVPlayerManager, controlView:inout ZFPlayerControlView?, containerView: UIView, viewController:UIViewController, thumbnail:UIImageView) {
        
        
        player = ZFPlayerController.init(playerManager: playerManager, containerView: containerView)
        controlView = ZFPlayerControlView()
        controlView!.fastViewAnimated = true
        controlView!.autoHiddenTimeInterval = 5
        controlView!.autoFadeTimeInterval = 0.5
        controlView!.prepareShowLoading = true
        controlView!.prepareShowControlView = true
        
        controlView?.showTitle(title, coverURLString: nil, fullScreenMode: ZFFullScreenMode.automatic)
        thumbnail.setImageWithURLString(thumbUrl, placeholder: ZFUtilities.image(with: UIColor(red: 220 / 255.0, green: 220 / 255.0, blue: 220 / 255.0, alpha: 1), size: CGSize(width: 1, height: 1)))
        
        player!.controlView = controlView!
        player!.pauseWhenAppResignActive = false
        
        
        player!.orientationWillChange = { player, isFullScreen in
            viewController.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
}
