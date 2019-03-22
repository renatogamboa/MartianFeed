import UIKit

class ScaleSegue: UIStoryboardSegue {
    
    override func perform() {
        scale()
    }
    
    func scale() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView =  fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        fromViewController.navigationController?.isNavigationBarHidden = true
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        toViewController.view.center = originalCenter
        toViewController.view.alpha = 0
        
        containerView?.addSubview(toViewController.view)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
            toViewController.view.alpha = 1
        }, completion: { success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
}


class UnwindScaleSegue: UIStoryboardSegue {
    
    override func perform() {
        scale()
    }
    
    func scale() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        toViewController.view.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            fromViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            toViewController.view.alpha = 1
        }, completion: { success in
            fromViewController.dismiss(animated: false, completion: nil)
        })
    }
}
