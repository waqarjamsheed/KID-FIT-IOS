//
//  PreMixMus.h
//  KidFit
//
//  Created by pclink on 11/24/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreMixMus : NSObject

@property(nonatomic,strong) NSString *PreMixMusid;
@property(nonatomic,strong) NSString *PreMixMustitle;
@property(nonatomic,strong) NSString *PreMixMuspath;
@property(nonatomic,strong) NSString *PreMixMusprice;
@property(nonatomic,strong) NSString *PreMixMussubtitle;
@property(nonatomic,strong) NSString *PreMixMusduration;
@property(nonatomic,strong) NSString *PreMixMusstatus;
@property(nonatomic,strong) NSString *PreMixMuscreatedate;
@property(nonatomic,strong) NSString *PreMixMusartistname;
@property(nonatomic,strong) NSString *PreMixPathMatch;


-(id)initwithMusicDescription:(NSString*)PreMixMusid
          PreMixMustitle:(NSString *)PreMixMustitle
           PreMixMuspath:(NSString *)PreMixMuspath
          PreMixMusprice:(NSString *) PreMixMusprice
       PreMixMussubtitle:(NSString *)PreMixMussubtitle
       PreMixMusduration: (NSString *)PreMixMusduration
        PreMixMusstatus:(NSString *)PreMixMusstatus
        PreMixMuscreatedate:(NSString *)PreMixMuscreatedate
     PreMixMusartistname:(NSString *)PreMixMusartistname
         PreMixPathMatch:(NSString *)PreMixPathMatch;


@end
