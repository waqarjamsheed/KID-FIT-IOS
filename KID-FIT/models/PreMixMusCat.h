//
//  PreMixMusCat.h
//  KidFit
//
//  Created by pclink on 11/24/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreMixMusCat : NSObject

@property(nonatomic,strong) NSString *PreMixMusCatid;
@property(nonatomic,strong) NSString *PreMixMusCatname;

-(id)initwithPlayListCat: (NSString *)catID catName: (NSString *)catName;

@end
