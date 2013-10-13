//
//  AppDelegate.m
//  LetoTest
//
//  Created by Julien on 13/10/2013.
//  Copyright (c) 2013 Julien Claverie. All rights reserved.
//

//	I wish I had time to add a button to select sorting by alphabetical order or by rotten tomatoes score
//	and also I didn't have time to show the score and rating on the UITableViewCell

#import "AppDelegate.h"

#import "TBXML.h"
#import "TBXML+HTTP.h"
#import "Film.h"
#import "SBJson.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	
//	// Load XML at startup
//	[self loadURL];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadURL) name:@"RefreshFilms" object:nil];
	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Network & Parsing

- (void)loadURL {
    
    // Create a success block to be called when the asyn request completes
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
		
		__block NSError *error = nil;
        
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement) {
			
			if (!jsonParser) {
				jsonParser = [[SBJsonParser alloc] init];
			}
			
			NSMutableArray *filmArray = [NSMutableArray array];
			
			[TBXML iterateElementsForQuery:@"entry" fromElement:tbxml.rootXMLElement withBlock:^(TBXMLElement *anElement) {
				
				// If an error occured, log it
				if (error) {
					NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
				} else {
					
					TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:anElement];
					TBXMLElement *content = [TBXML childElementNamed:@"content" parentElement:anElement];
					TBXMLElement *link = [TBXML childElementNamed:@"link" parentElement:anElement];
					
					TBXMLElement *media = [TBXML childElementNamed:@"media:content" parentElement:link];
					TBXMLElement *image = [TBXML childElementNamed:@"media:thumbnail" parentElement:media];
					
					Film *film = [[Film alloc] init];
					film.title = [TBXML textForElement:title];
					film.desc = [TBXML textForElement:content];
					film.url = [TBXML valueOfAttributeNamed:@"href" forElement:link];
					film.imageURL = [TBXML valueOfAttributeNamed:@"url" forElement:image];
					
					//NSLog(@"Title: %@", film.title);
					//NSLog(@"Image: %@", film.imageURL);
					
					[filmArray addObject:film];
					
					// Download the Rotten Tomatoes Score asynchronously
					NSString *urlString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=qrbt5gajqa75qutk6mftdjvk&q=%@&page_limit=1", [film.title stringByReplacingOccurrencesOfString:@" " withString:@"+"]]; // Added page_limit to download only the first movie and also we need to escape the space charater and replace it by "+"
					
					//NSLog(@"URL: %@", [NSURL URLWithString:urlString]);
					
					[self downloadJSONWithURL:[NSURL URLWithString:urlString] completionBlock:^(BOOL succeeded, NSData *json) {
						if (succeeded) {
							
							//NSLog(@"%@", [NSString stringWithUTF8String:[json bytes]]);
							
							NSDictionary *jsonObjects = [jsonParser objectWithData:json];
							//NSLog(@"Objects: %@", jsonObjects);
							NSDictionary *movie = [((NSArray *)jsonObjects[@"movies"]) objectAtIndex:0];
							NSDictionary *ratings = movie[@"ratings"];
							
							film.score = ratings[@"critics_score"];
							film.rating = ratings[@"critics_rating"];
							
							NSLog(@"Score: %@", film.score);
							NSLog(@"Rating: %@", film.rating);
						}
					}];
				}
			}];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"FilmArray" object:filmArray];
		}
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
	// Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
	tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://feeds.bbc.co.uk/iplayer/categories/films/tv/list"]
                               success:successBlock
                               failure:failureBlock];
}

// Copied and modified from downloadImageWithURL in MasterViewController
- (void)downloadJSONWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSData *json))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
								   //NSString *json = [NSString stringWithUTF8String:[data bytes]];
								   completionBlock(YES, data);
							   } else {
								   completionBlock(NO, nil);
							   }
                           }];
}

@end
