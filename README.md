# ScrollStroll

ScrollStroll is a UIScrollView "companion" view that can be used to replace the default scrolling indicator with a custom animated indicator.

You can use this indicator to quickly signify to the user how the scroll view is ordered by animating an appropriate image. E.g. if the scroll view is ordered by date, you can animate a clock with its hands turning clockwise as you scroll down, and counter-clockwise as you scroll up. You can also display the current visible content within the indicator - useful to the user to get a sense of "where they are" within the data list when they scroll quickly.

It is very lightweight (only 1 class), easily customizable, and only requires a couple of lines to integrate.

It is used in our app AreYouInterested? and was inspired by the apps Path and Trover.

ScrollStroll:

![ScrollStroll](http://i.imgur.com/JQmzU.png)

[AreYouInterested?:](https://itunes.apple.com/us/app/are-you-interested/id307930478?mt=8)

![AreYouInterested?](http://i.imgur.com/A1jWs.png)

## Requirements

Nothing. Just be using UIKit and have a UIScrollView/UITableView somewhere.

## Installation Instructions

To get this going in your project:

* Copy ./SnapScrollStroll/Classes/SNAPScrollStroll.h to your project
* Copy ./SnapScrollStroll/Classes/SNAPScrollStroll.m to your project
* (optional) Copy the images in ./SnapScrollStroll/Resources to your project

Then in your view controller with your scrollview/tableview initialize and add the view:
```objective-c
self.scrollStroll = [[SNAPScrollStroll alloc] initWithAnimationImageNames:@[@"snap_walking_char1", @"snap_walking_char2", @"snap_walking_char3", @"snap_walking_char4", @"snap_walking_char5", @"snap_walking_char6", @"snap_walking_char7", @"snap_walking_char8"]];

[self.view addSubview:self.scrollStroll];
```
In your UIScrollViewDelegate methods notify ScrollStroll when the user starts and stops scrolling:

```objective-c
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	// tell scroll stroll that the view just scrolled
	[self.scrollStroll scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *) scrollView {
	// tell scroll stroll that the view is decelerating
	[self.scrollStroll scrollViewDidEndDecelerating:scrollView];
}
```
If you're using a tableview, you can set the text of the indicator in the cellForRowAtIndexPath method like this:

```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	.... 
	// update the scrollStroll with text
	self.scrollStroll.textLabel.text = [self yourDataObjectAt:indexPath];
    ....
}
```

## Customizing ScrollStroll

You can trivially change the animation images by passing in your own images to the initWithAnimationImageNames method.

To change the look and feel of ScrollStroll, you should look at customizing the following 4 properties in the initWithAnimationImageNames method:

```objective-c
@property (nonatomic, strong) UIImageView *animatingView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *scrollIndicator;
```

## Contributing

 * Please use topic branches when submitting pull requests. Please don't submit PR's from master.
 * Take care to follow the existing style. We have no formal style guide as of yet, but follow the idiomatic ~~JS~~ good-guy principle of: "All code in any code-base should look like a single person typed it, no matter how many people contributed."
