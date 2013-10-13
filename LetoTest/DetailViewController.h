//
//  DetailViewController.h
//  LetoTest
//
//  Created by Julien on 13/10/2013.
//  Copyright (c) 2013 Julien Claverie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Film;

@interface DetailViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) Film *detailItem;

@end
