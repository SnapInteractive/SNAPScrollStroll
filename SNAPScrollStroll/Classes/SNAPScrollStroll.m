//
//  SNAPScrollStroll
//
//  Created by Edwin Iskandar on 11/30/12.
//  Copyright (c) 2012 Snap-Interactive. All rights reserved.
//

#import "SNAPScrollStroll.h"
#import <QuartzCore/QuartzCore.h>

@interface SNAPScrollStroll()
@property int animationIndex;
@property BOOL forward;
@property BOOL isVisibleOnScreen;
@property CGPoint lastFloatOffset;
@property CGRect scrollIndicatorOriginalFrame; // keep track of this to restore its frame
@property (nonatomic, strong) NSArray *animationImageNames;
- (void)animate;
- (void)appear:(CGFloat)yPosition;
- (void)disappear;
@end

@implementation SNAPScrollStroll
const CGFloat kSNAPScrollStrollAlpha = .90f;
const CGFloat kSNAPScrollStrollWidth = 100.0f;
const CGFloat kSNAPScrollStrollHeight = 40.0f;
const CGFloat kSNAPScrollStrollPadding = 10.0f;
const CGFloat kSNAPScrollStrollIndicatorWidth = 5.0f;
const CGFloat kSNAPScrollStrollAnimateOutWidth = 10.0f;
const CGFloat kSnapScrollStrollAnimationDuration = .3f;

- (id)initWithAnimationImageNames:(NSArray *)animationImageNames {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kSNAPScrollStrollWidth, kSNAPScrollStrollHeight)];
    if (self) {
		self.animationIndex = 1;
		self.forward = YES;
		self.animationImageNames = animationImageNames;
		self.alpha = 0.0f;
		
		// scroll indicator
		self.scrollIndicator = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - kSNAPScrollStrollIndicatorWidth, 0.0f, kSNAPScrollStrollIndicatorWidth, kSNAPScrollStrollHeight)];
		self.scrollIndicator.backgroundColor = [UIColor blackColor];
		self.scrollIndicatorOriginalFrame = self.scrollIndicator.frame;
		[self addSubview:self.scrollIndicator];
		
		// background view
		self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width - self.scrollIndicator.frame.size.width - kSNAPScrollStrollPadding, self.frame.size.height)];
		[self.backgroundView  setBackgroundColor:[UIColor blackColor]];
		[self addSubview:self.backgroundView ];
		
		// animated image
		self.animatingView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.backgroundView.frame.size.height, self.backgroundView.frame.size.height)];
		[self addSubview:self.animatingView];
		
		// text
		self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.animatingView.frame.size.width, 0.0f, self.backgroundView.frame.size.width - self.animatingView.frame.size.width, self.frame.size.height)];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.textColor = [UIColor whiteColor];
		[self addSubview:self.textLabel];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(makeAnimatedDistanceDissapear) object:nil];
	
	CGFloat scollIndicatorYPosition = (scrollView.contentOffset.y/scrollView.contentSize.height) * [UIScreen mainScreen].bounds.size.height;
	
	if (scollIndicatorYPosition < 0.0f) {
		scollIndicatorYPosition = 0.0f;
		[self scheduleAnimatedDistanceToDissapear];
	}
	
	if (self.alpha == 0.0f && scollIndicatorYPosition > 0.0f) {
		[self appear:scollIndicatorYPosition];
	} else {
		// set direction we want to animate
		self.forward = self.lastFloatOffset.y < scrollView.contentOffset.y;
		
		self.lastFloatOffset = scrollView.contentOffset;
		[self animate];
		self.frame = CGRectMake(self.frame.origin.x, scollIndicatorYPosition, self.frame.size.width, self.frame.size.height);
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self scheduleAnimatedDistanceToDissapear];
}

- (void)makeAnimatedDistanceDissapear {
	[self disappear];
}

- (void)scheduleAnimatedDistanceToDissapear {
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(makeAnimatedDistanceDissapear) object:nil];
	[self performSelector:@selector(makeAnimatedDistanceDissapear) withObject:nil afterDelay:.6f];
}

- (void)animate {
	if (self.forward) {
		self.animationIndex ++;
		if (self.animationIndex > ([self.animationImageNames count] - 1)) {
			self.animationIndex = 0;
		}
	} else {
		self.animationIndex --;
		if (self.animationIndex < 0) {
			self.animationIndex = ([self.animationImageNames count] - 1);
		}
	}
	
	self.animatingView.image = [UIImage imageNamed:[self.animationImageNames objectAtIndex:self.animationIndex]];
}


- (BOOL)isAnimating {
	if ((self.alpha != kSNAPScrollStrollAlpha) && (self.alpha != 0.0f)) {
		return YES;
	} else {
		return NO;
	}
}

- (void)appear:(CGFloat)yPosition {
	if (self.isVisibleOnScreen || [self isAnimating]) {
		return;
	}
	
	self.frame = CGRectMake(self.frame.origin.x, yPosition, self.frame.size.width, self.frame.size.height);
	
	// make scrollview very tiny
	self.scrollIndicator.frame = CGRectMake([self scrollIndicatorOriginalFrame].origin.x, [self scrollIndicatorOriginalFrame].origin.y + ([self scrollIndicatorOriginalFrame].size.height/2), [self scrollIndicatorOriginalFrame].size.width, 0.0f);
	
	self.frame = CGRectOffset(self.frame, kSNAPScrollStrollAnimateOutWidth, 0.0f);
	[self.scrollIndicator.layer removeAllAnimations];
	self.isVisibleOnScreen = YES;
	[UIView animateWithDuration:kSnapScrollStrollAnimationDuration delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
		self.alpha = kSNAPScrollStrollAlpha;
		self.frame = CGRectOffset(self.frame, -kSNAPScrollStrollAnimateOutWidth, 0.0f);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:kSnapScrollStrollAnimationDuration - .1f animations:^{
			self.scrollIndicator.frame = [self scrollIndicatorOriginalFrame];
		} completion:^(BOOL innerFinished) {
		}];
	}];
}

- (void)disappear {
	if (!self.isVisibleOnScreen || [self isAnimating]) {
		return;
	}
	
	[self.scrollIndicator.layer removeAllAnimations];
	[UIView animateWithDuration:kSnapScrollStrollAnimationDuration-.1f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
		self.scrollIndicator.frame = CGRectMake([self scrollIndicatorOriginalFrame].origin.x, [self scrollIndicatorOriginalFrame].origin.y + ([self scrollIndicatorOriginalFrame].size.height/2), [self scrollIndicatorOriginalFrame].size.width, 0.0f);
		self.alpha = self.alpha - .1f;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:kSnapScrollStrollAnimationDuration delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
			self.alpha = 0.0f;
			self.frame = CGRectOffset(self.frame, kSNAPScrollStrollAnimateOutWidth, 0.0f);
		} completion:^(BOOL innerFinished) {
			self.frame = CGRectOffset(self.frame, -kSNAPScrollStrollAnimateOutWidth, 0.0f);
			self.isVisibleOnScreen = NO;
		}];
	}];
}
@end