//
//  RUQPagingScrollView.h
//  CMRTest
//
//  Created by RUQI on 5/16/14.
//  Copyright (c) 2014 RUQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RUQPagingScrollViewDataSource;
@protocol RUQPagingScrollViewPagingDelegate;

typedef void (^RUQPagingScrollViewLoadViewCompletionHandler) (UIView* view);

@interface RUQPagingScrollView : UIScrollView

@property (nonatomic, assign) id <RUQPagingScrollViewDataSource>        dataSource;
@property (nonatomic, assign) id <RUQPagingScrollViewPagingDelegate>    pagingDelegate;

- (void)reloadData;

@end

@protocol RUQPagingScrollViewDataSource<NSObject>

@required
// - (UIView*) scrollView: (RUQPagingScrollView*) scrollView viewBeforePage: (UIView*) pageView;
// - (UIView*) scrollView: (RUQPagingScrollView*) scrollView viewAfterPage: (UIView*) pageView;
// - (BOOL) scrollView: (RUQPagingScrollView*) scrollView isFirstPage: (UIView*) pageView;
// - (BOOL) scrollView: (RUQPagingScrollView*) scrollView isLastPage: (UIView*) pageView;
// - (UIView*) centerViewForScrollView: (RUQPagingScrollView*) scrollView;

/* Called only on view reload */
- (void) scrollView:(RUQPagingScrollView *)scrollView loadCenterViewWithCompletionHandler: (RUQPagingScrollViewLoadViewCompletionHandler) block;
- (void) scrollView:(RUQPagingScrollView *)scrollView loadViewBeforePage: (UIView*) pageView WithCompletionHandler: (RUQPagingScrollViewLoadViewCompletionHandler) block;
- (void) scrollView:(RUQPagingScrollView *)scrollView loadViewAfterPage: (UIView*) pageView WithCompletionHandler: (RUQPagingScrollViewLoadViewCompletionHandler) block;


@end

@protocol RUQPagingScrollViewPagingDelegate<NSObject>

@optional
- (void) scrollView: (RUQPagingScrollView*) scrollView didScrollToPage: (UIView*) pageView;

@end