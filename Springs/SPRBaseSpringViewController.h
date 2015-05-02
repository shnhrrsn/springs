//
//  SPRBaseSpringViewController.h
//  Springs
//
//  Created by Shaun Harrison on 5/2/15.
//  Copyright (c) 2015 shnhrrsn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRBaseSpringViewController : UIViewController

- (void)addSliderWithTitle:(NSString*)title minimumValue:(float)minimumValue maximumValue:(float)maximumValue initialValue:(float)initialValue;
- (float)valueForSliderAtIndex:(NSInteger)index;

@property(nonatomic,readonly) CGAffineTransform fromTransform;
@property(nonatomic,readonly) CGAffineTransform toTransform;

@property(nonatomic,strong,readonly) UIView* animationView;
@end

@interface SPRBaseSpringViewController (Abstract)

- (void)run:(void(^)(void))completion;

@end