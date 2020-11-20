//
//  SoundHelper.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 16/11/20.
//

import Foundation
import AVFoundation

class SoundHelper{
    static let shared = SoundHelper()
    private var player:AVAudioPlayer?
    private init(){
        
    }
    
    func playOverSpeedSound(){
        guard let url = Bundle.main.url(forResource: "overspeed", withExtension: "wav") else{
            return
        }
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }catch{
            print(error)
        }
    }
}
