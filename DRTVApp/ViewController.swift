//
//  ViewController.swift
//  DRTVApp
//
//  Created by Michael on 28/12/2016.
//  Copyright © 2016 Michael. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import GoogleCast
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import AlamofireImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var _programCards = [ProgramCard]()
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self

        let frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let castButton = GCKUIButton(frame: frame)
        castButton.tintColor = UIColor.white
        let item = UIBarButtonItem(customView: castButton)
        
        navigationItem.rightBarButtonItem = item
        
        getMostViewed { programCards, error in
            if programCards != nil {
            self._programCards = programCards!
                self.collectionView.reloadData()}
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _programCards.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let programCard = self._programCards[indexPath.row]
        Alamofire.request(programCard.videoURL!).validate().responseObject { (response: DataResponse<Manifest>) in
            switch response.result {
            case .success(let value):
                if let link = value.links?.first(where: {$0.target == ManifestTarget.HLS})?.uri {
                    let player = AVPlayer(url: link)
                    let controller = AVPlayerViewController()
                    controller.player = player
                    self.present(controller, animated: true, completion: {
                        controller.player!.play()
                    })
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgramCell", for: indexPath) as? ProgramCell {
            let programCard = self._programCards[indexPath.row]
            cell.cellTitle.text = programCard.title
            
            let imageURL = "\(programCard.imageURL!)?width=150"
            Alamofire.request(imageURL).responseImage { response in
                switch response.result {
                case .success(let value):
                    cell.cellImage.image = value
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 114)
    }
    
    func loadMedia() {
        let duration: TimeInterval = 0.0
        let videoUrl: String = ""
        let streamType: GCKMediaStreamType = .buffered
        let metadata = GCKMediaMetadata(metadataType: .generic)
        let mediaInfo = GCKMediaInformation(contentID: videoUrl, streamType: streamType, contentType: "video/mp4", metadata: metadata, streamDuration: duration, customData: nil)
        
        GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.loadMedia(mediaInfo, autoplay: true)
    }
    func getMostViewed(complete: @escaping ([ProgramCard]?, Error?) -> ()) {
        let url = "https://www.dr.dk/mu/ProgramViews/MostViewed?from=2016-12-27&span=7%3A00%3A00%3A00"
        
        Alamofire.request(url).responseArray(keyPath: "Data") { (response: DataResponse<[MostViewedEntity]>) in
            switch response.result {
            case .success(let value):
                var programCards = [ProgramCard]()
                
                for entity in value {
                    programCards.append(entity.programCard!)
                }
                
                complete(programCards, nil)
            case .failure(let error):
                complete(nil, error)
            }
        }
    }
}
