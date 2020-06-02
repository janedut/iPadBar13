#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import "SkittyPrefs/SPSettingsController.h"


@interface ISSListController : SPSettingsController

@property (nonatomic, retain) UIImageView *pikaView;

@end

@interface PSTableCell (QuietDown)
@end
/*@interface UIView (Private)
- (id)_viewControllerForAncestor;
@end*/
