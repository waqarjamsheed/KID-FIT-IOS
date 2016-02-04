//
//  mixVideoCatViewController.h
//  KidFit
//
//  Created by pclink on 11/27/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mixVideoCatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate,NSURLConnectionDelegate>

@property (nonatomic,strong) NSArray *JSONARRAY;
@property (nonatomic,strong) NSMutableArray *playlistARRAY;


-(void)retrievedata;


@property (strong, nonatomic) IBOutlet UITableView *mixplaylistTableView;
@property IBOutlet UISearchBar *SearchBar;
@property (strong,nonatomic) NSMutableArray *filteredArrayList;



@end
