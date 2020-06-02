// SPSettingsController.h

#import <Preferences/PSListController.h>
#import <UserNotifications/UserNotifications.h>
#import "SPHeaderView.h"
#import <Preferences/PSSliderTableCell.h>


/*@interface UIApplication (Private)
@property (nonatomic, retain) UIStatusBar *statusBar;
@end*/

@interface SPSettingsController : PSListController <UIScrollViewDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, retain) NSMutableDictionary *settings;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, retain) SPHeaderView *headerView;



- (void)layoutHeader;
- (NSBundle *)resourceBundle;

@end
@interface TwitterCell : PSTableCell
@end
@interface LabeledSliderCell : PSSliderTableCell
@end
