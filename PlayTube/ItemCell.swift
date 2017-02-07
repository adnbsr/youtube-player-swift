//
//  ItemCell.swift
//  PlayTube
//
//  Created by Adnan Basar on 30/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import Foundation
import UIKit
import Material
import AlamofireImage
import Alamofire


class ItemCell: TableViewCell {
    
    var constraintsUpdated = false
 
    var thumbnailView: UIImageView!
    var titleLabel: UILabel!
    var channelLabel: UILabel!
    var publishedLabel: UILabel!
    var durationLabel: UILabel!
    var moreButton: IconButton!
    var favoriteButton: IconButton!
    
    var resource: VideoResource? {
        didSet{
            layoutSubviews()
        }
    }
    
    override var height: CGFloat{
    
        get{
            return CGFloat(HeightPreset.xlarge.rawValue)
        }
        set(value){
            super.height = value
        }
    }



    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let r = resource else {
            return
        }
        
        self.thumbnailView.sd_setImage(with: r.thumbnailURL)
        self.titleLabel.text = r.title
        self.channelLabel.text = r.channelTitle
        self.publishedLabel.text = r.uploadedDate
        self.durationLabel.text = r.duration
        
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
        self.titleLabel.font = RobotoFont.medium(with: 12.0)
        self.titleLabel.textColor = Color.black
        self.titleLabel.adjustsFontSizeToFitWidth = false
        self.titleLabel.lineBreakMode = .byTruncatingTail
    }
    
    private func prepareChannelLabel(){
        self.channelLabel = UILabel()
        self.channelLabel.font = RobotoFont.regular(with: 10.0)
        self.channelLabel.textColor = Color.blueGrey.base
    }
    
    private func preparePublishedLabel(){
        self.publishedLabel = UILabel()
        self.publishedLabel.font = RobotoFont.regular(with: 10.0)
        self.publishedLabel.textColor = Color.cyan
    }
    
    private func prepareDurationLabel(){
        self.durationLabel = UILabel()
        self.durationLabel.font = RobotoFont.light(with: 10.0)
        self.durationLabel.textColor = Color.white
        
        self.durationLabel.borderWidth = 1.0
        self.durationLabel.borderColor = Color.blueGrey.darken1
        self.durationLabel.cornerRadius = 2.0
        self.durationLabel.backgroundColor = Color.black
    }
    
    private func prepareRightButtons(){
        self.moreButton = IconButton(image: Icon.cm.moreVertical, tintColor: Color.blueGrey.base)
        self.favoriteButton = IconButton(image: Icon.favoriteBorder, tintColor: Color.red.base)
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
            
            self.moreButton.snp.makeConstraints({(make) -> Void in
                make.centerY.equalToSuperview()
                //make.right.equalToSuperview().inset(16)
                make.trailing.equalToSuperview().inset(16)
            })
            
            self.favoriteButton.snp.makeConstraints({(make) -> Void in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(self.moreButton.snp.leading)
            })
            
            self.durationLabel.snp.makeConstraints({(make) -> Void in
                make.bottom.equalTo(self.thumbnailView).inset(8)
                make.right.equalTo(self.thumbnailView).inset(8)
            })
            
            self.titleLabel.snp.makeConstraints({(make) -> Void in
                make.left.equalTo(self.thumbnailView.snp.right).offset(8)
                //make.right.equalTo(self.favoriteButton.snp.left).inset(8)
                //make.trailing.lessThanOrEqualTo(self.favoriteButton.snp.leading)
                //make.right.lessThanOrEqualTo(self.favoriteButton.snp.left)
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
            
        }
        super.updateConstraintsIfNeeded()

    }

    
}
