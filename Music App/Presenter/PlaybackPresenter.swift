//
//  PlaybackPresenter.swift
//  Music App
//
//  Created by Sơn Nguyễn on 23/07/2022.
//
import AVFoundation
import Foundation
import UIKit

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()

    private var track: AudioTrack?
    private var tracks = [AudioTrack?]()
    var index = 0
    // MARK: - currentTrack DÙNG ĐỂ TRUYỀN DỮ LIỆU ( TÊN BÀI HÁT,ẢNH, V..V.. ) CHO MÀN HÌNH PHÁT (QUA DATA SOURCE)
    var currentTrack: AudioTrack? {
        print(index)
        if index > tracks.count - 1 { index = 0}
        return tracks[index]
    }

    var playerVC: PlayerViewController?

    var player: AVPlayer?
    var playerQueue: [AVPlayer?] = []
    var isPlaying = false

// MARK: -  PHÁT 1 DANH SÁCH
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ) {
        playerQueue.removeAll()
        self.tracks = tracks
        
        for index in 0...tracks.count-1 {
            if let url = URL (string: tracks[index].preview_url ?? "" ){
                playerQueue.append( AVPlayer(url: url))
            }
            else {
                playerQueue.append(nil)
            }
        }
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true){
            self.index = 0
            self.player = self.playerQueue[self.index]
            self.player?.play()
            self.isPlaying = true
        }
        self.playerVC = vc
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    // MARK: - NÚT DỪNG / PHÁT TIẾP
    func didTapPlayPause() {
        
        if let player = player {
            if player.timeControlStatus == .playing {
                DispatchQueue.main.async {
                    player.pause()
                    self.isPlaying = false
                }
            }
            else if player.timeControlStatus == .paused {
                DispatchQueue.main.async {
                    player.play()
                    self.isPlaying = true
                }
            }
        }
        
    }

    func didTapForward() {
        guard self.index < tracks.count - 1, !tracks.isEmpty else { return }
        player?.pause()
        index += 1
        player = playerQueue[index]
        print(index)
        //currentTrack = tracks[index]
        playerVC?.refreshUI()
        if isPlaying { player?.play() }
    }

    func didTapBackward() {
        guard index > 0, !tracks.isEmpty else { return }
        player?.pause()
        index -= 1
        player = playerQueue[index]
        print(index)
        playerVC?.refreshUI()
        if isPlaying { player?.play() }
    }

    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }

    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }

    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
