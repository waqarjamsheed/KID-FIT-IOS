//
//  PreMixMus.m
//  KidFit
//
//  Created by pclink on 11/24/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "PreMixMus.h"

@implementation PreMixMus

@synthesize PreMixMusid,PreMixMustitle,PreMixMuspath,PreMixMusprice,PreMixMussubtitle
,PreMixMusduration,PreMixMusstatus,PreMixMuscreatedate,PreMixMusartistname,PreMixPathMatch;


-(id)init{
    if(self){
    }
    return self;
}

-(id)initwithMusicDescription:(NSString*)mPreMixMusid
               PreMixMustitle:(NSString *)mPreMixMustitle
                PreMixMuspath:(NSString *)mPreMixMuspath
               PreMixMusprice:(NSString *) mPreMixMusprice
            PreMixMussubtitle:(NSString *)mPreMixMussubtitle
            PreMixMusduration: (NSString *)mPreMixMusduration
              PreMixMusstatus:(NSString *)mPreMixMusstatus
          PreMixMuscreatedate:(NSString *)mPreMixMuscreatedate
          PreMixMusartistname:(NSString *)mPreMixMusartistname
              PreMixPathMatch:(NSString *)mPreMixPathMatch{
    if(self){
        self.PreMixMusid = mPreMixMusid;
        self.PreMixMustitle=mPreMixMustitle;
        self.PreMixMuspath=mPreMixMuspath;
        self.PreMixMusprice = mPreMixMusprice;
        self.PreMixMussubtitle=mPreMixMussubtitle;
        self.PreMixMusduration = mPreMixMusduration;
        self.PreMixMusstatus = mPreMixMusstatus;
        self.PreMixMuscreatedate = mPreMixMuscreatedate;
        self.PreMixMusartistname = mPreMixMusartistname;
        self.PreMixPathMatch = mPreMixPathMatch;
    }
    
    
    return  self;

}

@end
