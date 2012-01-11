#import "PlaceListViewController.h"


@implementation PlaceListViewController

@synthesize places = _places;

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.places = [FlickrFetcher topPlaces];
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top";
    
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    
    NSDictionary *place = [self.places objectAtIndex:[indexPath row]];
    
    NSArray *placenames = [[place objectForKey:@"_content"] 
                           componentsSeparatedByString:@", "];
    
    cell.textLabel.text = [placenames objectAtIndex:0];
    
    NSString *subtitle = @"Unknown";
    
    if ([placenames count]>=2)
        subtitle = [placenames objectAtIndex:1];
    
    if ([placenames count]>=3)
        subtitle = [NSString stringWithFormat:@"%@, %@",subtitle,
                    [placenames objectAtIndex:2]];
    
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSAssert([sender isKindOfClass:[UITableViewCell class]],@"ERROR: ...");
    
    if (![segue.destinationViewController 
         respondsToSelector:@selector(setPlace:)])
        return;
        
    NSDictionary *thePlace = [self.places objectAtIndex:
                              [[self.tableView indexPathForCell:sender] row]]; 
    
    [(PhotoTableViewController *) segue.destinationViewController 
     setPlace:thePlace];

}

@end
