//
//  AudioPlayerViewController.h
//  KidFit
//
//  Created by Muhammad Faraz on 25/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LMMediaItem.h"
#import "LMMediaPlayerView.h"

@interface AudioPlayerViewController : UIViewController<LMMediaPlayerViewDelegate,NSURLConnectionDelegate>

@property(nonatomic,strong)NSString *TrackPath;
@property(nonatomic,strong)NSString *TrackTitle;
@property(nonatomic,strong)NSString *TrackID;
@property(nonatomic,strong)NSString *TrackType;
@property(nonatomic)bool *isUrl;
@property(nonatomic,strong)NSString *TrackExtention;
@property(nonatomic,strong)IBOutlet UIView *PlayerView;
@property(weak, nonatomic) IBOutlet UILabel *subtitle;
@property(weak, nonatomic) IBOutlet UIButton *BtnIcon;
@property(weak, nonatomic) IBOutlet UIImageView *musicType;

@end
