//
//  playListTableViewCell.m
//  KidFit
//
//  Created by pclink on 12/3/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "playListTableViewCell.h"

@implementation playListTableViewCell

+ (playListTableViewCell*) tracksTableViewCell
{
    playListTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"playListTableViewCell" owner:self options:nil] objectAtIndex:0];
   // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)isDownload:(id)sender {
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // do customization here
    }
    //  self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor clearColor]];
    return self;
}



@end
