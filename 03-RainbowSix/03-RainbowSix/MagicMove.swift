//
//  MagicMove.swift
//  03-RainbowSix
//
//  Created by dzw on 2019/5/15.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

enum transitionType {
    case push
    case pop
}

class MagicMove: NSObject,UIViewControllerAnimatedTransitioning{
    
    var type : transitionType?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .push?:
            self.animatePushTransition(using: transitionContext)
            break
        case .pop?:
            self.animatePopTransition(using: transitionContext)
            break
        default:break
        }
    }
    
    private func animatePushTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //1.获取动画的源控制器和目标控制器
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! AgentListVC
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! AgentInfoVC
        let container = transitionContext.containerView
        
        //2.创建一个 Cell 中 imageView 的截图，并把 imageView 隐藏，造成使用户以为移动的就是 imageView 的假象
        let snapshotView = fromVC.selectedCell.snapshotView(afterScreenUpdates: false)
        snapshotView!.frame = container.convert(fromVC.selectedCell.frame, from: fromVC.collectionView)
        fromVC.selectedCell.bgImage.isHidden = true
        print("选中cell的frame：\(String(describing: snapshotView?.frame))")
        //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        
        //4.都添加到 container 中。注意顺序不能错了
        container.addSubview(toVC.view)
        container.addSubview(snapshotView!)
        
        //5.执行动画
        /*
         这时avatarImageView.frame的值只是跟在IB中一样的，
         如果换成屏幕尺寸不同的模拟器运行时avatarImageView会先移动到IB中的frame,动画结束后才会突然变成正确的frame。
         所以需要在动画执行前执行一次toVC.avatarImageView.layoutIfNeeded() update一次frame
         */
        toVC.tableView.tableHeaderView!.layoutIfNeeded()
        toVC.tableView.tableHeaderView?.alpha = 0
        toVC.view.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { () -> Void in
            snapshotView!.frame = container.convert(toVC.headerView!.frame, from: toVC.tableView)//toVC.tableView.head!.frame
            toVC.tableView.tableHeaderView?.alpha = 1
            toVC.view.alpha = 1
        }) { (finish: Bool) -> Void in
            fromVC.selectedCell.bgImage.isHidden = false
            toVC.headerView!.image = UIImage.init(named: toVC.headerImage!)
            snapshotView!.removeFromSuperview()
            
            //一定要记得动画完成后执行此方法，让系统管理 navigation
            transitionContext.completeTransition(true)
        }
    }
    
    private func animatePopTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! AgentInfoVC
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! AgentListVC
        let container = transitionContext.containerView
        
        let snapshotView = fromVC.headerView!.snapshotView(afterScreenUpdates: false)
        snapshotView!.frame = container.convert(fromVC.headerView!.frame, from: fromVC.tableView)
        fromVC.headerView!.isHidden = true
//        container.convert(fromVC.selectedCell.frame, from: fromVC.collectionView)
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.selectedCell.bgImage.isHidden = true
        
        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        container.addSubview(snapshotView!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { () -> Void in
            snapshotView!.frame = container.convert(toVC.selectedCell.frame, from: toVC.collectionView)
            fromVC.view.alpha = 0
        }) { (finish: Bool) -> Void in
            toVC.selectedCell.bgImage.isHidden = false
            snapshotView!.removeFromSuperview()
            fromVC.headerView?.isHidden = false
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


