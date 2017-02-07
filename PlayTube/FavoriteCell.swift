//
//  FavoriteCell.swift
//  PlayTube
//
//  Created by Adnan Basar on 19/01/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation
import Graph
import Material

class FavoriteCell: TableViewCell {

    var constraintsUpdated = false
    
    var thumbnailView: UIImageView!
    var titleLabel: UILabel!
    var channelLabel: UILabel!
    var publishedLabel: UILabel!
    var durationLabel: UILabel!
    var moreButton: IconButton!
    var favoriteButton: IconButton!
    
    override var height: CGFloat{
        
        get{
            return CGFloat(HeightPreset.xlarge.rawValue)
        }
        set(value){
            super.height = value
        }
    }

    var data: Entity? {
        didSet{
            layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let d = self.data  else {
            return
        }
                
        self.thumbnailView.sd_setImage(with: d[Keys.thumbnailURL] as? URL)
        self.titleLabel.text = d[Keys.title] as? String
        self.channelLabel.text = d[Keys.channelTitle] as? String
        self.publishedLabel.text = d[Keys.publishedDate] as? String
        self.durationLabel.text = d[Keys.duration] as? String
        
        self.favoriteButton.addTarget(self, action: #selector(self.removeFromFavorite), for: .touchUpInside)
    
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.playVideo)))
    
    }
    
    @objc
    func removeFromFavorite(){
        
        guard let d = self.data else {
            return
        }
        
        d.delete()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    @objc
    func playVideo(){
        
        guard let r = self.data?.convertToVideoResource() else {
            return
        }
        
        PlayerController.sharedInstance.selectedResource = r
    }
    
    
    override func prepare() {
        super.prepare()
        
        layer.rasterizationScale = Screen.scale
        layer.shouldRasterize = true
        
        pulseAnimation = .pointWithBacking
        backgroundColor = nil
        
        contentView.height = self.height
        
        prepareThumbnailView()
        prepareTitleLabel()
        prepareChannelLabel()
        preparePublishedLabel()
        prepareDurationLabel()
        prepareRightButtons()
        addSubviews()
        
        updateConstraintsIfNeeded()
    }
    
    private func prepareThumbnailView(){
        self.thumbnailView = UIImageView(
            frame: CGRect.init(x: 0, y: 0, width: self.height * 1.77, height: self.height)
        )
    }
    
    private func prepareTitleLabel(){
        self.titleLabel = UILabel()
        self.titleLabel.font = RobotoFont.medium(with: 13.0)
        self.titleLabel.textColor = Color.black
    }
    
    private func prepareChannelLabel(){
        self.channelLabel = UILabel()
        self.channelLabel.font = RobotoFont.regular(with: 11.0)
        self.channelLabel.textColor = Color.blueGrey.base
    }
    
    private func preparePublishedLabel(){
        self.publishedLabel = UILabel()
        self.publishedLabel.font = RobotoFont.regular(with: 11.0)
        self.publishedLabel.textColor = Color.cyan
    }
    
    private func prepareDurationLabel(){
        self.durationLabel = UILabel()
        self.durationLabel.font = RobotoFont.light(with: 11.0)
        self.durationLabel.textColor = Color.white
        
        self.durationLabel.borderWidth = 1.0
        self.durationLabel.borderColor = Color.blueGrey.darken1
        self.durationLabel.cornerRadius = 2.0
        self.durationLabel.backgroundColor = Color.black
    }
    
    private func prepareRightButtons(){
        self.moreButton = IconButton(image: Icon.cm.moreVertical, tintColor: Color.blueGrey.base)
        self.favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.red.base)
    }
    
    private func addSubviews(){
        
        self.contentView.addSubview(self.thumbnailView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.channelLabel)
        self.contentView.addSubview(self.publishedLabel)
        self.contentView.addSubview(self.favoriteButton)
        self.contentView.addSubview(self.moreButton)
        self.contentView.addSubview(self.durationLabel)
    }
    
    override func updateConstraintsIfNeeded() {
        
        if !constraintsUpdated {
            constraintsUpdated = true
            
            
            self.titleLabel.snp.makeConstraints({(make) -> Void in
                make.left.equalTo(self.thumbnailView.snp.right).offset(8)
                make.topMargin.equalTo(8)
            })
            
            self.channelLabel.snp.makeConstraints({(make) -> Void in
                make.left.equalTo(self.titleLabel)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            })
            
            self.publishedLabel.snp.makeConstraints({(make) -> Void in
                make.left.equalTo(self.titleLabel)
                make.top.equalTo(self.channelLabel.snp.bottom).offset(4)
            })
            
            self.durationLabel.snp.makeConstraints({(make) -> Void in
                make.bottom.equalTo(self.thumbnailView).inset(8)
                make.right.equalTo(self.thumbnailView).inset(8)
            })
            
            self.moreButton.snp.makeConstraints({(make) -> Void in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(16)
            })
            
            self.favoriteButton.snp.makeConstraints({(make) -> Void in
                make.centerY.equalToSuperview()
                make.right.equalTo(self.moreButton.snp.left)
            })
        }
        super.updateConstraintsIfNeeded()
        
    }

    
    

}
