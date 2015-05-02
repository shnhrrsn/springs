//
//  SPRUIKitSpringViewController.m
//  Springs
//
//  Created by Shaun Harrison on 5/2/15.
//  Copyright (c) 2015 shnhrrsn. All rights reserved.
//

#import "SPRUIKitSpringViewController.h"

@interface SPRUIKitSpringViewController ()

@end

@implementation SPRUIKitSpringViewController

- (instancetype)init {
	if((self = [super init])) {
		self.title = @"UIKit";
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	[self addSliderWithTitle:@"Duration" minimumValue:0.2 maximumValue:5.0 initialValue:0.6];
	[self addSliderWithTitle:@"Damping" minimumValue:0.0 maximumValue:1.0 initialValue:0.5];
	[self addSliderWithTitle:@"Velocity" minimumValue:0.0 maximumValue:10.0 initialValue:1.0];
}

- (void)run:(void(^)(void))completion {
	[self.animationView.layer removeAllAnimations];
	self.animationView.transform = self.fromTransform;
	
	[UIView animateWithDuration:(NSTimeInterval)[self valueForSliderAtIndex:0] delay:0.0 usingSpringWithDamping:(CGFloat)[self valueForSliderAtIndex:1] initialSpringVelocity:(CGFloat)[self valueForSliderAtIndex:2] options:0 animations:^{
		self.animationView.transform = self.toTransform;
	} completion:^(BOOL finished) {
		completion();
	}];
}

@end
