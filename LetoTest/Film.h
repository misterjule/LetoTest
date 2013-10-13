//
//  Film.h
//  LetoTest
//
//  Created by Julien on 13/10/2013.
//  Copyright (c) 2013 Julien Claverie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Film : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSString *rating;

@end
