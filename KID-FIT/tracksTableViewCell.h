//
//  tracksTableViewCell.h
//  KidFit
//
//  Created by Muhammad Faraz on 26/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tracksTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *musicThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *titleTrack;
@property (weak, nonatomic) IBOutlet UILabel *authurName;
@property (weak, nonatomic) IBOutlet UIButton *downloadsButton;
- (IBAction)isDownload:(id)sender;
+ (tracksTableViewCell*) tracksTableViewCell;
@end
