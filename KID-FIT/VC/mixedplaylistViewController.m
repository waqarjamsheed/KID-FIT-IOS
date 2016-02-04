//
//  mixedplaylistViewController.m
//  KidFit
//
//  Created by Muhammad Faraz on 24/11/2015.
//  Copyright © 2015 Mojo Solutions Services (Pvt) Ltd. All rights reserved.
//

#import "mixedplaylistViewController.h"
#import "premixplaylist.h"
#import "PreMixMusCat.h"
#import "categoryTableViewCell.h"
#import "PlaylistViewController.h"


#define JSON_URL @"http://mojosol.com/kidfit/webservice/categories.php"

@interface mixedplaylistViewController ()
@property(nonatomic,strong)PreMixMusCat *mSelectedCat;
@end

@implementation mixedplaylistViewController


@synthesize JSONARRAY,playlistARRAY,mixplaylistTableView,filteredArrayList,SearchBar;



- (void)viewDidLoad

{
    [super viewDidLoad];
    [SearchBar setShowsScopeBar:NO];
    [SearchBar sizeToFit];
    [SearchBar setTintColor:[UIColor whiteColor]];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    [tempImageView setFrame:self.mixplaylistTableView.frame];
    
    self.mixplaylistTableView.backgroundView = tempImageView;
    
    self.mixplaylistTableView.delegate = self;
    self.mixplaylistTableView.dataSource = self;
    
//    CGRect newBounds = [[self mixplaylistTableView] bounds];
//    newBounds.origin.y = newBounds.origin.y + SearchBar.bounds.size.height;
//    [[self mixplaylistTableView] setBounds:newBounds];
    
    [self.searchDisplayController.searchResultsTableView setBackgroundView:nil];
    //  self.searchDisplayController.searchResultsTableView.backgroundView =tempImageView;
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor blackColor]];
    
    
    // Hide the search bar until user scrolls up
    // Do any additional setup after loading the view.
    
    [self retrievedata];
}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [filteredArrayList count];
    }
    else
        return playlistARRAY.count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(tableView  == self.searchDisplayController.searchResultsTableView) {
        self.mSelectedCat = self.filteredArrayList[indexPath.row];    }
    else {
        self.mSelectedCat = self.playlistARRAY[indexPath.row];
    }
    
    [self performNavigation];
    //   self.selected = self.nearbyVenues[indexPath.row];
    // [self performSegueWithIdentifier:@"detail" sender:self.view];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *simpleTableIdentifier = @"categoryCell";
    
    categoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil){
        cell = [categoryTableViewCell tracksTableViewCell];
    }
    cell.backgroundColor = cell.contentView.backgroundColor;
    
    PreMixMusCat *playliscatobject;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        playliscatobject = [filteredArrayList objectAtIndex:indexPath.row];
    }
    else
    {
        playliscatobject = [playlistARRAY objectAtIndex:indexPath.row];
    }
    
    
    //cell.textLabel.text = playliscatobject.PreMixMusCatid;
    cell.textLabel.text = playliscatobject.PreMixMusCatname;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//
//{
//    if ([[segue identifier]isEqualToString:@"detail"])
//
//    {
//        NSIndexPath *indexpath = [self.mixplaylistTableView indexPathForSelectedRow];
//        PreMixMusCat *object =[playlistARRAY objectAtIndex:indexpath.row];
//        PlaylistViewController *vc = [segue destinationViewController];
//            [vc setCatId:object.PreMixMusCatid];
//    }
//}


- (void)performNavigation

{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlaylistViewController *venueDetail = [storyboard instantiateViewControllerWithIdentifier:@"preMixedCat"];
    venueDetail.title =self.mSelectedCat.PreMixMusCatname;
    venueDetail.catID = self.mSelectedCat.PreMixMusCatid;
    [self.navigationController pushViewController:venueDetail animated:YES];
}


-(void)retrievedata
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"Please Wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSURL *url = [NSURL URLWithString:JSON_URL ];
        NSData *data =[NSData dataWithContentsOfURL:url];
        
        JSONARRAY = [[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil] valueForKey:@"data"];
        
        playlistARRAY=[[NSMutableArray alloc]init];
        
        int i = 0;
        for (NSDictionary *data in JSONARRAY){
            if(JSONARRAY.count!=i+1){
                NSString *catId =data[@"cat_id"];
                NSString *catName =data[@"cat_name"];
                [playlistARRAY addObject:[[PreMixMusCat alloc]initwithPlayListCat:catId catName:catName]];
                i++;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
            
            [self.mixplaylistTableView reloadData];
        });
        filteredArrayList = [NSMutableArray arrayWithCapacity:[playlistARRAY count]];
    });
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope.
    
    // Remove all objects from the filtered search array
    [self.filteredArrayList removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.PreMixMusCatname contains[c] %@",searchText];
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




@end
