//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Sebastian Ruiz on 10/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
    var favorited:Bool = false
    var retweeted:Bool = false
    var tweetid: Int = -1
    

    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var rtButton: UIButton!
    
    @IBAction func likeTweet(_ sender: Any) {
        let tobeFavorited = !favorited
        if(tobeFavorited){
            TwitterAPICaller.client?.favoriteTweet(tweetID: tweetid, success: {
                self.setFavorite(true)
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetID: tweetid, success: {
                self.setFavorite(false)
            }, failure: { (error) in
                print("Unfavorite did not succeed: \(error)")
            })
        }
    }
    
    @IBAction func rtTweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetID: tweetid, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
            print("Error is retweeted: \(error)")
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFavorite(_ isFavorited:Bool){
        favorited = isFavorited
        if(favorited) {
            likeButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            likeButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted:Bool){
        retweeted = isRetweeted
        if(retweeted) {
            rtButton.setImage(UIImage(named:"retweet-icon-green"), for: UIControl.State.normal)
            rtButton.isEnabled = false
        }
        else {
            rtButton.setImage(UIImage(named:"retweet-icon"), for: UIControl.State.normal)
            rtButton.isEnabled = true
        }
    }

}
