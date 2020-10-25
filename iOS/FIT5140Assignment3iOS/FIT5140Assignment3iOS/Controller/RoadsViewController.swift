//
//  RoadsViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/25.
//

import UIKit

class RoadsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //initialise the BottomCard/FloatPanel
        setupBottomCard()
    }

    // MARK: - BottomCard/FloatPanel Related fields
    enum CardState {
        case expanded
        case collapsed
    }

    var searchAddressBottomCard : SearchAddressBottomCard!
    var visualEffectView : UIVisualEffectView!

    let cardHeight:CGFloat = 600
    let cardHandleAreaHeight:CGFloat = 150

    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }

    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0


    // MARK: - BottomCard/FloatPanel Related functions
    func setupBottomCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)

        searchAddressBottomCard = SearchAddressBottomCard(nibName:"SearchAddressBottomCard", bundle:nil)
        self.addChild(searchAddressBottomCard)
        self.view.addSubview(searchAddressBottomCard.view)

        searchAddressBottomCard.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)

        searchAddressBottomCard.view.clipsToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RoadsViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(RoadsViewController.handleCardPan(recognizer:)))

        searchAddressBottomCard.searchAddressBottomCardHandleAreaOutlet.addGestureRecognizer(tapGestureRecognizer)
        searchAddressBottomCard.searchAddressBottomCardHandleAreaOutlet.addGestureRecognizer(panGestureRecognizer)
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
                let translation = recognizer.translation(in: self.searchAddressBottomCard.searchAddressBottomCardHandleAreaOutlet)
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
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                    case .expanded:
                        self.searchAddressBottomCard.view.frame.origin.y = self.view.frame.height - self.cardHeight
                    case .collapsed:
                        self.searchAddressBottomCard.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
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
                        self.searchAddressBottomCard.view.layer.cornerRadius = 12
                    case .collapsed:
                        self.searchAddressBottomCard.view.layer.cornerRadius = 0
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

}
