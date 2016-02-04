//
//  TrackPlayListViewController.m
//  KidFit
//
//  Created by pclink on 11/26/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "TrackPlayListViewController.h"
#import "AllTracks.h"
#import "tracksTableViewCell.h"
#import "AudioPlayerViewController.h"
#define JSON_URL @"http://mojosol.com/kidfit/webservice/audio.php"

@interface TrackPlayListViewController ()
@property(nonatomic,strong) AllTracks *selected;
@end

@implementation TrackPlayListViewController

@synthesize JSONARRAY,playlistARRAY,playlistTableView,playlistID,filteredArrayList,SearchBar;
tracksTableViewCell *tcell;
UIAlertView *talert;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Don't show the scope bar or cancel button until editing begins
    [SearchBar setShowsScopeBar:NO];
    [SearchBar sizeToFit];
    [SearchBar setTintColor:[UIColor whiteColor]];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    [tempImageView setFrame:self.playlistTableView.frame];
    
    self.playlistTableView.backgroundView = tempImageView;
    
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"bg.jpg"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
//    CGRect newBounds = [[self playlistTableView] bounds];
//    newBounds.origin.y = newBounds.origin.y + SearchBar.bounds.size.height;
//    [[self playlistTableView] setBounds:newBounds];
    
    [self.searchDisplayController.searchResultsTableView setBackgroundView:nil];
    //  self.searchDisplayController.searchResultsTableView.backgroundView =tempImageView;
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor blackColor]];
    
    [self retrievedata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(tableView  == self.searchDisplayController.searchResultsTableView) {
        self.selected = self.filteredArrayList[indexPath.row];    }
    else {
        self.selected = self.playlistARRAY[indexPath.row];
    }
    
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    
    NSString *dateString = [dateFormatter stringFromDate: localDate];
    
    
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    
    
    NSString *timeString = [timeFormatter stringFromDate: localDate];
    NSString *date_time = [NSString stringWithFormat:@"%@ %@",dateString,timeString];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (self.downloads) {
        // Update existing device
        [self.downloads setValue:date_time forKey:@"date"];
        [self.downloads setValue:self.selected.AllTracksartistname  forKey:@"nameauther"];
        [self.downloads setValue:self.selected.AllTrackstitle  forKey:@"nametrack"];
        [self.downloads setValue:self.selected.AllTrackspath forKey:@"path"];
        [self.downloads setValue:self.selected.AllTracksid forKey:@"trackid"];
        [self.downloads setValue:@"1" forKey:@"track_type"];
        
        
        
    } else {
        // Create a new device
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Downloads" inManagedObjectContext:context];
        
        [newDevice setValue:date_time forKey:@"date"];
        [newDevice setValue:self.selected.AllTracksartistname  forKey:@"nameauther"];
        [newDevice setValue:self.selected.AllTrackstitle  forKey:@"nametrack"];
        [newDevice setValue:self.selected.AllTrackspath forKey:@"path"];
        [newDevice setValue:self.selected.AllTracksid forKey:@"trackid"];
        [newDevice setValue:@"1" forKey:@"track_type"];
        
    }
    
    [self performNavigation];
    
    //   self.selected = self.nearbyVenues[indexPath.row];
    // [self performSegueWithIdentifier:@"detail" sender:self.view];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredArrayList count];
    }
    else
        return playlistARRAY.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *simpleTableIdentifier = @" mtracksTableViewCell";
    
     tcell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(tcell == nil){
        tcell = [tracksTableViewCell tracksTableViewCell];
    }
    tcell.backgroundColor = tcell.contentView.backgroundColor;
    
    
    AllTracks *playlisMixobject;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        playlisMixobject = [filteredArrayList objectAtIndex:indexPath.row];
    }
    else
    {
        playlisMixobject = [playlistARRAY objectAtIndex:indexPath.row];
    }
    
    
    
    //cell.textLabel.text = playliscatobject.PreMixMusCatid;
    tcell.titleTrack.text = playlisMixobject.AllTrackstitle;
    tcell.authurName.text =[NSString stringWithFormat:@"by %@",playlisMixobject.AllTracksartistname];
    
    //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return tcell;
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
    venueDetail.TrackPath = self.selected.AllTrackspath;
    venueDetail.TrackTitle  = self.selected.AllTrackstitle;
    venueDetail.TrackID  = self.selected.AllTracksid;
    venueDetail.TrackType = @"1";
    [self.navigationController pushViewController:venueDetail animated:YES];
}



//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//
//{
//    if ([[segue identifier]isEqualToString:@"detail"])
//
//    {
//        NSIndexPath *indexpath = [self.playlistTableView indexPathForSelectedRow];
//        PreMixMusPlay *object =[playlistARRAY objectAtIndex:indexpath.row];
//
//     //   [[segue destinationViewController] getpremixplaylist:object];
//
//    }
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(tcell)
//    return tcell.frame.size.height;
//    else
//        return [indexPath row];
  //  return UITableViewAutomaticDimension+tcell.frame.size.height+40;
      return 74;
}
-(void)retrievedata

{
    talert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [talert show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString *post =[[NSString alloc] initWithFormat:@"ap_id=%@&music_type=1",playlistID];
        
        
        NSLog(@"PostData: %@",post);
        
        NSURL *url=[NSURL URLWithString:JSON_URL];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %ld", (long)[response statusCode]);
        
        if ([response statusCode] >= 200 && [response statusCode] < 300)
            
        {
            
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            
            
            NSLog(@"Response ==> %@", responseData);
            
            NSError *error = nil;
            NSDictionary *jsonData = [NSJSONSerialization
                                      JSONObjectWithData:urlData
                                      options:NSJSONReadingMutableContainers
                                      error:&error];
            
            BOOL success = [jsonData[@"status"] integerValue];
            NSLog(@"Success: %ld",(long)success);
            
            if(success == 1)
            {
                
                JSONARRAY = [[NSJSONSerialization JSONObjectWithData:urlData options:(kNilOptions) error:nil] valueForKey:@"data"];
                
                playlistARRAY=[[NSMutableArray alloc]init];
                
                int i = 0;
                for (NSDictionary *data in JSONARRAY){
                    if(JSONARRAY.count!=i+1){
                        NSString *trackid = data[@"track_id"];
                        NSString *tracktitle =data[@"track_title"];
                        NSString *trackpath =data[@"track_path"];
                        NSString *trackprice = data[@"track_price"];
                        NSString *tracksubtitle = data[@"track_subtitle"];
                        NSString *trackduration = data[@"track_duration"];
                        NSString *trackstatus = data[@"track_status"];
                        NSString *trackcreatedate = data[@"track_create_date"];
                        NSString *artistname =data[@"artist_name"];
                        NSString *tracktitleidartistname = [NSString stringWithFormat:@"%@%@%@.mp3",tracktitle,trackid ,artistname];
                        
                        [playlistARRAY addObject:[[AllTracks alloc]initwithAllTracksList:trackid AllTrackstitle:tracktitle AllTrackspath:trackpath AllTracksprice:trackprice AllTracksartistname:artistname AllTracksduration:trackduration AllTracksType:nil AllTracksPathMatch:nil]];
                        i++;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    [talert dismissWithClickedButtonIndex: talert.cancelButtonIndex animated:YES];
                    [self.playlistTableView reloadData];
                });
                
            }
            else
                
            {
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    [talert dismissWithClickedButtonIndex: talert.cancelButtonIndex animated:YES];
                    [self.playlistTableView reloadData];
                });
                NSString *error_msg = (NSString *) jsonData[@"error_message"];
            }
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                [talert dismissWithClickedButtonIndex:talert.cancelButtonIndex animated:YES];
                [self.playlistTableView reloadData];
            });
            
            //if (error) NSLog(@"Error: %@", error);
        }
        filteredArrayList = [NSMutableArray arrayWithCapacity:[playlistARRAY count]];
    });
    
}
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope.
    
    // Remove all objects from the filtered search array
    [self.filteredArrayList removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.AllTrackstitle contains[c] %@",searchText];
    NSArray *tempArray = [playlistARRAY filteredArrayUsingPredicate:predicate];
    
    filteredArrayList = [NSMutableArray arrayWithArray:tempArray];
}


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - Search Button

- (IBAction)goToSearch:(id)sender
{
    // If you're worried that your users might not catch on to the fact that a search bar is available if they scroll to reveal it, a search icon will help them
    // Note that if you didn't hide your search bar, you should probably not include this, as it would be redundant
    
    [SearchBar becomeFirstResponder];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [talert dismissWithClickedButtonIndex:talert.cancelButtonIndex animated:YES];
    [self.playlistTableView reloadData];

}

@end
