#include "ISSListController.h"
#import <spawn.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation PSTableCell (QuietDown)
- (void)layoutSubviews {
  [super layoutSubviews];
  if (self.type == 13 && [[self _viewControllerForAncestor] isKindOfClass:NSClassFromString(@"ISSListController")]) {
    self.textLabel.textColor = UIColorFromRGB(0x2ED4B5);
  }
}
@end

@interface FBSSystemService : NSObject
+ (instancetype)sharedService;
- (void)sendActions:(NSSet *)arg1 withResult:(id)arg2 ;
@end

typedef enum {
    None = 0,
    SBSRelaunchOptionsRestartRenderServer = (1 << 0),
    SBSRelaunchOptionsSnapshot = (1 << 1),
    SBSRelaunchOptionsFadeToBlack = (1 << 2),
} SBSRelaunchOptions;

@interface SBSRelaunchAction : NSObject
+ (SBSRelaunchAction *)actionWithReason:(NSString *)reason options:(SBSRelaunchOptions)options targetURL:(NSURL *)url;
@end

@interface SBSRestartRenderServerAction : NSObject
+ (instancetype)restartActionWithTargetRelaunchURL:(NSURL *)targetURL;
@property(readonly, nonatomic) NSURL *targetURL;
@end

@implementation ISSListController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
    self.navigationItem.rightBarButtonItem = applyButton;
    /*UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.view.tintColor = UIColorFromRGB(0x2ED4B5);
    keyWindow.tintColor = UIColorFromRGB(0x2ED4B5);
    [UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]].onTintColor = UIColorFromRGB(0x2ED4B5);*/

}



- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
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

-(void)formatexample {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://nsdateformatter.com"] options:@{} completionHandler:nil];
}
-(void)Paypal {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.paypal.me/Aliary"] options:@{} completionHandler:nil];
}
-(void)AliPay {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://qr.alipay.com/fkx18998myuy6s4yzea7qd7"] options:@{} completionHandler:nil];
}

-(void)qgroup {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://jq.qq.com/?_wv=1027&k=5Lix6sj"] options:@{} completionHandler:nil];
}
-(void)Repo {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://janedut.github.io/repo"] options:@{} completionHandler:nil];
  }

-(void)twitter_skitty {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://mobile.twitter.com/Skittyblock"] options:@{} completionHandler:nil];
  }
-(void)twitter_aohuiliu {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://mobile.twitter.com/AohuiLiu"] options:@{} completionHandler:nil];
  }
-(void)twitter_noisyflake {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://mobile.twitter.com/NoisyFlake"] options:@{} completionHandler:nil];
  }




- (void)realrespring {
    pid_t pid;
    int status;
    const char* args[] = {"killall", "-9", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);
  }

- (void)respring {
    UIAlertController *respring = [UIAlertController alertControllerWithTitle:@"iPadBar13"
                                                                      message:@"Respring to apply? \n If you add cydiakk repo \n some functions will be disabled."
                                                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self realrespring];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [respring addAction:confirmAction];
    [respring addAction:cancelAction];
    [self presentViewController:respring animated:YES completion:nil];
}

@end
