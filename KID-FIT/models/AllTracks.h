//
//  AllTracks.h
//  KidFit
//
//  Created by pclink on 11/24/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllTracks : NSObject

@property(nonatomic,strong) NSString *AllTracksid;
@property(nonatomic,strong) NSString *AllTrackstitle;
@property(nonatomic,strong) NSString *AllTrackspath;
@property(nonatomic,strong) NSString *AllTracksprice;
@property(nonatomic,strong) NSString *AllTracksduration;
@property(nonatomic,strong) NSString *AllTracksartistname;
@property(nonatomic,strong) NSString *AllTracksType;
@property(nonatomic,strong) NSString *AllTracksPathMatch;


-(id)initwithAllTracksList:(NSString*)mAllTracksid
            AllTrackstitle:(NSString *)mAllTrackstitle
            AllTrackspath:(NSString *)mAllTrackspath
            AllTracksprice:(NSString *)mAllTracksprice
            AllTracksartistname:(NSString *)mAllTracksartistname
            AllTracksduration: (NSString *)mAllTracksduration
            AllTracksType:(NSString *)mAllTracksType
            AllTracksPathMatch: (NSString *)mAllTracksPathMatch;





@end

