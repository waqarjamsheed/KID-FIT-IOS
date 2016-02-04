//
//  VideoPlayListViewController.h
//  KidFit
//
//  Created by pclink on 11/26/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface VideoPlayListViewController :  UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate,NSURLConnectionDelegate>
@property (nonatomic,strong) NSArray *JSONARRAY;
@property (nonatomic,strong) NSMutableArray *playlistARRAY;


-(void)retrievedata;


@property (strong, nonatomic) IBOutlet UITableView *playlistTableView;

@property(nonatomic,strong) NSString *playlistID;

@property (strong) NSManagedObject *downloads;

@property IBOutlet UISearchBar *SearchBar;
@property (strong,nonatomic) NSMutableArray *filteredArrayList;

@end
