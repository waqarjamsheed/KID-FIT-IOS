//
//  MZDownloaderViewController.m
//  VDownloader
//
//  Created by Muhammad Zeeshan on 2/13/14.
//  Copyright (c) 2014 Muhammad Zeeshan. All rights reserved.
//

#import "MZDownloadManagerViewController.h"
#import "MZDownloadingCell.h"
#import "AppDelegate.h"
#import "MZUtility.h"
#import "tracksTableViewCell.h"
#import "AudioPlayerViewController.h"
#import "AllTracks.h"
#import "SWRevealViewController.h"

NSString * const kMZDownloadKeyURL = @"URL";
NSString * const kMZDownloadKeyStartTime = @"startTime";
NSString * const kMZDownloadKeyFileName = @"fileName";
NSString * const kMZDownloadKeyProgress = @"progress";
NSString * const kMZDownloadKeyTask = @"downloadTask";
NSString * const kMZDownloadKeyStatus = @"requestStatus";
NSString * const kMZDownloadKeyDetails = @"downloadDetails";
NSString * const kMZDownloadKeyResumeData = @"resumedata";

NSString * const RequestStatusDownloading = @"RequestStatusDownloading";
NSString * const RequestStatusPaused = @"RequestStatusPaused";
NSString * const RequestStatusFailed = @"RequestStatusFailed";

@interface MZDownloadManagerViewController () <NSURLSessionDelegate, UIActionSheetDelegate>
{
    NSIndexPath *selectedIndexPath;
    
    UIActionSheet *actionSheetRetry;
    UIActionSheet *actionSheetPause;
    UIActionSheet *actionSheetStart;
    
    NSMutableArray *downloadedFilesArray;
   
    NSMutableArray *downloadedMyFilesArray;

    
 //   NSIndexPath *selectedIndexPath;
    
    NSFileManager *fileManger;

}
@property(nonatomic,strong) AllTracks *selected;
@end

@implementation MZDownloadManagerViewController
@synthesize downloadingArray,bgDownloadTableView,sessionManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    actionSheetRetry = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Retry",@"Delete", nil];
    actionSheetPause = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Pause",@"Delete", nil];
    actionSheetStart = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Start",@"Delete", nil];
    
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    [tempImageView setFrame:self.bgDownloadTableView.frame];
    
    self.bgDownloadTableView.backgroundView = tempImageView;

    
    downloadedFilesArray = [[NSMutableArray alloc] init];
    downloadedMyFilesArray = [[NSMutableArray alloc] init];

    
    fileManger = [NSFileManager defaultManager];
    NSError *error;
    
    downloadedFilesArray = [[fileManger contentsOfDirectoryAtPath:fileDest error:&error] mutableCopy];
    
    if([downloadedFilesArray containsObject:@".DS_Store"])
        [downloadedFilesArray removeObject:@".DS_Store"];
    @try {
    for (NSString *downloadFiles in downloadedFilesArray) {
       NSArray *data  = [downloadFiles componentsSeparatedByString:@"|"];
        
        
        if(data.count>1){
        if([data[5] isEqual:@".mp3"]){
            
            NSString *filedest = [NSString stringWithFormat:@"%@|%@|%@|",data[0],data[1],data[2]];
        AllTracks *track = [[AllTracks alloc]initwithAllTracksList:data[2] AllTrackstitle:data[1] AllTrackspath:filedest AllTracksprice:data[4] AllTracksartistname:data[3] AllTracksduration:@"mp3" AllTracksType:@"1" AllTracksPathMatch:downloadFiles];
        [downloadedMyFilesArray addObject:track];
        }
        else{
             NSString *filedest = [NSString stringWithFormat:@"%@|%@|%@|",data[0],data[1],data[2]];
            
            AllTracks *track = [[AllTracks alloc]initwithAllTracksList:data[2] AllTrackstitle:data[1] AllTrackspath:filedest AllTracksprice:data[4] AllTracksartistname:data[3] AllTracksduration:@"mp4" AllTracksType:@"2" AllTracksPathMatch:downloadFiles];
                [downloadedMyFilesArray addObject:track];
        }
        }
    
    
    }
        
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
    
    if(error && error.code != NSFileReadNoSuchFileError)
        [MZUtility showAlertViewWithTitle:kAlertTitle msg:error.localizedDescription];
    else
        [bgDownloadTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinishedNotification:) name:DownloadCompletedNotif object:nil];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - My Methods -
- (NSURLSession *)backgroundSession
{
	static NSURLSession *session = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.iosDevelopment.VDownloader.SimpleBackgroundTransfer.BackgroundSession"];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
	});
	return session;
}
- (NSArray *)tasks
{
    return [self tasksForKeyPath:NSStringFromSelector(_cmd)];
}
- (NSArray *)dataTasks
{
    return [self tasksForKeyPath:NSStringFromSelector(_cmd)];
}
- (NSArray *)uploadTasks
{
    return [self tasksForKeyPath:NSStringFromSelector(_cmd)];
}
- (NSArray *)downloadTasks
{
    return [self tasksForKeyPath:NSStringFromSelector(_cmd)];
}
- (NSArray *)tasksForKeyPath:(NSString *)keyPath
{
    __block NSArray *tasks = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [sessionManager getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(dataTasks))]) {
            tasks = dataTasks;
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(uploadTasks))]) {
            tasks = uploadTasks;
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(downloadTasks))]) {
            tasks = downloadTasks;
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(tasks))]) {
            tasks = [@[dataTasks, uploadTasks, downloadTasks] valueForKeyPath:@"@unionOfArrays.self"];
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return tasks;
}
- (void)addDownloadTask:(NSString *)fileName fileURL:(NSString *)fileURL
{
    NSURL *url = [NSURL URLWithString:fileURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request];
    
    [downloadTask resume];
    
    NSMutableDictionary *downloadInfo = [NSMutableDictionary dictionary];
    [downloadInfo setObject:fileURL forKey:kMZDownloadKeyURL];
    [downloadInfo setObject:fileName forKey:kMZDownloadKeyFileName];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:downloadInfo options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [downloadTask setTaskDescription:jsonString];
    
    [downloadInfo setObject:[NSDate date] forKey:kMZDownloadKeyStartTime];
    [downloadInfo setObject:RequestStatusDownloading forKey:kMZDownloadKeyStatus];
    [downloadInfo setObject:downloadTask forKey:kMZDownloadKeyTask];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:downloadingArray.count inSection:0];
    [downloadingArray addObject:downloadInfo];
    
    [bgDownloadTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    if([self.delegate respondsToSelector:@selector(downloadRequestStarted:)])
        [self.delegate downloadRequestStarted:downloadTask];
}
- (void)populateOtherDownloadTasks
{
    NSArray *downloadTasks = [self downloadTasks];
    
    for(int i=0;i<downloadTasks.count;i++)
    {
        NSURLSessionDownloadTask *downloadTask = [downloadTasks objectAtIndex:i];
        
        NSError *error = nil;
        NSData *taskDescription = [downloadTask.taskDescription dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *downloadInfo = [[NSJSONSerialization JSONObjectWithData:taskDescription options:NSJSONReadingAllowFragments error:&error] mutableCopy];
        
        if(error)
            NSLog(@"Error while retreiving json value: %@",error);
        
        [downloadInfo setObject:downloadTask forKey:kMZDownloadKeyTask];
        [downloadInfo setObject:[NSDate date] forKey:kMZDownloadKeyStartTime];
        
        NSURLSessionTaskState taskState = downloadTask.state;
        if(taskState == NSURLSessionTaskStateRunning)
            [downloadInfo setObject:RequestStatusDownloading forKey:kMZDownloadKeyStatus];
        else if(taskState == NSURLSessionTaskStateSuspended)
            [downloadInfo setObject:RequestStatusPaused forKey:kMZDownloadKeyStatus];
        else
            [downloadInfo setObject:RequestStatusFailed forKey:kMZDownloadKeyStatus];
        
        if(!downloadInfo)
        {
            [downloadTask cancel];
        }
        else
        {
            [self.downloadingArray addObject:downloadInfo];
        }
    }
}
/**Post local notification when all download tasks are finished
 */
- (void)presentNotificationForDownload:(NSString *)fileName
{
    UIApplication *application = [UIApplication sharedApplication];
    UIApplicationState appCurrentState = [application applicationState];
    if(appCurrentState == UIApplicationStateBackground)
    {
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = [NSString stringWithFormat:@"Downloading complete of %@",fileName];
        localNotification.alertAction = @"Background Transfer Download!";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = [application applicationIconBadgeNumber] + 1;
        [application presentLocalNotificationNow:localNotification];
    }
}
#pragma mark - NSURLSession Delegates -
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    for(NSMutableDictionary *downloadDict in downloadingArray)
    {
        if([downloadTask isEqual:[downloadDict objectForKey:kMZDownloadKeyTask]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                float progress = (double)downloadTask.countOfBytesReceived/(double)downloadTask.countOfBytesExpectedToReceive;
                
                NSTimeInterval downloadTime = -1 * [[downloadDict objectForKey:kMZDownloadKeyStartTime] timeIntervalSinceNow];
                
                float speed = totalBytesWritten / downloadTime;
                
                NSInteger indexOfDownloadDict = [downloadingArray indexOfObject:downloadDict];
                NSIndexPath *indexPathToRefresh = [NSIndexPath indexPathForRow:indexOfDownloadDict inSection:0];
                MZDownloadingCell *cell = (MZDownloadingCell *)[bgDownloadTableView cellForRowAtIndexPath:indexPathToRefresh];
                
                [cell.progressDownload setProgress:progress];
                
                NSMutableString *remainingTimeStr = [[NSMutableString alloc] init];
                
                unsigned long long remainingContentLength = totalBytesExpectedToWrite - totalBytesWritten;
                
                int remainingTime = (int)(remainingContentLength / speed);
                int hours = remainingTime / 3600;
                int minutes = (remainingTime - hours * 3600) / 60;
                int seconds = remainingTime - hours * 3600 - minutes * 60;
                
                if(hours>0)
                    [remainingTimeStr appendFormat:@"%d Hours ",hours];
                if(minutes>0)
                    [remainingTimeStr appendFormat:@"%d Min ",minutes];
                if(seconds>0)
                    [remainingTimeStr appendFormat:@"%d sec",seconds];
                
                NSString *fileSizeInUnits = [NSString stringWithFormat:@"%.2f %@",
                                             [MZUtility calculateFileSizeInUnit:(unsigned long long)totalBytesExpectedToWrite],
                                             [MZUtility calculateUnit:(unsigned long long)totalBytesExpectedToWrite]];
                
                NSMutableString *detailLabelText = [NSMutableString stringWithFormat:@"File Size: %@\nDownloaded: %.2f %@ (%.2f%%)\nSpeed: %.2f %@/sec\n",fileSizeInUnits,
                                                    [MZUtility calculateFileSizeInUnit:(unsigned long long)totalBytesWritten],
                                                    [MZUtility calculateUnit:(unsigned long long)totalBytesWritten],progress*100,
                                                    [MZUtility calculateFileSizeInUnit:(unsigned long long) speed],
                                                    [MZUtility calculateUnit:(unsigned long long)speed]
                                                    ];
                
                if(progress == 1.0)
                    [detailLabelText appendFormat:@"Time Left: Please wait..."];
                else
                    [detailLabelText appendFormat:@"Time Left: %@",remainingTimeStr];
                
                [cell.lblDetails setText:detailLabelText];
                
                [downloadDict setObject:[NSString stringWithFormat:@"%f",progress] forKey:kMZDownloadKeyProgress];
                [downloadDict setObject:detailLabelText forKey:kMZDownloadKeyDetails];
            });
            break;
        }
    }
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    for(NSMutableDictionary *downloadInfo in downloadingArray)
    {
        if([[downloadInfo objectForKey:kMZDownloadKeyTask] isEqual:downloadTask])
        {
            NSString *fileName = [downloadInfo objectForKey:kMZDownloadKeyFileName];
            NSString *destinationPath = [fileDest stringByAppendingPathComponent:fileName];
            NSURL *fileURL = [NSURL fileURLWithPath:destinationPath];
            NSLog(@"directory Path = %@",destinationPath);
            
            if (location) {
                NSError *error = nil;
                [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileURL error:&error];
                if (error)
                    [MZUtility showAlertViewWithTitle:kAlertTitle msg:error.localizedDescription];
            }
            
            break;
        }
    }
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSInteger errorReasonNum = [[error.userInfo objectForKey:@"NSURLErrorBackgroundTaskCancelledReasonKey"] integerValue];
    
    if([error.userInfo objectForKey:@"NSURLErrorBackgroundTaskCancelledReasonKey"] &&
       (errorReasonNum == NSURLErrorCancelledReasonUserForceQuitApplication ||
        errorReasonNum == NSURLErrorCancelledReasonBackgroundUpdatesDisabled))
    {
        NSString *taskInfo = task.taskDescription;
        
        NSError *error = nil;
        NSData *taskDescription = [taskInfo dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *taskInfoDict = [[NSJSONSerialization JSONObjectWithData:taskDescription options:NSJSONReadingAllowFragments error:&error] mutableCopy];
        
        if(error)
            NSLog(@"Error while retreiving json value: %@",error);
        
        NSString *fileName = [taskInfoDict objectForKey:kMZDownloadKeyFileName];
        NSString *fileURL = [taskInfoDict objectForKey:kMZDownloadKeyURL];
        
        NSMutableDictionary *downloadInfo = [[NSMutableDictionary alloc] init];
        [downloadInfo setObject:fileName forKey:kMZDownloadKeyFileName];
        [downloadInfo setObject:fileURL forKey:kMZDownloadKeyURL];
        
        NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
        if(resumeData)
            task = [sessionManager downloadTaskWithResumeData:resumeData];
        else
            task = [sessionManager downloadTaskWithURL:[NSURL URLWithString:fileURL]];
        [task setTaskDescription:taskInfo];
        
        [downloadInfo setObject:task forKey:kMZDownloadKeyTask];
        
        [self.downloadingArray addObject:downloadInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bgDownloadTableView reloadData];
            [self dismissAllActionSeets];
        });
        return;
    }
    for(NSMutableDictionary *downloadInfo in downloadingArray)
    {
        if([[downloadInfo objectForKey:kMZDownloadKeyTask] isEqual:task])
        {
            NSInteger indexOfObject = [downloadingArray indexOfObject:downloadInfo];
            
            if(error)
            {
                if(error.code != NSURLErrorCancelled)
                {
                    NSString *taskInfo = task.taskDescription;
                    
                    NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
                    if(resumeData)
                        task = [sessionManager downloadTaskWithResumeData:resumeData];
                    else
                        task = [sessionManager downloadTaskWithURL:[NSURL URLWithString:[downloadInfo objectForKey:kMZDownloadKeyURL]]];
                    [task setTaskDescription:taskInfo];
                    
                    [downloadInfo setObject:RequestStatusFailed forKey:kMZDownloadKeyStatus];
                    [downloadInfo setObject:(NSURLSessionDownloadTask *)task forKey:kMZDownloadKeyTask];
                    
                    [downloadingArray replaceObjectAtIndex:indexOfObject withObject:downloadInfo];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MZUtility showAlertViewWithTitle:kAlertTitle msg:error.localizedDescription];
                        [self.bgDownloadTableView reloadData];
                        [self dismissAllActionSeets];
                    });
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *fileName = [[downloadInfo objectForKey:kMZDownloadKeyFileName] copy];
                    
                    [self presentNotificationForDownload:[downloadInfo objectForKey:kMZDownloadKeyFileName]];
                    
                    [downloadingArray removeObjectAtIndex:indexOfObject];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexOfObject inSection:0];
                    if(indexPath.section==0){
                    [bgDownloadTableView deleteRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    
                    if([self.delegate respondsToSelector:@selector(downloadRequestFinished:)])
                        [self.delegate downloadRequestFinished:fileName];
                    
                    [self dismissAllActionSeets];
                });
            }
            break;
        }
    }
}
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    
    NSLog(@"All tasks are finished");
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Downloading";
    else
        return @"Downloaded";
}

#pragma mark - UITableView Delegates and Datasource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    return downloadingArray.count;
    else
        return downloadedMyFilesArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0)
    return 107;
    else
        return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
    static NSString *cellIdentifier = @"MZDownloadingCell";
    MZDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
     cell.backgroundColor = cell.contentView.backgroundColor;
    [self updateCell:cell forRowAtIndexPath:indexPath];
        return cell;
    }else{
    
        static NSString *simpleTableIdentifier = @" mtracksTableViewCell";
        
        tracksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil){
            cell = [tracksTableViewCell tracksTableViewCell];
        }
        cell.backgroundColor = cell.contentView.backgroundColor;
       
        AllTracks *playlisMixobject;
        
                   playlisMixobject = [downloadedMyFilesArray objectAtIndex:indexPath.row];
        //cell.textLabel.text = playliscatobject.PreMixMusCatid;
        cell.titleTrack.text = playlisMixobject.AllTrackstitle;
        cell.authurName.text =[NSString stringWithFormat:@"by %@",playlisMixobject.AllTracksartistname];
        
        if ([playlisMixobject.AllTracksType isEqualToString:@"1"]) {
            [cell.musicThumbnail setImage:[UIImage imageNamed:@"musicimgmed.jpg"]];
            
        }
        else
            [cell.musicThumbnail setImage:[UIImage imageNamed:@"videoimgmed.jpg"]];
        

        //cell.textLabel.text = playliscatobject.PreMixMusCatid;
   
//        cell.authurName.text =[NSString stringWithFormat:@"by %@",[history valueForKey:@"nameauther"]];
        
//        if ([[history valueForKey:@"track_type"] isEqualToString:@"1"]) {
//            [cell.musicThumbnail setImage:[UIImage imageNamed:@"musicimgmed.jpg"]];
//        }
//        else
//            [cell.musicThumbnail setImage:[UIImage imageNamed:@"videoimgmed.jpg"]];
//    
     return cell;
    }
   
}
- (void)updateCell:(MZDownloadingCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
    NSMutableDictionary *downloadInfoDict = [downloadingArray objectAtIndex:indexPath.row];
    
    NSString *fileName = [downloadInfoDict objectForKey:kMZDownloadKeyFileName];
    
    [cell.lblTitle setText:[NSString stringWithFormat:@"File Title:%@",fileName]];
    [cell.detailTextLabel setText:[downloadInfoDict objectForKey:kMZDownloadKeyDetails]];
    [cell.progressDownload setProgress:[[downloadInfoDict objectForKey:kMZDownloadKeyProgress] floatValue]];
    }
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
    selectedIndexPath = [indexPath copy];
    
    NSMutableDictionary *downloadInfoDict = [downloadingArray objectAtIndex:indexPath.row];
    
    if([[downloadInfoDict objectForKey:kMZDownloadKeyStatus] isEqualToString:RequestStatusPaused])
        [actionSheetStart showFromTabBar:self.tabBarController.tabBar];
    else if([[downloadInfoDict objectForKey:kMZDownloadKeyStatus] isEqualToString:RequestStatusDownloading])
        [actionSheetPause showFromTabBar:self.tabBarController.tabBar];
    else
        [actionSheetRetry showFromTabBar:self.tabBarController.tabBar];
    
    }
    else{
        self.selected = downloadedMyFilesArray[indexPath.row];
    
        [self performNavigation];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UIActionSheet Delegates -
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
        [self pauseOrRetryButtonTappedOnActionSheet];
    else if(buttonIndex == 1)
        [self cancelButtonTappedOnActionSheet];
}
- (void)dismissAllActionSeets
{
    [actionSheetPause dismissWithClickedButtonIndex:2 animated:YES];
    [actionSheetRetry dismissWithClickedButtonIndex:2 animated:YES];
    [actionSheetStart dismissWithClickedButtonIndex:2 animated:YES];
}
#pragma mark - MZDownloadingCell Delegate -
- (IBAction)cancelButtonTappedOnActionSheet
{
    NSIndexPath *indexPath = selectedIndexPath;
    
    NSMutableDictionary *downloadInfo = [downloadingArray objectAtIndex:indexPath.row];
    
    NSURLSessionDownloadTask *downloadTask = [downloadInfo objectForKey:kMZDownloadKeyTask];
    
    [downloadTask cancel];
    
    [downloadingArray removeObjectAtIndex:indexPath.row];
    [bgDownloadTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    if([self.delegate respondsToSelector:@selector(downloadRequestCanceled:)])
        [self.delegate downloadRequestCanceled:downloadTask];
}
- (IBAction)pauseOrRetryButtonTappedOnActionSheet
{
    NSIndexPath *indexPath = selectedIndexPath;
    MZDownloadingCell *cell = (MZDownloadingCell *)[bgDownloadTableView cellForRowAtIndexPath:indexPath];
    
    NSMutableDictionary *downloadInfo = [downloadingArray objectAtIndex:indexPath.row];
    NSURLSessionDownloadTask *downloadTask = [downloadInfo objectForKey:kMZDownloadKeyTask];
    NSString *downloadingStatus = [downloadInfo objectForKey:kMZDownloadKeyStatus];
    
    if([downloadingStatus isEqualToString:RequestStatusDownloading])
    {
        [downloadTask suspend];
        [downloadInfo setObject:RequestStatusPaused forKey:kMZDownloadKeyStatus];
        [downloadInfo setObject:[NSDate date] forKey:kMZDownloadKeyStartTime];
        
        [downloadingArray replaceObjectAtIndex:indexPath.row withObject:downloadInfo];
        [self updateCell:cell forRowAtIndexPath:indexPath];
    }
    else if([downloadingStatus isEqualToString:RequestStatusPaused])
    {
        [downloadTask resume];
        [downloadInfo setObject:RequestStatusDownloading forKey:kMZDownloadKeyStatus];
        
        [downloadingArray replaceObjectAtIndex:indexPath.row withObject:downloadInfo];
        [self updateCell:cell forRowAtIndexPath:indexPath];
    }
    else
    {
        [downloadTask resume];
        [downloadInfo setObject:RequestStatusDownloading forKey:kMZDownloadKeyStatus];
        [downloadInfo setObject:[NSDate date] forKey:kMZDownloadKeyStartTime];
        [downloadInfo setObject:downloadTask forKey:kMZDownloadKeyTask];
        
        [downloadingArray replaceObjectAtIndex:indexPath.row withObject:downloadInfo];
        [self updateCell:cell forRowAtIndexPath:indexPath];
    }
}
#pragma mark - UIInterfaceOrientations -
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (void)downloadFinishedNotification:(NSNotification *)notification
{
    NSString *fileName = notification.object;
    
    NSArray *data  = [fileName componentsSeparatedByString:@"|"];
    
    NSString *filedest = [NSString stringWithFormat:@"%@/%@",fileDest,fileName];
    if(data.count>1){
    if([data[5] isEqual:@".mp3"]){
        AllTracks *track = [[AllTracks alloc]initwithAllTracksList:data[2] AllTrackstitle:data[1] AllTrackspath:filedest AllTracksprice:data[4] AllTracksartistname:data[3] AllTracksduration:@"mp3" AllTracksType:@"1" AllTracksPathMatch:fileName.lastPathComponent];
        [downloadedMyFilesArray addObject:track];
    }
    else{
        AllTracks *track = [[AllTracks alloc]initwithAllTracksList:data[2] AllTrackstitle:data[1] AllTrackspath:filedest AllTracksprice:data[4] AllTracksartistname:data[3] AllTracksduration:@"mp4" AllTracksType:@"2" AllTracksPathMatch:fileName.lastPathComponent];
        [downloadedMyFilesArray addObject:track];
    }
    }
    [bgDownloadTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
//      [bgDownloadTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)performNavigation

{
    
    UIStoryboard *storyboard ;
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ){
        storyboard = [UIStoryboard storyboardWithName:@"Main~ipad" bundle:nil];
        }
    else
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    AudioPlayerViewController *venueDetail = [storyboard instantiateViewControllerWithIdentifier:@"audioPlayerController"];
    
    venueDetail.TrackPath = self.selected.AllTracksprice;
    venueDetail.TrackTitle  = self.selected.AllTrackstitle;
    venueDetail.TrackID  = self.selected.AllTracksid;
     venueDetail.TrackType = self.selected.AllTracksType;
    venueDetail.TrackExtention = self.selected.AllTracksduration;
    venueDetail.isUrl  = true;
    
    
    [self.navigationController pushViewController:venueDetail animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DownloadCompletedNotif object:nil];
}

@end
