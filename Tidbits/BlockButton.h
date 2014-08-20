//
//  BlockButton.h
//  Tipbit
//
//  Created by Navi Singh on 3/29/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @discussion object to support block based actions for UIAlertViews and UIActionSheets.
 *   A button typically has a label (displayed on the UIAlertView or UIActionSheet)
 *   and an action - a void block which is executed when the button is clicked.
 */
@interface BlockButton : NSObject

+(instancetype)button;
+(instancetype)label:(NSString *)label;

/**
 * @param label: The label displayed on the button in the UIAlertView / UIActionSheet
 * @param action: a block that gets passed in the label for the button.
 * @return a button
 * @discussion this method is the raison-d'etre for this class's existence.
 */
+(instancetype)label:(NSString *)label action:(void(^)())action;

/**
 * @param label: The label displayed on the button in the UIAlertView / UIActionSheet
 * @param action: a block that gets passed in the label for the button.
 * @return a button
 * @discussion this is really a convenience for where its useful to know which button was clicked for logging.  But it may also be used to return the text field in case of a UIAlertView that expects the user to enter some value in a text field.
 */
+(instancetype)label:(NSString *)label actionWithText:(void(^)(NSString *text))action;

/**
 * @param label: The label displayed on the button in the UIAlertView / UIActionSheet
 * @param action: a block that gets passed in the label for the button.
 * @return a button
 * @discussion this is really for uialertviews that are used to get text fields such as usernames and passwords.
 */
+(instancetype)label:(NSString *)label actionWithTextText:(void(^)(NSString *username, NSString *password))action;

@property (nonatomic, strong) NSString *label;
@property (nonatomic, copy) void(^action)();
@property (nonatomic, copy) void(^actionWithText)(NSString *text);
@property (nonatomic, copy) void(^actionWithTextText)(NSString *username, NSString *password);

@property (nonatomic, assign) int tag;
@property (nonatomic, weak) UIView *parentView;

/**
 * @param header: Used in ActionSheets to display the header.
 * @discussion this is a convenience where all the inputs to the actionsheet are
 *   in the form of an array of buttons AND this includes the header!
 */
+(instancetype)header:(NSString *)headerTitle;

@property (nonatomic) BOOL isHeader;

- (void) executeAction;

@end

/**
 * Convenience functions for creating BlockButtons with labels and associated actions.
 * These methods are shorthand for BlockButton:label:action, BlockButton:label:actionWithText, and BlockButton:label:actionWithTextText
 * @param label  This is the label that is displayed on the UIAlertView / UIActionSheet button.
 @ @param action This is the block of code that is executed when the UIAlertView / UIActionSheet button is pressed.
 * @discussion  Thre are three variants of the action block.  
 * The first is a void block.  This is the most commonly used.
 * The second is a block that has a single String argument.  The argument returned is the block label.
 * The third is outputs two string argumetns -- this is used for the UIAlertView that accepts username / password.
 */

BlockButton *button(NSString *label, void(^action)());
BlockButton *buttonT(NSString *label, void(^action)(NSString *label));
BlockButton *buttonTT(NSString *label, void(^action)(NSString *username, NSString *password));
