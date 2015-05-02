//
//  SPRJNWSpringViewController.m
//  Springs
//
//  Created by Shaun Harrison on 5/2/15.
//  Copyright (c) 2015 shnhrrsn. All rights reserved.
//

#import "SPRJNWSpringViewController.h"

#import <JNWSpringAnimation/JNWSpringAnimation.h>

@interface SPRJNWSpringViewController ()

@end

@implementation SPRJNWSpringViewController

- (instancetype)init {
	if((self = [super init])) {
		self.title = @"JNW";
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self addSliderWithTitle:@"Damping" minimumValue:0.0 maximumValue:200.0 initialValue:30.0];
	[self addSliderWithTitle:@"Mass" minimumValue:0.0 maximumValue:10.0 initialValue:5.0];
	[self addSliderWithTitle:@"Stiffness" minimumValue:0.0 maximumValue:1000.0 initialValue:300.0];
}

- (void)run:(void(^)(void))completion {
	[self.animationView.layer removeAnimationForKey:@"spring"];
	
	JNWSpringAnimation* anim = [JNWSpringAnimation animationWithKeyPath:@"transform"];
	anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(self.fromTransform)];
	anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(self.toTransform)];
	anim.fillMode = kCAFillModeBoth;
	anim.removedOnCompletion = NO;
	
	anim.damping = (CGFloat)[self valueForSliderAtIndex:0];
	anim.mass = (CGFloat)[self valueForSliderAtIndex:1];
	anim.stiffness = (CGFloat)[self valueForSliderAtIndex:2];
	
	[CATransaction begin];
	[CATransaction setCompletionBlock:completion];
	[self.animationView.layer addAnimation:anim forKey:@"spring"];
	[CATransaction commit];
}

@end
