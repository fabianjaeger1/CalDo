//
//  ScheduleViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 10/11/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = presentingViewController.view.bounds
        let size = CGSize(width: 370, height: 500)
        let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
        return CGRect(origin: origin, size: size)
    }
    
    private lazy var dismissView: UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isUserInteractionEnabled = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PresentationController.touchCallback(_:)))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        presentedView?.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleBottomMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin
        ]
        presentedView?.layer.cornerRadius = 20
        presentedView?.layer.backgroundColor = UIColor.BackgroundColor.cgColor
        presentedView?.translatesAutoresizingMaskIntoConstraints = true
    }
    
//    let dimmingView: UIView = {
//        let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//        dimmingView.translatesAutoresizingMaskIntoConstraints = false
//        return dimmingView
//    }()

    override func presentationTransitionWillBegin() {
        // Possibly implement BlurView?
//        let dismissView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//        dismissView.frame = self.containerView!.bounds
        let dismissView = UIView(frame: self.containerView!.bounds)
        dismissView.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PresentationController.touchCallback(_:)))
        dismissView.addGestureRecognizer(tapGesture)
        containerView?.addSubview(dismissView)

        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.dismissView.alpha = 1
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    @objc func touchCallback(_ sender: UITapGestureRecognizer? = nil) {
         
        let vcb = presentedViewController as! ScheduleViewController
        
        vcb.dismiss(animated: true, completion: nil)
      }
    

    override func dismissalTransitionWillBegin() {
//        super.dismissalTransitionWillBegin()
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.dismissView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.dismissView.removeFromSuperview()
        })
    }
}

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class ScheduleViewController: UIViewController {
    
    private var customTransitioningDelegate = TransitioningDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .BackgroundColor
        // Do any additional setup after loading the view.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
           super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
           configure()
       }

       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           configure()
       }

}

private extension ScheduleViewController {
    func configure() {
         modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve// use whatever transition you want
         transitioningDelegate = customTransitioningDelegate
    }
}

