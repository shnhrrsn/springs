//
//  SPRRBBSpringViewController.m
//  Springs
//
//  Created by Shaun Harrison on 5/2/15.
//  Copyright (c) 2015 shnhrrsn. All rights reserved.
//

#import "SPRRBBSpringViewController.h"
#import <RBBAnimation/RBBSpringAnimation.h>

@interface SPRRBBSpringViewController ()

@end

@implementation SPRRBBSpringViewController

- (instancetype)init {
	if((self = [super init])) {
		self.title = @"RBB";
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
		
	[self addSliderWithTitle:@"Damping" minimumValue:0.1 maximumValue:200.0 initialValue:10.0];
	[self addSliderWithTitle:@"Mass" minimumValue:0.1 maximumValue:10.0 initialValue:1.0];
	[self addSliderWithTitle:@"Stiffness" minimumValue:0.1 maximumValue:1000.0 initialValue:100.0];
	[self addSliderWithTitle:@"Velocity" minimumValue:0.0 maximumValue:100.0 initialValue:0.0];
}

- (void)run:(void(^)(void))completion {
	[self.animationView.layer removeAnimationForKey:@"spring"];
	
	RBBSpringAnimation* anim = [RBBSpringAnimation animationWithKeyPath:@"transform"];
	anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(self.fromTransform)];
	anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(self.toTransform)];
	anim.fillMode = kCAFillModeBoth;
	anim.removedOnCompletion = NO;
	
	anim.damping = (CGFloat)[self valueForSliderAtIndex:0];
	anim.mass = (CGFloat)[self valueForSliderAtIndex:1];
	anim.stiffness = (CGFloat)[self valueForSliderAtIndex:2];
	anim.velocity = (CGFloat)[self valueForSliderAtIndex:3];
	
	anim.duration = [anim durationForEpsilon:0.01];
	
	[CATransaction begin];
	[CATransaction setCompletionBlock:completion];
	[self.animationView.layer addAnimation:anim forKey:@"spring"];
	[CATransaction commit];
}

@end
