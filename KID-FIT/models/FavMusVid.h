//
//  FavMusVid.h
//  KidFit
//
//  Created by pclink on 11/24/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavMusVid : NSObject

@property(nonatomic,strong) NSString *FavMusVidid;
@property(nonatomic,strong) NSString *FavMusVidtitle;
@property(nonatomic,strong) NSString *FavMusVidpath;
@property(nonatomic,strong) NSString *FavMusVidprice;
@property(nonatomic,strong) NSString *FavMusVidduration;
@property(nonatomic,strong) NSString *FavMusVidartistname;
@property(nonatomic,strong) NSString *FavMusVidPathMatch;


-(id)initwithFavList:(NSString*)mFavMusVidid
              FavMusVidtitle:(NSString *)mFavMusVidtitle
                FavMusVidpath:(NSString *)mFavMusVidpath
               FavMusVidprice:(NSString *)mFavMusVidprice
            FavMusVidduration:(NSString *)mFavMusVidduration
            FavMusVidartistname: (NSString *)mFavMusVidartistname
              FavMusVidPathMatch:(NSString *)mFavMusVidPathMatch;


@end
