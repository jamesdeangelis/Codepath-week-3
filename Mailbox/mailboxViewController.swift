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
    var laterIconStartX : CGFloat!
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
        laterIconStartX = laterIconView.frame.origin.x
        archiveIconStartX = archiveIconView.frame.origin.x
        messageBackgroundColor = messageContainer.backgroundColor
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        messageBackgroundColor = UIColor.grayColor()
        
        if (sender.state == UIGestureRecognizerState.Began) {
            messageStartX = messageView.frame.origin.x
            laterIconStartX = laterIconView.frame.origin.x
            
            
        } else if(sender.state == UIGestureRecognizerState.Changed) {
            finalMessagePosition = messageStartX + translation.x
            
//            if (translation.x < -60) {
//                finalaterIconPosition = messageStartX + translation.x
//            }
            
            println("translation: \(translation.x)")
            println("velocity: \(velocity.x)")
            
            if (velocity.x < 0 && translation.x < -60) {
                messageContainer.backgroundColor = UIColor.blueColor()
            } else if (velocity.x < 0 && translation.x < -150) {
                messageContainer.backgroundColor = UIColor.brownColor()
            } else if (velocity.x > 0 && translation.x > 60) {
                messageContainer.backgroundColor = UIColor.yellowColor()
            } else {
//                messageContainer.backgroundColor = UIColor.yellowColor()
            }
            
            
            messageView.frame.origin.x = finalMessagePosition
            
//            laterIconView.frame.origin.x = finalaterIconPosition
            
        } else if(sender.state == UIGestureRecognizerState.Ended) {
            
        }
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
