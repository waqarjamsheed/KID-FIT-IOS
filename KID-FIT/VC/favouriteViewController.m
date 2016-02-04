//
//  favouriteViewController.m
//  KidFit
//
//  Created by Muhammad Faraz on 24/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "favouriteViewController.h"
#import "AllTracks.h"
#import "FavMusVid.h"
#import "tracksTableViewCell.h"
#import "AudioPlayerViewController.h"
#define JSON_URL @"http://mojosol.com/kidfit/webservice/tracks.php"
#define FaVJSON_URL @"http://mojosol.com/kidfit/webservice/favourites.php"

@interface favouriteViewController ()
@property(nonatomic,strong) AllTracks *selected;
@property(nonatomic,strong) FavMusVid *selectedFav;

@end

@implementation favouriteViewController

//bool favBtn,allListBtn;

@synthesize JSONARRAY,playlistARRAY,playlistTableView,favPlaylistARRAY;

tracksTableViewCell *fpcell;
UIAlertView *favTalert;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.myvideo setBackgroundImage:[UIImage imageNamed:@"pressed_btn.png"] forState:UIControlStateNormal];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    [tempImageView setFrame:self.playlistTableView.frame];
    
    self.playlistTableView.backgroundView = tempImageView;
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"bg.jpg"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self retrievedataFav];
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
    
    
    self.selected = self.playlistARRAY[indexPath.row];
    [self performNavigation];
    
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
    
    //   self.selected = self.nearbyVenues[indexPath.row];
    // [self performSegueWithIdentifier:@"detail" sender:self.view];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return playlistARRAY.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *simpleTableIdentifier = @" mtracksTableViewCell";
    
        fpcell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(fpcell == nil){
        fpcell = [tracksTableViewCell tracksTableViewCell];
    }
        fpcell.backgroundColor = fpcell.contentView.backgroundColor;
    
    
    
    AllTracks *playlisMixobject;
    playlisMixobject = [playlistARRAY objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = playliscatobject.PreMixMusCatid;
    fpcell.titleTrack.text = playlisMixobject.AllTrackstitle;
    fpcell.authurName.text =[NSString stringWithFormat:@"by %@",playlisMixobject.AllTracksartistname];
    //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return fpcell;
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
//    
//    if(fpcell)
//        return fpcell.frame.size.height;
//    else
//        return [indexPath row];

     return 74.0;
}
-(void)retrievedata

{
    favTalert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [favTalert  show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        
        
        NSString *savedValue = [ preferences
                                stringForKey:@"user_id"];
        
        NSString *post =[[NSString alloc] initWithFormat:@"user_id=%@&music_type=1&save=3",savedValue];
        
        
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
                    [favTalert  dismissWithClickedButtonIndex:favTalert .cancelButtonIndex animated:YES];
                    
                    [self.playlistTableView reloadData];
                });
                
            }
            else
                
            {
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    [favTalert  dismissWithClickedButtonIndex:favTalert.cancelButtonIndex animated:YES];
                    [self.playlistTableView reloadData];
                });
                
                NSString *error_msg = (NSString *) jsonData[@"error_message"];
            }
            
        }
        else
        {
            //if (error) NSLog(@"Error: %@", error);
        }
        
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


-(void)retrievedataFav

{
    favTalert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [favTalert  show];
    
    playlistARRAY = [[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        
        
        NSString *savedValue = [ preferences
                                stringForKey:@"user_id"];
        
        NSString *post =[[NSString alloc] initWithFormat:@"user_id=%@&music_type=1&save=3",savedValue];
        
        
        NSLog(@"PostData: %@",post);
        
        NSURL *url=[NSURL URLWithString:FaVJSON_URL];
        
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
                    [favTalert  dismissWithClickedButtonIndex:favTalert.cancelButtonIndex animated:YES];
                    
                    [self.playlistTableView reloadData];
                });
                
            }
            else
                
            {
                
                NSString *error_msg = (NSString *) jsonData[@"error_message"];
            }
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                [favTalert  dismissWithClickedButtonIndex:favTalert.cancelButtonIndex animated:YES];
                [self.playlistTableView reloadData];
            });

            //if (error) NSLog(@"Error: %@", error);
        }
        
    });
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [favTalert  dismissWithClickedButtonIndex:favTalert.cancelButtonIndex animated:YES];
    [self.playlistTableView reloadData];
    
}

-(IBAction)myvideo:(id)sender{
    
    [self.mixvideo setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.myvideo setBackgroundImage:[UIImage imageNamed:@"pressed_btn.png"] forState:UIControlStateNormal];
    [self retrievedataFav];
}


-(IBAction)mixvideo:(id)sender{
    
    
    [self.myvideo setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [self.mixvideo setBackgroundImage:[UIImage imageNamed:@"pressed_btn.png"] forState:UIControlStateNormal];
    [self retrievedata];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:YES];
}

@end
