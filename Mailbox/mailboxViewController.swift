//
//  mailboxViewController.swift
//  Mailbox
//
//  Created by James De Angelis on 19/02/2015.
//  Copyright (c) 2015 James De Angelis. All rights reserved.
//

import UIKit

class mailboxViewController: UIViewController {
    @IBOutlet weak var mailScrollView: UIScrollView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var laterIconView: UIImageView!
    @IBOutlet weak var archiveIconView: UIImageView!

    var messageStartX : CGFloat!
    var messagePanBegan : CGFloat!
    var laterIconStartX : CGPoint!
    var archiveIconStartX: CGFloat!
    
    var finalMessagePosition : CGFloat!
    var finalaterIconPosition: CGFloat!
    var finalarchiveIconPosition: CGFloat!
    
    var messageBackgroundColor: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mailScrollView.contentSize = CGSize(width: 320, height:1136)
        
        messageStartX = messageView.frame.origin.x
//        laterIconStartX = laterIconView.frame.origin.x
        archiveIconStartX = archiveIconView.frame.origin.x
        messageBackgroundColor = UIColor.grayColor()
        
        laterIconStartX = CGPoint(x: messageView.frame.width - 30, y: messageView.center.y)
         messageView.alpha = 0.5
        
//        messageBackgroundColor = messageContainer.backgroundColor
        println("hello world!")
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        println("velocity: \(velocity.x)")
        println("translation x: \(translation.x)")

        if (sender.state == UIGestureRecognizerState.Began) {
            messagePanBegan = messageView.frame.origin.x
            
        } else if(sender.state == UIGestureRecognizerState.Changed) {
            
            finalMessagePosition = messagePanBegan + translation.x
            
//           SHORT SWIPE LEFT
            if (messageView.center.x < 100 && messageView.center.x > -40) {
                messageView.alpha = 0.5
                messageContainer.backgroundColor = UIColor.blueColor()
                laterIconView.center.x = messageView.center.x + 160 + 50
                
//          Long swipe left
            } else if (velocity.x < 0 && translation.x < -150) {
                messageContainer.backgroundColor = UIColor.cyanColor()
                
            } else if (velocity.x > 0 && translation.x > 60) {
                messageContainer.backgroundColor = UIColor.greenColor()
                
            } else {
                messageContainer.backgroundColor = UIColor.grayColor()
            }
            
            messageView.frame.origin.x = finalMessagePosition
//            laterIconView.frame.origin.x = finalaterIconPosition
//            
        } else if(sender.state == UIGestureRecognizerState.Ended) {
            
            if (velocity.x < 0 && translation.x < -60) {

                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageView.frame.origin.x = -300
                }, completion: nil)
                
            } else if (velocity.x > 0 && translation.x > 60) {
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageView.frame.origin.x = 340
                }, completion: nil)
            
            } else {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 15, options: nil, animations: { () -> Void in
                    self.messageView.frame.origin.x = 20
                }, completion: nil)
            }
            
        }
    }
    
    @IBAction func resetButtonPresserd(sender: AnyObject) {
        messageView.center.x = view.frame.width / 2
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
