//
//  SPRBaseSpringViewController.m
//  Springs
//
//  Created by Shaun Harrison on 5/2/15.
//  Copyright (c) 2015 shnhrrsn. All rights reserved.
//

#import "SPRBaseSpringViewController.h"

#import <SHNGeometryHelper/SHNGeometryHelper.h>

NSString* const SPRBaseSpringViewControllerAnimationTypeChanged = @"SPRBaseSpringViewControllerAnimationTypeChanged";

@interface SPRBaseSpringViewController ()

@end

@implementation SPRBaseSpringViewController {
	UISegmentedControl* _titleControl;
	NSMutableArray* _sliders;
	NSMutableArray* _sliderLabels;
	NSMutableArray* _sliderTitles;
	UILabel* _durationLabel;
	UIView* _slidersContainerView;
	UIView* _animationContainerView;
}

- (instancetype)init {
	if((self = [super init])) {
		_sliders = [[NSMutableArray alloc] init];
		_sliderLabels = [[NSMutableArray alloc] init];
		_sliderTitles = [[NSMutableArray alloc] init];
		
		_titleControl = [[UISegmentedControl alloc] initWithItems:@[ @"Scale", @"Translate" ]];
		_titleControl.selectedSegmentIndex = 0;
		[_titleControl addTarget:self action:@selector(animationTypeChanged) forControlEvents:UIControlEventValueChanged];
		self.navigationItem.titleView = _titleControl;
		
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Run" style:UIBarButtonItemStyleDone target:self action:@selector(run)];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationTypeChanged:) name:SPRBaseSpringViewControllerAnimationTypeChanged object:nil];
		[self updateTransformValues];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	const CGRect bounds = self.view.bounds;
	self.view.backgroundColor = [UIColor whiteColor];
	
	CGRect animationContainerRect = CGRectMake(8.0, 8.0, bounds.size.width - 16.0, 240.0);
	_animationContainerView = [[UIView alloc] initWithFrame:animationContainerRect];
	_animationContainerView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
	_animationContainerView.clipsToBounds = YES;
	[self.view addSubview:_animationContainerView];
	
	_durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, animationContainerRect.size.height - 23.0, animationContainerRect.size.width - 16.0, 15.0)];
	_durationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	_durationLabel.font = [UIFont systemFontOfSize:13.0];
	_durationLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	_durationLabel.textAlignment = NSTextAlignmentRight;
	[_animationContainerView addSubview:_durationLabel];
	
	_animationView = [[UIView alloc] initWithFrame:SHNRectGetCenteredInRect(CGRectMake(0.0, 0.0, 100., 100.0), _animationContainerView.bounds)];
	_animationView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
	_animationView.backgroundColor = [UIApplication sharedApplication].keyWindow.tintColor;
	[_animationContainerView addSubview:_animationView];
	
	_slidersContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, 0.0)];
	_slidersContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:_slidersContainerView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self run];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	
	const CGRect bounds = self.view.bounds;
	
	_animationContainerView.frame = CGRectMake(8.0, self.topLayoutGuide.length + 8.0, bounds.size.width - 16.0, 240.0);
	
	CGRect slidersRect = _slidersContainerView.frame;
	slidersRect.origin.y = bounds.size.height - slidersRect.size.height - self.bottomLayoutGuide.length - 8.0;
	_slidersContainerView.frame = slidersRect;
}

- (void)addSliderWithTitle:(NSString*)title minimumValue:(float)minimumValue maximumValue:(float)maximumValue initialValue:(float)initialValue {
	NSParameterAssert([self isViewLoaded]);
	[_sliderTitles addObject:title];

	CGRect slidersRect = _slidersContainerView.frame;
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(8.0, slidersRect.size.height, slidersRect.size.width - 16.0, 20.0)];
	label.text = [NSString stringWithFormat:@"%@: %@", title, @(initialValue)];
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_slidersContainerView addSubview:label];
	[_sliderLabels addObject:label];

	
	UISlider* slider = [[UISlider alloc] init];
	slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	slider.minimumValue = minimumValue;
	slider.maximumValue = maximumValue;
	slider.value = initialValue;
	[slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
	[slider addTarget:self action:@selector(sliderTouchUp) forControlEvents:UIControlEventTouchUpInside];
	[slider sizeToFit];
	
	CGRect sliderRect = slider.frame;
	sliderRect.origin.y = CGRectGetMaxY(label.frame) + 4.0;
	sliderRect.origin.x = 8.0;
	sliderRect.size.width = slidersRect.size.width - 16.0;
	slider.frame = sliderRect;
	[_sliders addObject:slider];
	
	slidersRect.size.height = CGRectGetMaxY(sliderRect);
	slidersRect.origin.y = self.view.bounds.size.height - slidersRect.size.height - self.bottomLayoutGuide.length - 8.0;
	_slidersContainerView.frame = slidersRect;
	[_slidersContainerView addSubview:slider];
}

- (void)sliderValueChanged:(UISlider*)slider {
	slider.value = round(slider.value * 100.0) / 100.0;
	
	const NSInteger index = [_sliders indexOfObject:slider];
	UILabel* label = _sliderLabels[index];
	label.text = [NSString stringWithFormat:@"%@: %@", _sliderTitles[index], @(slider.value)];
}

- (void)run {
	const CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();

	[self run:^{
		const CFAbsoluteTime elapsed = CFAbsoluteTimeGetCurrent() - start;
		_durationLabel.text = [NSString stringWithFormat:@"Duration: ~%.03fs", elapsed];
	}];
}

- (void)sliderTouchUp {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self run];
	});
}

- (float)valueForSliderAtIndex:(NSInteger)index {
	return ((UISlider*)_sliders[index]).value;
}

- (void)animationTypeChanged {
	[[NSNotificationCenter defaultCenter] postNotificationName:SPRBaseSpringViewControllerAnimationTypeChanged object:@(_titleControl.selectedSegmentIndex)];

	[self run];
}

- (void)animationTypeChanged:(NSNotification*)notification {
	_titleControl.selectedSegmentIndex = [notification.object integerValue];
	[self updateTransformValues];
}

- (void)updateTransformValues {
	if(_titleControl.selectedSegmentIndex == 0) {
		_fromTransform = CGAffineTransformMakeScale(0.5, 0.5);
		_toTransform = CGAffineTransformIdentity;
	} else {
		_fromTransform = CGAffineTransformMakeTranslation(0.0, -50.0);
		_toTransform = CGAffineTransformIdentity;
	}
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SPRBaseSpringViewControllerAnimationTypeChanged object:nil];
}

@end
