//
//  UIActionSheet+BlockButtons.m
//  Tipbit
//
//  Created by Navi Singh on 3/29/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import "UIActionSheet+BlockButtons.h"
#import <objc/runtime.h>

static char UIACTIONSHEET_BUTTON_BLOCK_IDENTIFIER;
static NSString *UIActionSheetDismissAction = @"~~UIActionSheetDismissAction~~";

@implementation UIActionSheet (BlocksButtons)

- (instancetype) initWithTitle:(NSString *)title buttons:(NSArray*)menuItems
{
    //we got to do this because delegate is defined as id<UIActionSheetDelegate>
    //unlike what happens for UIAlertViews.
    id<UIActionSheetDelegate> selfClass = (id<UIActionSheetDelegate>)[UIActionSheet class];

    self = [self initWithTitle:title
                       delegate:selfClass
              cancelButtonTitle:nil
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
    if (self) {
        self.actionSheetStyle = UIActionSheetStyleAutomatic;

        BlockButton *headerItem;
        BlockButton *deleteItem;
        BlockButton *cancelItem = [BlockButton label:NSLocalizedString(@"Cancel", nil)];
        
        NSMutableArray *buttons = [NSMutableArray array];
        for (BlockButton *item in menuItems) {
            if (item.isHeader) {
                headerItem = item;
                self.title = item.label;
                continue;
            }

            if([item.label caseInsensitiveCompare:@"delete"] == NSOrderedSame){
                deleteItem = item;
                continue;
            }

            if([item.label caseInsensitiveCompare:@"cancel"] == NSOrderedSame){
                 cancelItem = item;
                continue;
            }

            [buttons addObject:item];
        }

        //first add the destructive button if any.
        if (deleteItem) {
            [buttons insertObject:deleteItem atIndex:0];
            [self setDestructiveButtonIndex:0];
        }

        //then add the other buttons
        for (BlockButton *item in buttons) {
            [self addButtonWithTitle:item.label];
        }

        //finally add the cancel button
        [buttons addObject:cancelItem];
        [self addButtonWithTitle:cancelItem.label];
        [self setCancelButtonIndex:buttons.count-1];

        //If there are any existing UIActionSheets around, we don't want to overwrite their data.
        NSMutableDictionary *mutableDict;
        NSDictionary *dict =  objc_getAssociatedObject([self class], &UIACTIONSHEET_BUTTON_BLOCK_IDENTIFIER);
        if (dict)
            mutableDict = [dict mutableCopy];
        else
            mutableDict = [NSMutableDictionary dictionary];
        [mutableDict setObject:buttons forKey:[NSValue valueWithNonretainedObject:self]];

        objc_setAssociatedObject([self class], &UIACTIONSHEET_BUTTON_BLOCK_IDENTIFIER, mutableDict, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return self;
}

+ (instancetype)createWithTitle:(NSString *)title
                       delegate:(id<UIActionSheetDelegate>)delegate
              cancelButtonTitle:(NSString *)cancelButtonTitle
         destructiveButtonTitle:(NSString *)destructiveButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *buttonsArray = [NSMutableArray array];
    NSString *eachItem;
    va_list argumentList;
    if (otherButtonTitles)
    {
        [buttonsArray addObject: otherButtonTitles];
        va_start(argumentList, otherButtonTitles);
        while((eachItem = va_arg(argumentList, NSString *)))
        {
            [buttonsArray addObject: eachItem];
        }
        va_end(argumentList);
    }

    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:title
                                                        delegate:delegate
                                               cancelButtonTitle:nil
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:nil];
    for(NSString *item in buttonsArray)
    {
        [action addButtonWithTitle:item];
    }

    if(destructiveButtonTitle)
    {
        action.destructiveButtonIndex = [action addButtonWithTitle:destructiveButtonTitle];
    }
    if(cancelButtonTitle)
    {
        action.cancelButtonIndex = [action addButtonWithTitle:cancelButtonTitle];
    }
    return action;
}

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
                     onDismiss:(void(^)())dismissAction
             destructiveButton:(BlockButton *)destructiveButton
                  otherButtons:(BlockButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *buttonsArray = [NSMutableArray array];
    BlockButton *eachItem;
    va_list argumentList;
    if (otherButtons)
    {
        [buttonsArray addObject: otherButtons];
        va_start(argumentList, otherButtons);
        while((eachItem = va_arg(argumentList, BlockButton *)))
        {
            [buttonsArray addObject: eachItem];
        }
        va_end(argumentList);
    }

    return [UIActionSheet createWithTitle:title
                             cancelButton:cancelButton
                                onDismiss:dismissAction
                        destructiveButton:destructiveButton
                        buttons:buttonsArray];
}

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
                  otherButtons:(BlockButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *buttonsArray = [NSMutableArray array];
    BlockButton *eachItem;
    va_list argumentList;
    if (otherButtons)
    {
        [buttonsArray addObject: otherButtons];
        va_start(argumentList, otherButtons);
        while((eachItem = va_arg(argumentList, BlockButton *)))
        {
            [buttonsArray addObject: eachItem];
        }
        va_end(argumentList);
    }

    return [UIActionSheet createWithTitle:title
                             cancelButton:cancelButton
                                onDismiss:nil
                        destructiveButton:destructiveButton
                        buttons:buttonsArray];
}

+(instancetype)createWithButtons:(NSArray *)buttonsArray
{
    return [[UIActionSheet alloc] initWithTitle:nil buttons:buttonsArray];
}

+(instancetype)createWithTitle:(NSString *)title
             buttons:(NSArray *)buttonsArray
{
    return [UIActionSheet createWithTitle:title
                             cancelButton:[BlockButton label:NSLocalizedString(@"Cancel", nil)]
                                onDismiss:nil
                        destructiveButton:nil
                        buttons:buttonsArray];
}

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             buttons:(NSArray *)buttonsArray
{
    return [UIActionSheet createWithTitle:title
                             cancelButton:cancelButton
                                onDismiss:nil
                        destructiveButton:nil
                        buttons:buttonsArray];
}

+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
             destructiveButton:(BlockButton *)destructiveButton
             buttons:(NSArray *)buttonsArray
{
    return [UIActionSheet createWithTitle:title
                             cancelButton:cancelButton
                                onDismiss:nil
                        destructiveButton:destructiveButton
                        buttons:buttonsArray];
}

//This is the main function where all the magic happens.
+(instancetype)createWithTitle:(NSString *)title
                  cancelButton:(BlockButton *)cancelButton
                     onDismiss:(void(^)())dismissAction
             destructiveButton:(BlockButton *)destructiveButton
             buttons:(NSArray *)buttons
{
    NSMutableArray *buttonsArray;
    if (buttons)
        buttonsArray = [NSMutableArray arrayWithArray:buttons];
    else
        buttonsArray = [NSMutableArray array];

    //we got to do this because delegate is defined as id<UIActionSheetDelegate>
    //unlike what happens for UIAlertViews.
    id<UIActionSheetDelegate> selfClass = (id<UIActionSheetDelegate>)[UIActionSheet class];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
															 delegate:selfClass
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];

	if(destructiveButton)
    {
        destructiveButton.parentView = actionSheet;
		[buttonsArray insertObject:destructiveButton atIndex:0];
        //		[buttonsArray addObject:destructiveButton];
        actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:destructiveButton.label];
    }

	for(BlockButton *item in buttonsArray)
    {
		if (!(item == destructiveButton)){
			item.parentView = actionSheet;
			[actionSheet addButtonWithTitle:item.label];
		}
    }

    if(cancelButton)
    {
        cancelButton.parentView = actionSheet;
        [buttonsArray addObject:cancelButton];
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:cancelButton.label];
    }
    if (dismissAction) {
        //We create a dummy button for the dismiss action that makes our life easier.
        BlockButton *dismissButton = [BlockButton label:UIActionSheetDismissAction action:dismissAction];
        [buttonsArray addObject:dismissButton];
    }

    //If there are any existing UIActionSheets around, we don't want to overwrite their data.
    NSMutableDictionary *mutableDict;
    NSDictionary *dict =  objc_getAssociatedObject([self class], &UIACTIONSHEET_BUTTON_BLOCK_IDENTIFIER);
    if (dict)
        mutableDict = [dict mutableCopy];
    else
        mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setObject:buttonsArray forKey:[NSValue valueWithNonretainedObject:actionSheet]];

    objc_setAssociatedObject([self class], &UIACTIONSHEET_BUTTON_BLOCK_IDENTIFIER, mutableDict, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return actionSheet;
}

-(void)dismiss:(BOOL)animated
{
    [self dismissWithClickedButtonIndex:-1 animated:animated];
}

#pragma mark UIActionSheetDelegate
+ (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSDictionary *dict =  objc_getAssociatedObject([self class], &UIACTIONSHEET_BUTTON_BLOCK_IDENTIFIER);

    //Remove this actionSheet from the dictionary.
    NSMutableDictionary *mutableDict;
    if (dict){
        mutableDict = [dict mutableCopy];
        [mutableDict removeObjectForKey:[NSValue valueWithNonretainedObject:actionSheet]];
    }
    else if(buttonIndex >= 0){ //We never should hit this else.  Possibly put an assert here to verify that.

        NSLog(@"Error: We should not be here!  Some logic error.");
        return;
    }

    //Update the dictionary associated with UIAlertViews.
    if ([mutableDict count])
        objc_setAssociatedObject([self class], &UIACTIONSHEET_BUTTON_BLOCK_IDENTIFIER, mutableDict, OBJC_ASSOCIATION_COPY_NONATOMIC);
    else //or nuke the empty dictionary from UIAlertViews.
        objc_setAssociatedObject([self class], &UIACTIONSHEET_BUTTON_BLOCK_IDENTIFIER, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);

    NSArray *buttonsArray = [dict objectForKey:[NSValue valueWithNonretainedObject:actionSheet]];

    // Action sheets pass back -1 when they're cleared for some reason other than a button being
    // pressed.
    if (buttonIndex >= 0)
    {
        BlockButton *button = [buttonsArray objectAtIndex:buttonIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(button.action)
                button.action();
            if (button.actionWithText)
                button.actionWithText(button.label);
        });
    }
    else if ([buttonsArray count]) {
        //See if the last item in the array is the dismissActionDummy button.
        BlockButton *dismissButton = [buttonsArray objectAtIndex:[buttonsArray count]-1];
        if ([dismissButton.label isEqualToString:UIActionSheetDismissAction]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(dismissButton.action)
                    dismissButton.action();
                if (dismissButton.actionWithText)
                    dismissButton.actionWithText(dismissButton.label);
            });
        }
    }
}

@end
