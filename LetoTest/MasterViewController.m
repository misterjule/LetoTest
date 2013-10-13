//
//  MasterViewController.m
//  LetoTest
//
//  Created by Julien on 13/10/2013.
//  Copyright (c) 2013 Julien Claverie. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Film.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Register to receive the new array of films
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupNewObjects:) name:@"FilmArray" object:nil];
	
	// Add a refresh control to the top of the table view (aka pull to refresh)
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refreshFilms) forControlEvents:UIControlEventValueChanged];
	self.refreshControl = refreshControl;
	
	// Refresh the list of films
	[self.refreshControl beginRefreshing];
	[self refreshFilms];
	
//	self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//	self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	// Not used anymore to release objects since ARC, but needed to removeObserver from NotificationCentre
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
 */

#pragma mark Data Source and Update

- (void)setupNewObjects:(NSNotification *)notice
{
	// Make sure we receive our Array of films
	if ([[notice object] isKindOfClass:[NSMutableArray class]]) {
		
		NSMutableArray *array = [notice object];
		
//		// Sort the array by title alphabetically
//		NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
//		[array sortUsingDescriptors:@[sortDesc]];
		
		// Sort by rotten tomatoes score
		NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
		[array sortUsingDescriptors:@[sortDesc]];
		
		_objects = nil;
		_objects = array;
		
		[self updateTable];
	}
}

- (void)updateTable
{
	[self.tableView reloadData];
	
	[self.refreshControl endRefreshing];
}

- (void)refreshFilms
{
	// Sends notification to AppDelegate to reload the film list from BBC
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshFilms" object:nil];
}

#pragma mark Thumbnail image download

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
								   UIImage *image = [[UIImage alloc] initWithData:data];
								   completionBlock(YES, image);
							   } else {
								   completionBlock(NO, nil);
							   }
                           }];
}

// To resize the image and make it look good in the cell
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newImage;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

	Film *object = _objects[indexPath.row];
	cell.textLabel.text = [object title];
	
	if (object.image) {
        cell.imageView.image = object.image;
    } else {
        // set default user image while image is being downloaded
        cell.imageView.image = [UIImage imageNamed:@"video2.png"];
		
        // download the image asynchronously
        [self downloadImageWithURL:[NSURL URLWithString:object.imageURL] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
				// cache the image for use later (when scrolling up)
                object.image = [self imageWithImage:image scaledToSize:CGSizeMake(57, 32)];
				
                // change the image in the cell
                cell.imageView.image = object.image;
				
				[cell setNeedsLayout];
			}
        }];
    }
	
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
 */

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
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Film *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
