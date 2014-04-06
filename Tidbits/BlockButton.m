//
//  BlockButton.m
//  Tipbit
//
//  Created by Navi Singh on 3/29/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton

+(instancetype)button
{
    BlockButton *button =[self new];
    button.tag = 0;
    return button;
}

/**
 * @param header: Used in ActionSheets to display the header.
 * @discussion this is a convenience where all the inputs to the actionsheet are
 *   in the form of an array of buttons AND this includes the header!
 */
+(instancetype)header:(NSString *)headerTitle
{
    BlockButton *button = [self button];
    button.label = headerTitle;
    button.isHeader = YES;
    return button;
}

+(instancetype)label:(NSString *)label
{
    return [BlockButton label:label action:nil];
}

/**
 * @param label: The label displayed on the button in the UIAlertView / UIActionSheet
 * @param action: a block that gets passed in the label for the button.
 * @return a button
 * @discussion this method is the raison-d'etre for this class's existence.
 */
+(instancetype)label:(NSString *)label action:(void(^)())action
{
    BlockButton *button = [self button];
    button.label = label;
    button.action = action;
    return button;
}

/**
 * @param label: The label displayed on the button in the UIAlertView / UIActionSheet
 * @param action: a block that gets passed in the label for the button.
 * @return a button
 * @discussion this is really a convenience for where its useful to know which button was clicked for logging.  But it may also be used to return the text field in case of a UIAlertView that expects the user to enter some value in a text field.
 */
+(instancetype)label:(NSString *)label actionWithText:(void(^)(NSString *))action
{
    BlockButton *button = [self button];
    button.label = label;
    button.actionWithText = action;
    return button;
}

/**
 * @param label: The label displayed on the button in the UIAlertView / UIActionSheet
 * @param action: a block that gets passed in the label for the button.
 * @return a button
 * @discussion this is really for uialertviews that are used to get text fields such as usernames and passwords.
 */
+(instancetype)label:(NSString *)label actionWithTextText:(void(^)(NSString *, NSString *))action
{
    BlockButton *button = [self button];
    button.label = label;
    button.actionWithTextText = action;
    return button;
}

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@"  Label: %@", self.label];
}

@end

/**
 * @discussion These methods are just short-cuts to the methods above, as a quick way to get around objective-c's verbosity.
 */
BlockButton *button(NSString *label, void(^action)())
{
    BlockButton *button = [BlockButton label:label action:action];
    return button;
}
BlockButton *buttonT(NSString *label, void(^action)(NSString *))
{
    BlockButton *button = [BlockButton label:label actionWithText:action];
    return button;
}
BlockButton *buttonTT(NSString *label, void(^action)(NSString *, NSString *))
{
    BlockButton *button = [BlockButton label:label actionWithTextText:action];
    return button;
}
