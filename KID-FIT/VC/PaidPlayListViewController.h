//
//  PaidPlayListViewController.h
//  KidFit
//
//  Created by pclink on 11/30/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PaidPlayListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic,strong) NSArray *JSONARRAY;
@property (nonatomic,strong) NSMutableArray *playlistARRAY;


-(void)retrievedata;


@property (strong, nonatomic) IBOutlet UITableView *playlistTableView;

@property(nonatomic,strong) NSString *playlistID;

@property (strong) NSManagedObject *downloads;


@end
