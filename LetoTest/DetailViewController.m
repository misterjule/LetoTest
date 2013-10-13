//
//  DetailViewController.m
//  LetoTest
//
//  Created by Julien on 13/10/2013.
//  Copyright (c) 2013 Julien Claverie. All rights reserved.
//

#import "DetailViewController.h"

#import "Film.h"

@interface DetailViewController () {
	IBOutlet UIWebView *_webView;
	UIActivityIndicatorView *_activityIndicator;
}

- (void)configureView;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(Film *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

	if (self.detailItem) {
		
	    self.navigationItem.title = _detailItem.title;
		
		NSURL *url = [NSURL URLWithString:_detailItem.url];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
		
		[_webView loadRequest:request];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	[_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
	[_activityIndicator setHidesWhenStopped:YES];
	
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicator];
	[self navigationItem].rightBarButtonItem = barButton;
	
	[self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[_activityIndicator stopAnimating];
}

@end
