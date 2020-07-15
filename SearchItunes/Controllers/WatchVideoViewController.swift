//
//  WatchVideoViewController.swift
//  SearchItunes
//
//  Created by Taof on 5/21/20.
//  Copyright © 2020 taoquynh. All rights reserved.
//

import UIKit
import AVFoundation

class WatchVideoViewController: UIViewController {
    
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var sumTime: UILabel!
    
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var backWardImageView: UIImageView!
    @IBOutlet weak var forwardImageView: UIImageView!
    
    var item: Itune?
    var playerItems: AVPlayerItem?
    var player: AVPlayer?
    var previewUrl: String = ""
    var isPlay: Bool = false
    var totalTime: Float64 = 0
    var currentTime: Float64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = item {
            trackLabel.text = "\(String(describing: data.trackName ?? ""))"
            artistLabel.text = "\(String(describing: data.artistName ?? ""))"
            previewUrl = data.previewUrl ?? ""
        }
        
        let backButton = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "expand"), style: .done, target: self, action: #selector(pop))
        rightButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightButton
        
        playImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playPress))
        playImageView.addGestureRecognizer(tapGesture)
        
        backWardImageView.isUserInteractionEnabled = true
        forwardImageView.isUserInteractionEnabled = true
        let forWardGesture = UITapGestureRecognizer(target: self, action: #selector(onForward))
        let backWardGesture = UITapGestureRecognizer(target: self, action: #selector(onBackward))
        backWardImageView.addGestureRecognizer(backWardGesture)
        forwardImageView.addGestureRecognizer(forWardGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
        setupVideo()
    }
    
    @objc func pop(){
        player?.pause()
        navigationController?.popViewController(animated: false)
    }
    
    @objc func playPress() {
        if isPlay {
            playImageView.image = UIImage(named: "pause")
            player?.play()
        } else {
            playImageView.image = UIImage(named: "play")
            player?.pause()
        }
        isPlay = !isPlay
    }
    
    @IBAction func changeSlider(_ sender: UISlider) {
        let seconds : Int64 = Int64(sender.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        currentTime = CMTimeGetSeconds((player?.currentTime())!)
        // hàm seek để cập nhật thời gian
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }

    }
    
    @objc func onBackward(){
        changeTime(currentTime - 5)
    }
    
    @objc func onForward(){
        changeTime(currentTime + 5)
    }
    
    func changeTime(_ newTime: Float64){
        let targetTime:CMTime = CMTimeMake(value: Int64(newTime), timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    func setupVideo(){
        let videoURL = URL(string: previewUrl)!
        // gán url cho player
        player = AVPlayer(url: videoURL)
        
        // add layer player
        let playerLayer = AVPlayerLayer(player: player)
        let playerWidth: CGFloat = view.bounds.width
        let playerHeight: CGFloat = 300
        playerLayer.backgroundColor = UIColor.black.cgColor
        playerLayer.frame = CGRect(x: 0, y: 200, width: playerWidth, height: playerHeight)
        self.view.layer.addSublayer(playerLayer)
        
        // chạy player
        player?.play()
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] (time) in
            guard let strongSelf = self else { return }
            if strongSelf.player?.currentItem?.status == .readyToPlay {
                let time: Float64 = CMTimeGetSeconds((strongSelf.player?.currentTime())!)
                strongSelf.currentTime = time
                strongSelf.slider.value = Float(time)
                strongSelf.runTime.text = strongSelf.convertSecond(time)
                if strongSelf.currentTime == strongSelf.totalTime {
                    strongSelf.playImageView.image = UIImage(named: "play")
                    strongSelf.runTime.text = "00:00"
                    strongSelf.slider.value = Float(0)
                    strongSelf.player?.seek(to: CMTimeMake(value: 0, timescale: 1))
                }
            }
        })
        
        let playerItem = AVPlayerItem(url: videoURL)
        slider.minimumValue = 0
        let duration: CMTime = playerItem.asset.duration
        let seconds: Float64 = CMTimeGetSeconds(duration)
        slider.maximumValue = Float(seconds)
        totalTime = seconds
        sumTime.text = convertSecond(seconds)
        playImageView.image = UIImage(named: "pause")
    }
    
    func convertSecond(_ time: Float64) -> String {
        let minute = Int(time) / 60
        let second = Int(time) % 60
        return "\(minute < 10 ? "0\(minute)" : "\(minute)"):\(second < 10 ? "0\(second)" : "\(second)")"
    }
}
