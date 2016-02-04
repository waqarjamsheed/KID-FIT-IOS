//
//  mixVideoPlayListViewController.m
//  KidFit
//
//  Created by pclink on 11/27/15.
//  Copyright (c) 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "mixVideoPlayListViewController.h"
#import "PreMixMusPlay.h"
#import "VideoPlayListViewController.h"
#import "playListTableViewCell.h"

#define JSON_URL @"http://mojosol.com/kidfit/webservice/playlist.php"

@interface mixVideoPlayListViewController ()
@property(nonatomic,strong)PreMixMusPlay *mSelected;

@end

@implementation mixVideoPlayListViewController

@synthesize JSONARRAY,playlistARRAY,playlistTableView,catID,filteredArrayList,SearchBar;
playListTableViewCell *pvvcell ;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
        self.mSelected = self.filteredArrayList[indexPath.row];    }
    else {
        self.mSelected = self.playlistARRAY[indexPath.row];
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
    static NSString *simpleTableIdentifier = @"playListCell";
    
    pvvcell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(pvvcell == nil){
        pvvcell = [playListTableViewCell tracksTableViewCell];
    }
    pvvcell.backgroundColor = pvvcell.contentView.backgroundColor;
    
    PreMixMusPlay *playlisMixobject;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        playlisMixobject = [filteredArrayList objectAtIndex:indexPath.row];
    }
    else
    {
        playlisMixobject = [playlistARRAY objectAtIndex:indexPath.row];
    }
    
    //cell.textLabel.text = playliscatobject.PreMixMusCatid;
    pvvcell.mTitle.text = playlisMixobject.PreMixMusPlayname;
    [pvvcell.mImageView setImage:[UIImage imageNamed:@"videoimgmed.jpg"]];
    
    pvvcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return pvvcell;
}

- (void)performNavigation
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoPlayListViewController *venueDetail = [storyboard instantiateViewControllerWithIdentifier:@"videoTrackViewController"];
    venueDetail.playlistID= self.mSelected.PreMixMusPlayid;
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

-(void)retrievedata
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString *post =[[NSString alloc] initWithFormat:@"cat_id=%@",catID];
        
        
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
                        NSString *Id =data[@"ap_id"];
                        NSString *Name =data[@"ap_name"];
                        [playlistARRAY addObject:[[PreMixMusPlay alloc]initwithPlayList:Id playlistName:Name]];
                        i++;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    
                    [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
                    
                    [self.playlistTableView reloadData];
                });
                
            }
            else
                
            {
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
                    [self.playlistTableView reloadData];
                });
                
                NSString *error_msg = (NSString *) jsonData[@"error_message"];
            }
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
                [self.playlistTableView reloadData];
            });
            
            //if (error) NSLog(@"Error: %@", error);
        }
        filteredArrayList = [NSMutableArray arrayWithCapacity:[playlistARRAY count]];
    });
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope.
    
    // Remove all objects from the filtered search array
    [self.filteredArrayList removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.PreMixMusPlayname contains[c] %@",searchText];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if(pvvcell)
//        return pvvcell.frame.size.height;
//    else
//        return [indexPath row];
   //  return UITableViewAutomaticDimension;
      return 74;
}


#pragma mark - Search Button

- (IBAction)goToSearch:(id)sender
{
    // If you're worried that your users might not catch on to the fact that a search bar is available if they scroll to reveal it, a search icon will help them
    // Note that if you didn't hide your search bar, you should probably not include this, as it would be redundant
    [SearchBar becomeFirstResponder];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
