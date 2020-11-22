//
//  BottomScrollableView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 29/10/20.
//
//Basing on the BottomCard/FloatPanel from https://github.com/brianadvent/InteractiveCardViewAnimation

import UIKit
//dif1: UIViewController
class BottomScrollableView: UIView {
    // MARK: - BottomCard/FloatPanel Related fields
    enum CardState {
        case expanded
        case collapsed
    }

    var contentViewController : ScrollableViewController!
    var visualEffectView : UIVisualEffectView!

    var tabBarHeight : CGFloat = 0

    //will adjusted in the page which using the bottom card
    //whole card height
    var cardHeight:CGFloat = 680
    //the height of the handle area
    var cardHandleAreaHeight:CGFloat = 400

    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }

    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0

    //dif2: Original ref do not have init
    init(contentViewController:ScrollableViewController,superview:UIView) {
        self.contentViewController = contentViewController
        super.init(frame: superview.frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let superview = newSuperview{
            setupBottomCard(superview: superview)
        }
    }

    
    // MARK: - BottomCard/FloatPanel Related functions
    func setupBottomCard(superview:UIView) {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = superview.frame

        //y:superview.height - handleAreaHeight means that: only show the handle area at the begining. the card body will be out side the bottomline of the view
        contentViewController.view.frame = CGRect(x: 0, y: superview.frame.height - cardHandleAreaHeight, width: superview.bounds.width, height: cardHeight)

        contentViewController.view.clipsToBounds = true
        contentViewController.view.layer.cornerRadius = 32
        self.contentViewController.view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(BottomScrollableView.handleCardPan(recognizer:)))
        contentViewController.areaOutlet?.addGestureRecognizer(panGestureRecognizer)

//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BottomScrollableView.handleCardTap(recognzier:)))
//        contentViewController.areaOutlet?.addGestureRecognizer(tapGestureRecognizer)

        self.addSubview(visualEffectView)
        self.addSubview(contentViewController.view)
    }

    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
            case .ended:
                animateTransitionIfNeeded(state: nextState, duration: 0.9)
            default:
                break
        }
    }

    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
            case .began:
                startInteractiveTransition(state: nextState, duration: 0.9)
            case .changed:
                let translation = recognizer.translation(in: self.contentViewController.areaOutlet)
                var fractionComplete = translation.y / cardHeight
                fractionComplete = cardVisible ? fractionComplete : -fractionComplete
                updateInteractiveTransition(fractionCompleted: fractionComplete)
            case .ended:
                continueInteractiveTransition()
            default:
                break
        }

    }

    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty , let superview = self.superview{
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                    case .expanded:
                        self.contentViewController.view.frame.origin.y = superview.frame.height - self.cardHeight - self.tabBarHeight
                    case .collapsed:
                        self.contentViewController.view.frame.origin.y = superview.frame.height - self.cardHandleAreaHeight
                }
            }

            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }

            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)


            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                    case .expanded:

                        self.contentViewController.view.layer.cornerRadius = 32

                    case .collapsed:
                        self.contentViewController.view.layer.cornerRadius = 32

                }
            }

            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)

            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                    case .expanded:
                        self.visualEffectView.effect = UIBlurEffect(style: .dark)
                    case .collapsed:
                        self.visualEffectView.effect = nil
                }
            }

            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)

        }
    }

    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }

    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }

    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }


    //handle the touch event distribution
    //references on https://gist.github.com/siberian1967/ab1e15f46b5ed30d0e3060079f090ae8
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if cardVisible{
            return true
        }
        if(point.y > self.contentViewController.view.frame.origin.y){
            return true
        }
        return false
    }

}
