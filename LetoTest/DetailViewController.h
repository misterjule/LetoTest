//
//  DetailViewController.h
//  LetoTest
//
//  Created by Julien on 13/10/2013.
//  Copyright (c) 2013 Julien Claverie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
