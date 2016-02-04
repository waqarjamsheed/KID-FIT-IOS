//
//  premixplaylist.h
//  KidFit
//
//  Created by Muhammad Faraz on 25/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface premixplaylist : NSObject

@property (nonatomic,strong) NSString *BestMusic;
@property (nonatomic,strong) NSString *New;
@property (nonatomic,strong) NSString *ClassicalMusic;
@property (nonatomic,strong) NSString *MyMusic;


-(id)initwithBestMusic: (NSString *)hBestMusic andNew: (NSString *)hNew andClassicalMusic:(NSString *)hClassicalMusic andMyMusic:(NSString *)hMyMusic; 




@end
