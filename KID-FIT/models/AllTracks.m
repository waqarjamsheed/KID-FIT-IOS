//
//  AllTracks.m
//  KidFit
//
//  Created by pclink on 11/24/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "AllTracks.h"

@implementation AllTracks
@synthesize AllTracksartistname,AllTracksduration,AllTracksid,AllTrackspath,AllTracksPathMatch,AllTracksprice,AllTrackstitle,AllTracksType;



-(id)initwithAllTracksList:(NSString*)mAllTracksid
            AllTrackstitle:(NSString *)mAllTrackstitle
             AllTrackspath:(NSString *)mAllTrackspath
            AllTracksprice:(NSString *)mAllTracksprice
       AllTracksartistname:(NSString *)mAllTracksartistname
         AllTracksduration: (NSString *)mAllTracksduration
             AllTracksType:(NSString *)mAllTracksType
        AllTracksPathMatch: (NSString *)mAllTracksPathMatch{
    
    if(self){
        self.AllTracksid=mAllTracksid;
        self.AllTrackstitle=mAllTrackstitle;
        self.AllTrackspath=mAllTrackspath;
        self.AllTracksprice=mAllTracksprice;
        self.AllTracksartistname=mAllTracksartistname;
        self.AllTracksduration=mAllTracksduration;
        self.AllTracksType=mAllTracksType;
        self.AllTracksPathMatch=mAllTracksPathMatch;
    }
    
    return  self;
}

@end
