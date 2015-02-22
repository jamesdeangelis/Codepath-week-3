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
    @IBOutlet weak var messageFeed: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var mailContainer: UIView!

    var messageStartX : CGFloat!
    var messagePanBegan : CGFloat!
    var laterIconStartX : CGPoint!
    var archiveIconStartX: CGFloat!
    var messageBackgroundColor: UIColor!
    
    var finalMessagePosition : CGFloat!
    var finalaterIconPosition: CGFloat!
    var finalarchiveIconPosition: CGFloat!
    
    var edgePanBegan: CGFloat!
    var finalMailContainerPosition: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mailScrollView.contentSize = CGSize(width: 320, height:1136)
        
        messageStartX = messageView.frame.origin.x
        archiveIconStartX = archiveIconView.frame.origin.x
        rescheduleButton.hidden = true
        listButton.hidden = true
        
        laterIconView.center.x = 290
        archiveIconView.center.x = 30
        
        // edge panning setup
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        mailContainer.addGestureRecognizer(edgeGesture)
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)

        if (sender.state == UIGestureRecognizerState.Began) {
            messagePanBegan = messageView.frame.origin.x
            
        } else if(sender.state == UIGestureRecognizerState.Changed) {
            finalMessagePosition = messagePanBegan + translation.x
            
            // begin swipe left
            if (messageView.frame.origin.x < 0 && messageView.frame.origin.x > -60) {
                laterIconView.alpha = -translation.x / 60
            }
            
            // begin swipe right
            if (messageView.frame.origin.x > 0 && messageView.frame.origin.x < 60) {
                archiveIconView.alpha = translation.x / 60
            }
            
            // Short swipe left
            if (messageView.frame.origin.x < -60 && messageView.frame.origin.x > -180) {
                messageContainer.backgroundColor = UIColor(red: (250/255.0), green: (211/255.0), blue: (51/255.0), alpha: 1.0)
                laterIconView.image = UIImage(named: "later_icon")
                laterIconView.center.x = messageView.center.x + 160 + 30
                
            // long swipe left
            } else if (messageView.frame.origin.x < -179) {
                messageContainer.backgroundColor = UIColor(red: (216/255.0), green: (166/255.0), blue: (117/255.0), alpha: 1.0)
                laterIconView.image = UIImage(named: "list_icon")
                laterIconView.center.x = messageView.center.x + 160 + 30
                
            // Short swipe right
            } else if (messageView.frame.origin.x > 60 && messageView.frame.origin.x < 180) {
                messageContainer.backgroundColor = UIColor(red: (112/255.0), green: (217/255.0), blue: (98/255.0), alpha: 1.0)
                
                archiveIconView.image = UIImage(named: "archive_icon")
                archiveIconView.center.x = messageView.center.x - 160 - 30
            
            // Long swipe right
            } else if (messageView.frame.origin.x > 179) {
                messageContainer.backgroundColor = UIColor(red: (235/255.0), green: (84/255.0), blue: (51/255.0), alpha: 1.0)
                archiveIconView.image = UIImage(named: "delete_icon")
                archiveIconView.center.x = messageView.center.x - 160 - 30
                
            } else {
                messageContainer.backgroundColor = UIColor(red: (227/255.0), green: (227/255.0), blue: (227/255.0), alpha: 1.0)
                laterIconView.center.x = 290
                archiveIconView.center.x = 30
            }
            
            messageView.frame.origin.x = finalMessagePosition
            
        } else if(sender.state == UIGestureRecognizerState.Ended) {
            
            // complete pan for later action
            if (messageView.frame.origin.x < -60 && messageView.frame.origin.x > -180) {
                self.archiveIconView.alpha = 0

                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageView.frame.origin.x = -320
                    self.laterIconView.center.x = self.messageView.center.x + 15 + 20
                    
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
                            self.rescheduleView.alpha = 1
                            self.rescheduleButton.hidden = false
                            
                        }, completion: nil)
                    })
            
            // complete scroll for list action
            } else if (messageView.frame.origin.x < -180) {
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageView.frame.origin.x = -320
                    self.laterIconView.center.x = self.messageView.center.x + 15 + 20
                    
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
                            self.listView.alpha = 1
                            self.listButton.hidden = false
                            
                            }, completion: nil)
                })
            
            // complete for done action
             } else if (messageView.frame.origin.x > 60 && messageView.frame.origin.x < 180) {
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    
                    self.messageView.frame.origin.x = 320
                    self.archiveIconView.center.x = self.messageView.center.x + 15 + 20
                    
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
                            self.messageContainer.alpha = 0
                            
                            }, completion: { (Bool) -> Void in
                                UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                                    self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y - self.messageView.frame.height
                                    
                                    }, completion: { (Bool) -> Void in
                                        UIView.animateWithDuration(0.7, delay: 0, options: .CurveLinear, animations: { () -> Void in
                                            self.addMessage()
                                            }, completion: nil)
                                })
                        })
                })
                
            // complete for delete action
            } else if (messageView.frame.origin.x > 180) {
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageView.frame.origin.x = 320
                    self.archiveIconView.center.x = self.messageView.center.x + 15 + 20
                    
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
                            self.messageContainer.alpha = 0
                            
                            }, completion: { (Bool) -> Void in
                                UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                                    self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y - self.messageView.frame.height
                                    
                                    }, completion: { (Bool) -> Void in
                                        UIView.animateWithDuration(0.7, delay: 0, options: .CurveLinear, animations: { () -> Void in
                                            self.addMessage()
                                            }, completion: nil)
                                })
                })
            })
                
            // bounce back if not scrolled far enough
            } else {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 15, options: nil, animations: { () -> Void in
                    self.messageView.frame.origin.x = 0
                    
                }, completion: nil)
            }
            
        }
    }
    
    
    @IBAction func reschedulePressed(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
            self.rescheduleView.alpha = 0
            self.rescheduleButton.hidden = true
            
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
                    self.messageContainer.alpha = 0
                    
                    }, completion: { (Bool) -> Void in
                        self.removeMessage()
                })
        })
        
        UIView.animateWithDuration(1, delay: 1, options: .CurveLinear, animations: { () -> Void in
            self.messageContainer.alpha = 1
            self.messageView.frame.origin.x = 0
            
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y + self.messageView.frame.height
                    self.messageView.frame.origin.x = 0
                    self.messageContainer.alpha = 1
                    self.messageView.alpha = 1
                    self.archiveIconView.alpha = 0
                    self.laterIconView.alpha = 0
                    }, completion: nil)
            })

        }
    
    @IBAction func listButtonPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
            self.listView.alpha = 0
            self.listButton.hidden = true
            
            }, completion: { (Bool) -> Void in
                self.removeMessage()
        })
        
        UIView.animateWithDuration(1, delay: 1, options: .CurveLinear, animations: { () -> Void in
            self.messageContainer.alpha = 1
            self.messageView.frame.origin.x = 0
            
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y + self.messageView.frame.height
                    self.messageView.frame.origin.x = 0
                    self.messageContainer.alpha = 1
                    self.messageView.alpha = 1
                    self.archiveIconView.alpha = 0
                    self.laterIconView.alpha = 0
                    }, completion: nil)
            })
            
        }
    
    // Animate the message away after successful swipe
    func removeMessage() {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: { () -> Void in
            self.messageContainer.alpha = 0
            
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y - self.messageView.frame.height
                    
                    }, completion: nil)
        })
    }
    
    // Return the message to it's beginning state
    func addMessage() {
        UIView.animateWithDuration(0, delay: 0, options: .CurveLinear, animations: { () -> Void in
            self.messageContainer.alpha = 1
            self.messageView.frame.origin.x = 0
            self.messageView.alpha = 0
            self.messageContainer.backgroundColor = UIColor(red: (227/255.0), green: (227/255.0), blue: (227/255.0), alpha: 1.0)
            
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y + self.messageView.frame.height
                    self.messageContainer.alpha = 1
                    self.messageView.alpha = 1
                    }, completion: nil)
        })
    }
    
    @IBAction func resetButtonPresserd(sender: AnyObject) {
        
        if (mailContainer.frame.origin.x == 0) {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 15, options: nil, animations: { () -> Void in
                self.mailContainer.frame.origin.x = self.mailContainer.frame.origin.x + 280
            }, completion: nil)
            } else if (mailContainer.frame.origin.x == 280) {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 15, options: nil, animations: { () -> Void in
                self.mailContainer.frame.origin.x = self.mailContainer.frame.origin.x - 280
                }, completion: nil)
            }
    }
    
    //Edge panning 
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        var translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            edgePanBegan = mailContainer.frame.origin.x
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            finalMailContainerPosition = edgePanBegan + translation.x
            mailContainer.frame.origin.x = finalMailContainerPosition
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            // Spring back if not panned far enough
            if (mailContainer.frame.origin.x < 100) {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 15, options: nil, animations: { () -> Void in
                    self.mailContainer.frame.origin.x = 0
                    }, completion: nil)
            
            // Spring forward if panned far enough
            } else if (mailContainer.frame.origin.x > 100) {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 15, options: nil, animations: { () -> Void in
                    self.mailContainer.frame.origin.x = 280
                    }, completion: nil)
            }
        }
    }
    


/*
// MARK: - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
*/
    
}