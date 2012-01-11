#import "RecentPhotoTableViewController.h"

@implementation RecentPhotoTableViewController

@synthesize photos = _photos;

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

#define MAX_RESULTS 50

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSLog(@"PhotoTableViewController numberOfSectionsInTableView:");
    
    self.photos=[[[NSUserDefaults standardUserDefaults] 
                  arrayForKey:@"recents"] copy];
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo cell 2";
    
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *photo = [self.photos objectAtIndex:[indexPath row]];
    
    NSString *title = [photo objectForKey:@"title"];
    NSString *subtitle = [[photo objectForKey:@"description"] 
                          objectForKey:@"_content"];    
    if ([title length]==0)
    {
        if ([subtitle length]>0)
        {
            title = subtitle;
            subtitle = nil;
        }
        else
            title = @"Unknown";       
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}

#define MAX_RECENT_PHOTOS 50

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"PhotoTableViewController prepareForSegue:");
    
    NSURL *picURL;
    
    NSAssert([sender isKindOfClass:[UITableViewCell class]],
             @"ERROR: Unexpected class");
    
    NSDictionary *photo = [self.photos objectAtIndex:
                           [[self.tableView indexPathForCell:sender] row]];
        
    picURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    
    [(ImageViewController *)segue.destinationViewController setImageURL:picURL];
    
    [[(ImageViewController *)segue.destinationViewController navigationItem] 
     setTitle:[[sender textLabel] text]]; 
    
}

@end
