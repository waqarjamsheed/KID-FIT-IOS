//
//  PreMixMusPlay.h
//  KidFit
//
//  Created by pclink on 11/24/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreMixMusPlay : NSObject

@property(nonatomic,strong) NSString *PreMixMusPlayid;
@property(nonatomic,strong) NSString *PreMixMusPlayname;

-(id)initwithPlayList: (NSString *)platlistID playlistName: (NSString *)playlistName;

@end
