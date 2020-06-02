#import "iPadBar13iconPrefsListController.h"
#import <spawn.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation iPadBar13iconPrefsListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.view.tintColor = UIColorFromRGB(0x2ED4B5);
    keyWindow.tintColor = UIColorFromRGB(0x2ED4B5);
    [UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]].onTintColor = UIColorFromRGB(0x2ED4B5);

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
  keyWindow.tintColor = nil;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"iPadBar13icon" target:self] retain];
    }

    return _specifiers;
}



- (id)readPreferenceValue:(PSSpecifier*)specifier {
    NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:path];
    return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:path atomically:YES];
    CFStringRef notificationName = (CFStringRef)specifier.properties[@"PostNotification"];
    if (notificationName) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
    }
}

/*- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    NSString *sub = [specifier propertyForKey:@"LNESub"];
    NSString *title = [specifier name];

    _specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

    [self setTitle:title];
    [self.navigationItem setTitle:title];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
    [self loadFromSpecifier:specifier];
    [super setSpecifier:specifier];
}

- (bool)shouldReloadSpecifiersOnResume {
    return false;
}*/





@end
