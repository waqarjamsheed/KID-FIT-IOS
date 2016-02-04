//
//  premixplaylist.m
//  KidFit
//
//  Created by Muhammad Faraz on 25/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "premixplaylist.h"

@implementation premixplaylist

@synthesize BestMusic,New,ClassicalMusic,MyMusic;

-(id)initwithBestMusic:(NSString *)hBestMusic andNew:(NSString *)hNew andClassicalMusic:(NSString *)hClassicalMusic andMyMusic:(NSString *)hMyMusic;

{
    //self = [super init];
    
    if (self)
        
    {
        BestMusic=hBestMusic;
        New=hNew;
        ClassicalMusic=hClassicalMusic;
        MyMusic=hMyMusic;
       
        
    }
    
    return self;
}

@end
