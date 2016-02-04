//
//  favvideoViewController.h
//  KidFit
//
//  Created by Muhammad Faraz on 24/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface favvideoViewController : UIViewController<NSURLConnectionDelegate>


@property (strong,nonatomic) IBOutlet UIButton *myvideo;
@property (strong,nonatomic) IBOutlet UIButton *mixvideo;
-(IBAction)myvideo:(id)sender;
-(IBAction)mixvido:(id)sender;

@property (nonatomic,strong) NSArray *JSONARRAY;
@property (nonatomic,strong) NSMutableArray *playlistARRAY;
@property (nonatomic,strong) NSMutableArray *favPlaylistARRAY;


-(void)retrievedata;

-(void)retrievedataFav;

@property (strong, nonatomic) IBOutlet UITableView *playlistTableView;



@property (strong) NSManagedObject *downloads;
@end
