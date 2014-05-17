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

@interface RUQPagingScrollView : UIScrollView

@property (nonatomic, assign) id <RUQPagingScrollViewDataSource>        dataSource;
@property (nonatomic, assign) id <RUQPagingScrollViewPagingDelegate>    pagingDelegate;

@end

@protocol RUQPagingScrollViewDataSource<NSObject>

@required
- (UIView*) scrollView: (RUQPagingScrollView*) scrollView viewBeforePage: (UIView*) pageView;
- (UIView*) scrollView: (RUQPagingScrollView*) scrollView viewAfterPage: (UIView*) pageView;
- (BOOL) scrollView: (RUQPagingScrollView*) scrollView isFirstPage: (UIView*) pageView;
- (BOOL) scrollView: (RUQPagingScrollView*) scrollView isLastPage: (UIView*) pageView;

- (UIView*) centerViewForScrollView: (RUQPagingScrollView*) scrollView;

@end

@protocol RUQPagingScrollViewPagingDelegate<NSObject>

@optional
- (void) scrollView: (RUQPagingScrollView*) scrollView didScrollToPage: (UIView*) pageView;

@end