//
//  PaidPlayListViewController.m
//  KidFit
//
//  Created by pclink on 11/30/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "PaidPlayListViewController.h"
#import "AllTracks.h"
#import "tracksTableViewCell.h"
#import "AudioPlayerViewController.h"
#define JSON_URL @"http://mojosol.com/kidfit/webservice/audio.php"

@interface PaidPlayListViewController ()
@property(nonatomic,strong) AllTracks *selected;
@end

@implementation PaidPlayListViewController
//
//  TrackPlayListViewController.m
//  KidFit
//
//  Created by pclink on 11/26/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

@synthesize JSONARRAY,playlistARRAY,playlistTableView,playlistID;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    [tempImageView setFrame:self.playlistTableView.frame];
    
    self.playlistTableView.backgroundView = tempImageView;
    
    
//    UIImage *navBackgroundImage = [UIImage imageNamed:@"bg.jpg"];
//    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
//    
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
    
    
//    self.selected = self.playlistARRAY[indexPath.row];
//    [self performNavigation];
//    
//    NSDate *localDate = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"MM/dd/yy";
//    
//    NSString *dateString = [dateFormatter stringFromDate: localDate];
//    
//    
//    
//    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
//    timeFormatter.dateFormat = @"HH:mm:ss";
//    
//    
//    NSString *timeString = [timeFormatter stringFromDate: localDate];
//    NSString *date_time = [NSString stringWithFormat:@"%@ %@",dateString,timeString];
//    
//    NSManagedObjectContext *context = [self managedObjectContext];
//    if (self.downloads) {
//        // Update existing device
//        [self.downloads setValue:date_time forKey:@"date"];
//        [self.downloads setValue:self.selected.AllTracksartistname  forKey:@"nameauther"];
//        [self.downloads setValue:self.selected.AllTrackstitle  forKey:@"nametrack"];
//        [self.downloads setValue:self.selected.AllTrackspath forKey:@"path"];
//        [self.downloads setValue:self.selected.AllTracksid forKey:@"trackid"];
//        
//        
//    } else {
//        // Create a new device
//        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Downloads" inManagedObjectContext:context];
//        
//        [newDevice setValue:date_time forKey:@"date"];
//        [newDevice setValue:self.selected.AllTracksartistname  forKey:@"nameauther"];
//        [newDevice setValue:self.selected.AllTrackstitle  forKey:@"nametrack"];
//        [newDevice setValue:self.selected.AllTrackspath forKey:@"path"];
//        [newDevice setValue:self.selected.AllTracksid forKey:@"trackid"];
//        
//    }
    
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
    
    tracksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil){
        cell = [tracksTableViewCell tracksTableViewCell];
    }
    cell.backgroundColor = cell.contentView.backgroundColor;
    
    AllTracks *playlisMixobject;
    playlisMixobject = [playlistARRAY objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = playliscatobject.PreMixMusCatid;
    cell.titleTrack.text = playlisMixobject.AllTrackstitle;
    cell.authurName.text =[NSString stringWithFormat:@"by %@",playlisMixobject.AllTracksartistname];
    
    //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)performNavigation

{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AudioPlayerViewController *venueDetail = [storyboard instantiateViewControllerWithIdentifier:@"audioPlayerController"];
    venueDetail.TrackPath = self.selected.AllTrackspath;
    venueDetail.TrackTitle  = self.selected.AllTrackstitle;
    venueDetail.TrackID  = self.selected.AllTracksid;
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 75;
//}
-(void)viewWillAppear:(BOOL)animated
{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:YES];
}


-(void)retrievedata

{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//    [alert show];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        
//        NSString *post =[[NSString alloc] initWithFormat:@"ap_id=%@&music_type=1",playlistID];
//        
//        
//        NSLog(@"PostData: %@",post);
//        
//        NSURL *url=[NSURL URLWithString:JSON_URL];
//        
//        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//        
//        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
//        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:url];
//        
//        [request setHTTPMethod:@"POST"];
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPBody:postData];
//        
//        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
//        
//        NSError *error = [[NSError alloc] init];
//        NSHTTPURLResponse *response = nil;
//        
//        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        
//        NSLog(@"Response code: %ld", (long)[response statusCode]);
//        
//        if ([response statusCode] >= 200 && [response statusCode] < 300)
//            
//        {
//            
//            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
//            
//            
//            NSLog(@"Response ==> %@", responseData);
//            
//            NSError *error = nil;
//            NSDictionary *jsonData = [NSJSONSerialization
//                                      JSONObjectWithData:urlData
//                                      options:NSJSONReadingMutableContainers
//                                      error:&error];
//            
//            BOOL success = [jsonData[@"status"] integerValue];
//            NSLog(@"Success: %ld",(long)success);
//            
//            if(success == 1)
//            {
//                
//                JSONARRAY = [[NSJSONSerialization JSONObjectWithData:urlData options:(kNilOptions) error:nil] valueForKey:@"data"];
//                
//                playlistARRAY=[[NSMutableArray alloc]init];
//                
//                int i = 0;
//                for (NSDictionary *data in JSONARRAY){
//                    if(JSONARRAY.count!=i+1){
//                        NSString *trackid = data[@"track_id"];
//                        NSString *tracktitle =data[@"track_title"];
//                        NSString *trackpath =data[@"track_path"];
//                        NSString *trackprice = data[@"track_price"];
//                        NSString *tracksubtitle = data[@"track_subtitle"];
//                        NSString *trackduration = data[@"track_duration"];
//                        NSString *trackstatus = data[@"track_status"];
//                        NSString *trackcreatedate = data[@"track_create_date"];
//                        NSString *artistname =data[@"artist_name"];
//                        NSString *tracktitleidartistname = [NSString stringWithFormat:@"%@%@%@.mp3",tracktitle,trackid ,artistname];
//                        
//                        [playlistARRAY addObject:[[AllTracks alloc]initwithAllTracksList:trackid AllTrackstitle:tracktitle AllTrackspath:trackpath AllTracksprice:trackprice AllTracksartistname:artistname AllTracksduration:trackduration AllTracksType:nil AllTracksPathMatch:nil]];
//                        i++;
//                    }
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{ // 2
//                    [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
//                    [self.playlistTableView reloadData];
//                });
//                
//            }
//            else
//                
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{ // 2
//                    [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
//                    [self.playlistTableView reloadData];
//                });
//                NSString *error_msg = (NSString *) jsonData[@"error_message"];
//            }
//            
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{ // 2
//                [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
//                [self.playlistTableView reloadData];
//            });
//            
//            //if (error) NSLog(@"Error: %@", error);
//        }
//        
//    });
}
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


@end
