//
//  SPRPOPSpringViewController.m
//  Springs
//
//  Created by Shaun Harrison on 5/2/15.
//  Copyright (c) 2015 shnhrrsn. All rights reserved.
//

#import "SPRPOPSpringViewController.h"
#import <POP/POP.h>

@interface SPRPOPSpringViewController ()

@end

@implementation SPRPOPSpringViewController

- (instancetype)init {
	if((self = [super init])) {
		self.title = @"POP";
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self addSliderWithTitle:@"Bounciness" minimumValue:0.0 maximumValue:20.0 initialValue:4.0];
	[self addSliderWithTitle:@"Speed" minimumValue:0.0 maximumValue:20.0 initialValue:12.0];
	[self addSliderWithTitle:@"Velocity" minimumValue:0.0 maximumValue:500.0 initialValue:0.0];
}

- (void)run:(void(^)(void))completion {
	[self.animationView.layer pop_removeAnimationForKey:@"spring"];
	CGFloat velocity = (CGFloat)[self valueForSliderAtIndex:2];

	POPSpringAnimation* anim;
	
	if(self.fromTransform.a != 1.0) {
		anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
		anim.fromValue = [NSValue valueWithCGSize:CGSizeMake(self.fromTransform.a, self.fromTransform.d)];
		anim.toValue = [NSValue valueWithCGSize:CGSizeMake(self.toTransform.a, self.toTransform.d)];
		anim.velocity = [NSValue valueWithCGSize:CGSizeMake(velocity, velocity)];
	} else {
		anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationXY];
		anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.fromTransform.tx, self.fromTransform.ty)];
		anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.toTransform.tx, self.toTransform.ty)];
		anim.velocity = [NSValue valueWithCGPoint:CGPointMake(velocity, velocity)];
	}
	
	anim.springBounciness = (CGFloat)[self valueForSliderAtIndex:0];
	anim.springSpeed = (CGFloat)[self valueForSliderAtIndex:1];
	
	
	anim.completionBlock = ^(POPAnimation* animation, BOOL finished) {
		completion();
	};
	
	[self.animationView.layer pop_addAnimation:anim forKey:@"spring"];
}

@end
