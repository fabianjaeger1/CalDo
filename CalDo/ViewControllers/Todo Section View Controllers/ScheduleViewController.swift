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
        let size = CGSize(width: 370, height: 450)
        let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
        return CGRect(origin: origin, size: size)
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        presentedView?.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleBottomMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin
        ]
        presentedView?.layer.cornerRadius = 20
        presentedView?.layer.backgroundColor = UIColor.backgroundColor.cgColor
        presentedView?.translatesAutoresizingMaskIntoConstraints = true
    }
    
//    let dimmingView: UIView = {
//        let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//        dimmingView.translatesAutoresizingMaskIntoConstraints = false
//        return dimmingView
//    }()

    override func presentationTransitionWillBegin() {
        let dismissView = UIView(frame: self.containerView!.bounds)
        dismissView.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PresentationController.touchCallback(_:)))
        dismissView.addGestureRecognizer(tapGesture)
        containerView?.addSubview(dismissView)

    }
    
    @objc func touchCallback(_ sender: UITapGestureRecognizer? = nil) {
         
        let vcb = presentedViewController as! ScheduleViewController
        
        vcb.dismiss(animated: true, completion: nil)
      }
    

    override func dismissalTransitionWillBegin() {
//        super.dismissalTransitionWillBegin()
//
//        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
//            self.dimmingView.alpha = 0
//        }, completion: { _ in
//            self.dimmingView.removeFromSuperview()
//        })
//    }
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
         modalTransitionStyle = .coverVertical// use whatever transition you want
         transitioningDelegate = customTransitioningDelegate
    }
}




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
