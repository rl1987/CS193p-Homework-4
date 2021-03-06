//
//  ImageViewController.h
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSURL *imageURL;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
