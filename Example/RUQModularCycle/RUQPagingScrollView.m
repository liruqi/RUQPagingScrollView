//
//  RUQPagingScrollView.m
//  CMRTest
//
//  Created by RUQI on 5/16/14.
//  Copyright (c) 2014 RUQI. All rights reserved.
//

#import "RUQPagingScrollView.h"
@interface RUQPagingScrollView ()

@property (nonatomic, strong) UIView* leftView;
@property (nonatomic, strong) UIView* rightView;
@property (nonatomic, strong) UIView* centerView;

@end

@implementation RUQPagingScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        super.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    // dummy
}

- (void)setDataSource:(id<RUQPagingScrollViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self reloadData];
    }
}

- (void)reloadData
{
    [self.leftView removeFromSuperview];
    [self.rightView removeFromSuperview];
    [self.centerView removeFromSuperview];
    
    self.centerView = [self.dataSource centerViewForScrollView:self];
    self.rightView = [self.dataSource scrollView:self viewAfterPage:self.centerView];
    self.leftView = [self.dataSource scrollView:self viewBeforePage:self.centerView];
    self.contentOffset = CGPointZero;

    if (self.centerView) {
        self.contentSize = self.frame.size;
        if (self.leftView || self.rightView) {
            if (self.leftView && self.rightView) {
                self.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 3, CGRectGetHeight(self.frame));
                self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
                self.centerView.frame = CGRectMake(CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                [self addSubview:self.centerView];
                
                self.leftView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                [self addSubview:self.leftView];
                
                self.rightView.frame = CGRectMake(CGRectGetWidth(self.frame) * 2, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                [self addSubview:self.rightView];
                return;
            }
            
            self.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 2, CGRectGetHeight(self.frame));
            if (self.leftView) {
                self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
                self.centerView.frame = CGRectMake(CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                [self addSubview:self.centerView];
                
                self.leftView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                [self addSubview:self.leftView];
                return;
            } else {
                self.centerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                [self addSubview:self.centerView];
                
                self.rightView.frame = CGRectMake(CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
                [self addSubview:self.rightView];
            }
        } else {
            self.centerView.frame = self.bounds;
            [self addSubview:self.centerView];
        }
        return;
    } else {
        self.contentSize = CGSizeZero;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.contentSize.width < CGRectGetWidth(self.frame) * 3) {
        NSLog(@"RUQPagingScrollView: less than 3 pages, ignore");
        return;
    }
    
    [self recenterContent];
}

- (void)recenterContent
{
    CGPoint currentContentOffset = [self contentOffset];
    if (currentContentOffset.x < 0) {
        currentContentOffset.x = 0;
    } else if (currentContentOffset.x > CGRectGetWidth(self.frame)*2) {
        currentContentOffset.x = CGRectGetWidth(self.frame)*2;
    }
    
    CGFloat distanceFromCenterOffsetX = fabs(currentContentOffset.x - CGRectGetWidth(self.frame));
    // NSLog(@"[recenterContent] currentContentOffset.x: %f", currentContentOffset.x);
    if (distanceFromCenterOffsetX == CGRectGetWidth(self.frame)) {
        if (currentContentOffset.x == 0) {
            if (! self.leftView) {
                return;
            }
            if ([self.dataSource scrollView:self isFirstPage:self.leftView]) {
                return;
            }
            [self scrollsToLeft];
        } else if (currentContentOffset.x == CGRectGetWidth(self.frame) * 2) {
            if (! self.rightView) {
                return;
            }
            if ([self.dataSource scrollView:self isLastPage:self.rightView]) {
                return;
            }
            [self scrollsToRight];
        }
        
    }
}

- (void)scrollsToLeft {
    [self.rightView removeFromSuperview];
    
    self.rightView = self.centerView;
    self.rightView.frame = CGRectOffset(self.rightView.frame, CGRectGetWidth(self.frame), 0);

    UIView* leftView = [self.dataSource scrollView:self viewBeforePage:self.leftView];
    leftView.frame = self.leftView.frame;

    self.centerView = self.leftView;
    self.centerView.frame = CGRectOffset(self.centerView.frame, CGRectGetWidth(self.frame), 0);
    
    self.leftView = leftView;
    [self addSubview: leftView];
    self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
    
    if (self.pagingDelegate && [self.pagingDelegate respondsToSelector:@selector(scrollView:didScrollToPage:)]) {
        [self.pagingDelegate scrollView: self didScrollToPage: self.centerView];
    }
}

- (void)scrollsToRight {
    [self.leftView removeFromSuperview];
    self.leftView = self.centerView;
    self.leftView.frame = CGRectOffset(self.centerView.frame, - CGRectGetWidth(self.frame), 0);
    
    UIView* rightView = [self.dataSource scrollView:self viewAfterPage:self.rightView];
    rightView.frame = self.rightView.frame;
    
    self.centerView = self.rightView;
    self.centerView.frame = CGRectOffset(self.centerView.frame, - CGRectGetWidth(self.frame), 0);
    
    self.rightView = rightView;
    [self addSubview:rightView];
    self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
    
    if (self.pagingDelegate && [self.pagingDelegate respondsToSelector:@selector(scrollView:didScrollToPage:)]) {
        [self.pagingDelegate scrollView: self didScrollToPage: self.centerView];
    }
}


@end
