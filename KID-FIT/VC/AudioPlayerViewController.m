//
//  AudioPlayerViewController.m
//  KidFit
//
//  Created by Muhammad Faraz on 25/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "AudioPlayerViewController.h"
#define FaVJSON_URL @"http://mojosol.com/kidfit/webservice/favourites.php"


@interface AudioPlayerViewController (){
    
    MPMediaPlaylist *currentPlaylist_;
    LMMediaPlayerView *playerView_;
    NSArray *musics_;
    NSArray *playlists_;
}

@end

@implementation AudioPlayerViewController{
    UIAlertView *alert;
}

@synthesize  TrackPath,PlayerView,subtitle,TrackTitle,TrackID,musicType,TrackType,isUrl,TrackExtention;
UIAlertView *allert;
- (void)viewDidLoad

{
    [super viewDidLoad];
    
    self.subtitle.text = TrackTitle;
    self.title = TrackTitle;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //		NSURL *path = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"mp4"];
        //		LMMediaItem *item = [[LMMediaItem alloc] initWithInfo:@{LMMediaItemInfoURLKey:path, LMMediaItemInfoContentTypeKey:@(LMMediaItemContentTypeVideo)}];
        //		item.title = @"sample.mp4";
        //		[playerView_.mediaPlayer addMedia:item];
        //		path = [[NSBundle mainBundle] URLForResource:@"IMG_2380" withExtension:@"MOV"];
        //		item = [[LMMediaItem alloc] initWithInfo:@{LMMediaItemInfoURLKey:path, LMMediaItemInfoContentTypeKey:@(LMMediaItemContentTypeVideo)}];
        //		item.title = @"IMG_2380.MOV";
        
        if (currentPlaylist_) {
            musics_ = [currentPlaylist_ items];
            self.title = [currentPlaylist_ valueForProperty:MPMediaPlaylistPropertyName];
        }
        else {
            MPMediaQuery *q = [[MPMediaQuery alloc] init];
            musics_ = [q items];
#if !__has_feature(objc_arc)
            [q release];
#endif
            playlists_ = [[MPMediaQuery playlistsQuery] collections];
        }
        playerView_ = [LMMediaPlayerView sharedPlayerView];
        playerView_.delegate = self;
        [playerView_ setBluredUserInterface:YES visualEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [playerView_ setBluredUserInterface:NO visualEffect:nil];

        if(!isUrl){
        LMMediaItem *item1 = [[LMMediaItem alloc] initWithInfo:@{
                                                                 LMMediaItemInfoURLKey:[NSURL URLWithString:TrackPath],
                                                                 LMMediaItemInfoContentTypeKey:@(LMMediaItemContentTypeVideo)
                                                                 }];
        
        
        [playerView_.mediaPlayer addMedia:item1];
        }else{
            
         
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *documentsDirectory = [paths objectAtIndex:0];
//            NSString *path = [documentsDirectory stringByAppendingPathComponent:TrackPath];
//            
////            		NSURL *path = [[NSBundle mainBundle] URLForResource:TrackPath withExtension:TrackExtention];
//            NSLog(@"track path %@",path);
            TrackPath = [TrackPath stringByReplacingOccurrencesOfString:@"^" withString:@"/"];
             NSLog(@"track path %@",TrackPath);
            LMMediaItem *item1 = [[LMMediaItem alloc] initWithInfo:@{LMMediaItemInfoURLKey:[NSURL URLWithString:TrackPath], LMMediaItemInfoContentTypeKey:@(LMMediaItemContentTypeVideo)}];
            		//item1.title = TrackTitle;
            
            [playerView_.mediaPlayer addMedia:item1];

        }
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            
            //
            playerView_.delegate = self;
            
            //  PlayerView_
            UIView *baseView = [[UIView alloc] initWithFrame:playerView_.frame];
            //   baseView.backgroundColor = [UIColor blackColor];
            [baseView addSubview:playerView_];
            // [playerView_.artworkImageView_ setImage:[UIImage imageNamed:@"musicbg.jpg"]];
            [self.PlayerView addSubview:baseView];

            [playerView_.mediaPlayer play];
            [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
        });
#if !__has_feature(objc_arc)
        [item1 release];
#endif
    });
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{

        if([self.TrackType isEqualToString:@"2"])
        {
            musicType.hidden = YES;
        }
        else
             musicType.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    
    alert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    
    // playerView_=playerView_;
    [self.tabBarController.tabBar setHidden:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [playerView_.mediaPlayer removeAllMediaInQueue];
    
   // [playerView_ ];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self.tabBarController.tabBar setHidden:NO];
    //  [self resignFirstResponder];
    
 //   [playerView_.artworkImageView_ setImage:[UIImage imageNamed:@"musicbg.jpg"]];
    // [playerView_ ]
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning


{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)mediaPlayerViewWillStartPlaying:(LMMediaPlayerView *)playerView media:(LMMediaItem *)media
{
    return YES;
}
-(void)addFav

{
    allert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [allert show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        
        
        NSString *savedValue = [ preferences
                                stringForKey:@"user_id"];
        NSString *post =[[NSString alloc] initWithFormat:@"user_id=%@&track_id=%@&save=1",savedValue,TrackID];
        
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
                
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    [allert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
                    
                    
                });
                
            }
            else
                
            {
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    [allert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
                    
                    
                });
                [self.BtnIcon setBackgroundImage:[UIImage imageNamed:@"favicontrans.png"] forState:UIControlStateNormal];
             
                check = false;


                NSString *error_msg = (NSString *) jsonData[@"error_message"];
            }
            
        }
        else
        {
            //if (error) NSLog(@"Error: %@", error);
        }
        
    });
}
-(void)deleteFav

{
    allert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [allert show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        
        
        NSString *savedValue = [ preferences
                                stringForKey:@"user_id"];
        
NSString *post =[[NSString alloc] initWithFormat:@"user_id=%@&track_id=%@&save=0",savedValue,TrackID];
        
        
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
                
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    [allert dismissWithClickedButtonIndex:allert.cancelButtonIndex animated:YES];
                    
                });
                
            }
            else
                
            {
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    [allert dismissWithClickedButtonIndex:allert.cancelButtonIndex animated:YES];
                    
                });

                NSString *error_msg = (NSString *) jsonData[@"error_message"];
                  [self.BtnIcon setBackgroundImage:[UIImage imageNamed:@"faviconred.png"] forState:UIControlStateNormal];
                   check=true;
            }
            
        }
        else
        {
            //if (error) NSLog(@"Error: %@", error);
        }
            
    });
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlTogglePlayPause: {
                if ([playerView_.mediaPlayer playbackState] == LMMediaPlaybackStatePlaying) {
                    [playerView_.mediaPlayer pause];
                }
                else if ([playerView_.mediaPlayer playbackState] == LMMediaPlaybackStatePaused || [playerView_.mediaPlayer playbackState] == LMMediaPlaybackStateStopped) {
                    [playerView_.mediaPlayer play];
                }
            } break;
            case UIEventSubtypeRemoteControlPreviousTrack: {
                [playerView_.mediaPlayer playPreviousMedia];
            } break;
            case UIEventSubtypeRemoteControlNextTrack: {
                [playerView_.mediaPlayer playNextMedia];
            } break;
            default:
                break;
        }
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
bool check=false;
- (IBAction)changeIcon:(id)sender {
    
    if (!check) {
        [self.BtnIcon setBackgroundImage:[UIImage imageNamed:@"faviconred.png"] forState:UIControlStateNormal];
        
        [self addFav];
        check=true;
        
    }
    else
    {
        [self.BtnIcon setBackgroundImage:[UIImage imageNamed:@"favicontrans.png"] forState:UIControlStateNormal];
        [self deleteFav];
        check = false;
    }
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [allert dismissWithClickedButtonIndex:allert.cancelButtonIndex animated:YES];
    
}


@end
