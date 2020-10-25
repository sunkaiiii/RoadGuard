//
//  RoadInformationViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 23/10/20.
//

import UIKit

class RoadInformationViewController: UIViewController,DefaultHttpRequestAction {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        setupBottomCard()
    }
    
    //let the navigation bar fully transparent, references on https://stackoverflow.com/questions/25845855/transparent-navigation-bar-ios
    func initNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
//        requestRestfulService(api: AWS.face, model: TestModel(), jsonType: TestModel2.self){(a,b,c)->Void in
//            
//        }
    }
    
    func handleData(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



    // MARK: - BottomCard/FloatPanel Related fields
    enum CardState {
        case expanded
        case collapsed
    }

    var roadInfoBottomCard : RoadInfoBottomCard!
    var visualEffectView : UIVisualEffectView!

    let cardHeight:CGFloat = 680
    let cardHandleAreaHeight:CGFloat = 400

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

        roadInfoBottomCard = RoadInfoBottomCard(nibName:"RoadInfoBottomCard", bundle:nil)
        self.addChild(roadInfoBottomCard)
        self.view.addSubview(roadInfoBottomCard.view)

        roadInfoBottomCard.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)

        roadInfoBottomCard.view.clipsToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RoadsViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(RoadsViewController.handleCardPan(recognizer:)))

        roadInfoBottomCard.roadInfoBottomCardHandleAreaOutlet.addGestureRecognizer(tapGestureRecognizer)
        roadInfoBottomCard.roadInfoBottomCardHandleAreaOutlet.addGestureRecognizer(panGestureRecognizer)
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
                let translation = recognizer.translation(in: self.roadInfoBottomCard.roadInfoBottomCardHandleAreaOutlet)
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
                        self.roadInfoBottomCard.view.frame.origin.y = self.view.frame.height - self.cardHeight
                    case .collapsed:
                        self.roadInfoBottomCard.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
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
                        self.roadInfoBottomCard.view.layer.cornerRadius = 12
                    case .collapsed:
                        self.roadInfoBottomCard.view.layer.cornerRadius = 0
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
