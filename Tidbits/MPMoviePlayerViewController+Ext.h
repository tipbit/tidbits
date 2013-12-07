//
//  MPMoviePlayerViewController+Ext.h
//  Tidbits
//
//  Created by Ewan Mellor on 12/6/13.
//  Copyright (c) 2013 Tipbit, Inc. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "StandardBlocks.h"


@interface MPMoviePlayerViewController (Ext)

/**
 * Call [vc presentMoviePlayerViewControllerAnimated:self] to present this MPMoviePlayerViewController modally.
 * Handle MPMoviePlayerPlaybackDidFinishNotification, and call onCompletion when that occurs.
 *
 * Must be called on the main thread.
 *
 * @param onCompletion May be nil.  If set, will be called on the main thread when MPMoviePlayerPlaybackDidFinishNotification fires.
 */
-(void)playModal:(UIViewController*)vc onCompletion:(VoidBlock)onCompletion __attribute__((nonnull(1)));

@end
