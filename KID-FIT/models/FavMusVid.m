//
//  FavMusVid.m
//  KidFit
//
//  Created by pclink on 11/24/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "FavMusVid.h"

@implementation FavMusVid
@synthesize FavMusVidartistname,FavMusVidduration,FavMusVidid,FavMusVidpath,FavMusVidPathMatch,FavMusVidprice,FavMusVidtitle;


-(id)init{
    if(self){
    }
    return self;
}


-(id)initwithFavList:(NSString*)mFavMusVidid
      FavMusVidtitle:(NSString *)mFavMusVidtitle
       FavMusVidpath:(NSString *)mFavMusVidpath
      FavMusVidprice:(NSString *)mFavMusVidprice
   FavMusVidduration:(NSString *)mFavMusVidduration
 FavMusVidartistname: (NSString *)mFavMusVidartistname
  FavMusVidPathMatch:(NSString *)mFavMusVidPathMatch
    {
        if(self){
                self.FavMusVidid = mFavMusVidid;
                self.FavMusVidtitle =mFavMusVidtitle;
                self.FavMusVidpath=mFavMusVidpath;
                self.FavMusVidprice=mFavMusVidprice;
                self.FavMusVidduration=mFavMusVidduration;
                self.FavMusVidartistname=mFavMusVidartistname;
                self.FavMusVidPathMatch=mFavMusVidPathMatch;
    }
    return self;
}


@end
