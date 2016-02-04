//
//  playListTableViewCell.h
//  KidFit
//
//  Created by pclink on 12/3/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playListTableViewCell : UITableViewCell
+ (playListTableViewCell*) tracksTableViewCell;

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;

@end
