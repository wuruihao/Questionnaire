//
//  UICollectionViewWaterfallLayout.h
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowWaterfallLayout;
@protocol ShowDelegateWaterfallLayout <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(ShowWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ShowWaterfallLayout : UICollectionViewLayout

@property (nonatomic, assign) id<ShowDelegateWaterfallLayout> delegate;
@property (nonatomic, assign) NSUInteger columnCount; // How many columns
@property (nonatomic, assign) CGFloat itemWidth; // Width for every column
@property (nonatomic, assign) UIEdgeInsets sectionInset; // The margins used to lay out content in a section
@end
