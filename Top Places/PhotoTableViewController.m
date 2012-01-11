#import "PhotoTableViewController.h"


@implementation PhotoTableViewController

@synthesize photos = _photos;
@synthesize place = _place;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

#define MAX_RESULTS 50

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSLog(@"PhotoTableViewController numberOfSectionsInTableView:");

    self.photos = [FlickrFetcher photosInPlace:self.place 
                                    maxResults:MAX_RESULTS];
        
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
