//
//  PreMixMusPlay.m
//  KidFit
//
//  Created by pclink on 11/24/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "PreMixMusPlay.h"

@implementation PreMixMusPlay

@synthesize PreMixMusPlayid,PreMixMusPlayname;


-(id)init{
    if(self){
    }
    return self;
}

-(id)initwithPlayList: (NSString *)platlistID playlistName: (NSString *)playlistName
{
    if(self){
        self.PreMixMusPlayid=platlistID;
        self.PreMixMusPlayname = playlistName;
    }
    return self;
}


@end
