//
//  ZPActionSheet.h
//  ZPAlert
//
//  Created by 赵朋 on 17/2/16.
//  Copyright © 2017年 赵朋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  ZPActionSheetDelegate;

@interface ZPActionSheet : UIView

@property (nonatomic, copy, nullable) NSString *title;

@property (strong, nonatomic) NSMutableArray *buttonTitleArr;

@property (nonatomic, copy, nullable) NSString *cancelButtonTitle;

@property (weak, nonatomic) id<ZPActionSheetDelegate>delegate;

- (instancetype)initWithTitle:(nullable NSString *)title delegate:(nullable id<ZPActionSheetDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle buttonTitles:(nullable NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setTitleColor:(nullable UIColor *)color backColor:(nullable UIColor *)backColor fontSize:(CGFloat)size;

- (void)setButtonTitleColor:(nullable UIColor *)color backColor:(nullable UIColor *)backColor fontSize:(CGFloat)size buttonIndex:(NSInteger)buttonIndex;

- (void)setcancelButtonColor:(nullable UIColor *)color backColor:(nullable UIColor *)backColor fontSize:(CGFloat)size;

- (void)show;

- (void)hide;

@end

@protocol  ZPActionSheetDelegate<NSObject>

@optional
- (void)actionSheetCancel:(ZPActionSheet *)actionSheet;

- (void)actionSheet:(ZPActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
NS_ASSUME_NONNULL_END
