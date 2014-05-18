//
//  RUQViewController.m
//  RUQModularCycle
//
//  Created by liruqi on 5/17/14.
//  Copyright (c) 2014 liruqi. All rights reserved.
//

#import "RUQViewController.h"
#import "RUQPagingScrollView.h"
#import "GBInfiniteScrollViewPage.h"

const int RUQMOD = 7;
const int RUQDELTA = 3;
const int RUQINI = 2;

@interface RUQViewController () <RUQPagingScrollViewDataSource, RUQPagingScrollViewPagingDelegate>

@property (nonatomic, strong) RUQPagingScrollView *pagingScrollView;

@end

@implementation RUQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pagingScrollView = [[RUQPagingScrollView alloc] initWithFrame:self.view.bounds];
    self.pagingScrollView.dataSource = self;
    self.pagingScrollView.pagingDelegate = self;
    [self.view addSubview:self.pagingScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*) viewWithNumber: (int) number {
    NSLog(@"viewWithNumber: %d", number);
    GBInfiniteScrollViewPage* pageView = [[GBInfiniteScrollViewPage alloc] initWithFrame:self.view.bounds style:GBInfiniteScrollViewPageStyleText];
    pageView.textLabel.text = [NSString stringWithFormat:@"%d", number];
    pageView.backgroundColor = [self randomColor];
    pageView.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-UltraLight" size:128];
    pageView.tag = number;
    return pageView;
}

- (UIColor *)randomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0f);
    CGFloat saturation = (arc4random() % 128 / 256.0f) + 0.5f;
    CGFloat brightness = (arc4random() % 128 / 256.0f) + 0.5f;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
    
    return color;
}

- (UIView*) scrollView: (RUQPagingScrollView*) scrollView viewBeforePage: (UIView*) pageView {
    int previous = (pageView.tag + RUQMOD - RUQDELTA) % RUQMOD;
    return [self viewWithNumber: previous];
}

- (UIView*) scrollView: (RUQPagingScrollView*) scrollView viewAfterPage: (UIView*) pageView {
    int next = (pageView.tag + RUQDELTA) % RUQMOD;
    return [self viewWithNumber: next];
}

- (BOOL) scrollView: (RUQPagingScrollView*) scrollView isFirstPage:(UIView *)pageView {
    return  (pageView.tag == RUQDELTA);
}

- (BOOL) scrollView: (RUQPagingScrollView*) scrollView isLastPage:(UIView *)pageView {
    return  (pageView.tag == 0);
}

- (UIView*) centerViewForScrollView : (RUQPagingScrollView*) scrollView {
    return [self viewWithNumber:RUQINI];
}

- (UIView*) loadingViewForscrollView:(RUQPagingScrollView *)scrollView {
    UILabel* loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    loadingLabel.text = @"Loading...";
    return loadingLabel;
}

#pragma mark - RUQPagingScrollViewPagingDelegate
- (void) scrollView: (RUQPagingScrollView*) scrollView didScrollToPage:(UIView *)pageView {
    NSLog(@"didScrollToPage: %d", pageView.tag);
}


@end
