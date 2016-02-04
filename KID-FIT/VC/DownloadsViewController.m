//
//  DownloadsViewController.m
//  KidFit
//
//  Created by Muhammad Faraz on 24/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "DownloadsViewController.h"
#import "SWRevealViewController.h"
#import <CoreData/CoreData.h>
#import "tracksTableViewCell.h"
#import "AudioPlayerViewController.h"


@interface DownloadsViewController ()

@property (strong) NSMutableArray *downloads;

@property(nonatomic,strong) NSString *selectedTrackPath,*selectedTrackTitle,*selectedTrackid,*selectedTrackType;

@end

@implementation DownloadsViewController


tracksTableViewCell *dcell;

- (void)viewDidLoad

{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"bg.jpg"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.frame=CGRectMake(150, 150, 16, 16);
    
    [alert show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Downloads"];
    self.downloads = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
            [self.tableView reloadData];
        });

    
    });
                   [[self navigationController] setNavigationBarHidden:NO animated:YES];

    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.downloads.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(dcell)
        return dcell.frame.size.height;
    else
        return [indexPath row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    NSManagedObject *history = [self.downloads objectAtIndex:indexPath.row];
    static NSString *simpleTableIdentifier = @" mtracksTableViewCell";
    
    dcell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(dcell == nil){
        dcell = [tracksTableViewCell tracksTableViewCell];
    }
    dcell.backgroundColor = dcell.contentView.backgroundColor;
    
    //cell.textLabel.text = playliscatobject.PreMixMusCatid;
    dcell.titleTrack.text = [NSString stringWithFormat:@"%@",[history valueForKey:@"nametrack"]];
    dcell.authurName.text =[NSString stringWithFormat:@"by %@",[history valueForKey:@"nameauther"]];
    
    if ([[history valueForKey:@"track_type"] isEqualToString:@"1"]) {
        [dcell.musicThumbnail setImage:[UIImage imageNamed:@"musicimgmed.jpg"]];
    }
    else
        [dcell.musicThumbnail setImage:[UIImage imageNamed:@"videoimgmed.jpg"]];
    return dcell;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSManagedObject *history = [self.downloads objectAtIndex:indexPath.row];
    
    self.selectedTrackPath =[history valueForKey:@"path"];
    self.selectedTrackTitle=[history valueForKey:@"nametrack"];
    self.selectedTrackid  = [history valueForKey:@"trackid"];
    self.selectedTrackType  = [history valueForKey:@"track_type"];

    
  
    [self performNavigation];
    
    
    
}
- (void)performNavigation

{
  
    UIStoryboard *storyboard ;
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main~ipad" bundle:nil];
        
    }
    else
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    

    AudioPlayerViewController *venueDetail = [storyboard instantiateViewControllerWithIdentifier:@"audioPlayerController"];
    venueDetail.TrackPath = self.selectedTrackPath;
    venueDetail.TrackTitle  = self.selectedTrackTitle;
    venueDetail.TrackID  = self.selectedTrackid;
    if ([self.selectedTrackType isEqualToString:@"1"]) {
       
        venueDetail.TrackType = @"1";

    }
    else
        venueDetail.TrackType = @"2";

        
    
    [self.navigationController pushViewController:venueDetail animated:YES];
}



@end
