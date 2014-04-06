//
//  UIActionSheet+BlockButtons.h
//  Tipbit
//
//  Created by Navi Singh on 3/29/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockButton.h"

@interface UIActionSheet (BlocksButtons)

/**
 * @discussion This method is just an abbreviated form of the [[UIActionSheet alloc] initWithTitle:... method.
 */
+ (instancetype)createWithTitle:(NSString *)title
                       delegate:(id<UIActionSheetDelegate>)delegate
              cancelButtonTitle:(NSString *)cancelButtonTitle
         destructiveButtonTitle:(NSString *)destructiveButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * @discussion A block based version of the above method.  Instead of passing titles as strings and using the delegate with tags to respond to user-clicks, this makes use of the BlockButton class to set the display title for the button as well as the block that is to be executed when the user clicks on the button.
 */
+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
                  otherButtons:(BlockButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION;

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
                     onDismiss:(void(^)())dismissAction
                  otherButtons:(BlockButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * @discussion convenience method that assumes that the cancel button has the text "Cancel", and there is no header (unless the header is provided in the array @see BlockButton:header for details).
 */
+(instancetype)createWithButtons:(NSArray *)otherButtons;

/**
 * @discussion convenience method that assumes that the cancel button has the text "Cancel".
 */
+(instancetype)createWithTitle:(NSString *)title
                       buttons:(NSArray *)otherButtons;

/**
 * @discussion convenience method that allows the user to specify the cancel button title and action.
 */
+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
                       buttons:(NSArray *)otherButtons;

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
                       buttons:(NSArray *)otherButtons;

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
                     onDismiss:(void(^)())dismissAction
                       buttons:(NSArray *)otherButtons;

/**
 * @discussion a programmatic way to dismiss the action sheet.
 */
-(void)dismiss:(BOOL)animated;

@end
