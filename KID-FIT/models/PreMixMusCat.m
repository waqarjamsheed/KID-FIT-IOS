//
//  PreMixMusCat.m
//  KidFit
//
//  Created by pclink on 11/24/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "PreMixMusCat.h"

@implementation PreMixMusCat

@synthesize PreMixMusCatid,PreMixMusCatname;


-(id)init{
    if(self){
    }
return self;
}

-(id)initwithPlayListCat: (NSString *)catID catName: (NSString *)catName{
    if (self){
        self.PreMixMusCatid=catID;
        self.PreMixMusCatname = catName;
    }
    return self;
}

@end
