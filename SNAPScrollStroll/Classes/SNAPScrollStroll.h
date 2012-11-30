//
//  SNAPScrollStroll.h
//
//  Created by Edwin Iskandar on 11/30/12.
//  Copyright (c) 2012 Snap-Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNAPScrollStroll : UIView {
}

@property (nonatomic, strong) UIImageView *animatingView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *scrollIndicator;

/* 
 initialize with an array of image file names you want to 
 flip through as the scroll view scrolls
 */
- (id)initWithAnimationImageNames:(NSArray *)animationImageNames;

/*
 tell scroll stroll when the scrollview is scrolling so that
 it can animate and move to the proper position
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/*
 tell scroll stroll that the user is done scrolling so it can
 get out of the way
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *) scrollView;
@end
