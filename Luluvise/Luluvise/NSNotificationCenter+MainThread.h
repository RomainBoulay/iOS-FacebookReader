//
//  NSNotificationCenter+MainThread.h
//  PersonalFramework
//
//  Created by Romain Boulay on 07/09/10.
//  Copyright 2010. All rights reserved.
//

@interface NSNotificationCenter(MainThread)
/* Post given notifcation on main thread */
- (void)postNotificationOnMainThread:(NSNotification *)notification;

/* Post given notifcation name on main thread */
- (void)postNotificationNameOnMainThread:(NSString *)notificationName object:(id)notificationSender;

/* Post given notifcation name on main thread with user info */
- (void)postNotificationNameOnMainThread:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo;

/* Post given notifcation on main thread, allowing to wait until done */
- (void)postNotificationOnMainThread:(NSNotification *)notification waitUntilDone:(BOOL)wait;

/* Post given notifcation name on main thread, allowing to wait until done */
- (void)postNotificationNameOnMainThread:(NSString *)notificationName object:(id)notificationSender waitUntilDone:(BOOL)wait;

/* Post given notifcation name on main thread with user info, allowing to wait until done */
- (void)postNotificationNameOnMainThread:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo waitUntilDone:(BOOL)wait;
@end
