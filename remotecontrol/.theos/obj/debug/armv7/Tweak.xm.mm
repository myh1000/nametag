#line 1 "Tweak.xm"
#import "substrate.h"
#import "SpringBoard/SpringBoard.h"

static NSString* originalPasscode;

#include <logos/logos.h>
#include <substrate.h>
@class SBDeviceLockController; @class SBUIPasscodeLockViewWithKeypad; @class SBLockScreenViewController; 
static void (*_logos_orig$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOn$)(SBLockScreenViewController*, SEL, id); static void _logos_method$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOn$(SBLockScreenViewController*, SEL, id); static BOOL (*_logos_orig$_ungrouped$SBDeviceLockController$attemptDeviceUnlockWithPassword$appRequested$)(SBDeviceLockController*, SEL, NSString *, BOOL); static BOOL _logos_method$_ungrouped$SBDeviceLockController$attemptDeviceUnlockWithPassword$appRequested$(SBDeviceLockController*, SEL, NSString *, BOOL); static id (*_logos_orig$_ungrouped$SBUIPasscodeLockViewWithKeypad$statusTitleView)(SBUIPasscodeLockViewWithKeypad*, SEL); static id _logos_method$_ungrouped$SBUIPasscodeLockViewWithKeypad$statusTitleView(SBUIPasscodeLockViewWithKeypad*, SEL); 

#line 6 "Tweak.xm"

static void _logos_method$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOn$(SBLockScreenViewController* self, SEL _cmd, id arg1) {
	HBLogDebug(@"-[<SBLockScreenViewController: %p> _handleDisplayTurnedOn:%@]", self, arg1);

	
	
	if ([self _notificationController].hasAnyContent) {
		_logos_orig$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOn$(self, _cmd, arg1);
		return;
	}
	
	else {
		
		if (!originalPasscode) {
			[((SBLockScreenView*)self.view) scrollToPage:0 animated:NO];
		}
		else {
			
			[SBDeviceLockController attemptUnlockWithPasscode:originalPasscode];
		}
	}
}



static BOOL _logos_method$_ungrouped$SBDeviceLockController$attemptDeviceUnlockWithPassword$appRequested$(SBDeviceLockController* self, SEL _cmd, NSString * passcode, BOOL requested) {
	BOOL r = _logos_orig$_ungrouped$SBDeviceLockController$attemptDeviceUnlockWithPassword$appRequested$(self, _cmd, passcode, requested);
	if (r && !originalPasscode) {
		originalPasscode = passcode;
	}

	return r;
}



static id _logos_method$_ungrouped$SBUIPasscodeLockViewWithKeypad$statusTitleView(SBUIPasscodeLockViewWithKeypad* self, SEL _cmd) {
	
    if (!originalPasscode) {
        UILabel *label = MSHookIvar<UILabel *>(self, "_statusTitleView");
        label.text = @"QuickLock requires your passcode each respring";
        return label;
    }
    return _logos_orig$_ungrouped$SBUIPasscodeLockViewWithKeypad$statusTitleView(self, _cmd);
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBLockScreenViewController = objc_getClass("SBLockScreenViewController"); if (_logos_class$_ungrouped$SBLockScreenViewController) {if (class_getInstanceMethod(_logos_class$_ungrouped$SBLockScreenViewController, @selector(_handleDisplayTurnedOn:))) {MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenViewController, @selector(_handleDisplayTurnedOn:), (IMP)&_logos_method$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOn$, (IMP*)&_logos_orig$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOn$);} else {HBLogError(@"logos: message not found [%s %s]", "SBLockScreenViewController", "_handleDisplayTurnedOn:");}} else {HBLogError(@"logos: nil class %s", "SBLockScreenViewController");}Class _logos_class$_ungrouped$SBDeviceLockController = objc_getClass("SBDeviceLockController"); if (_logos_class$_ungrouped$SBDeviceLockController) {if (class_getInstanceMethod(_logos_class$_ungrouped$SBDeviceLockController, @selector(attemptDeviceUnlockWithPassword:appRequested:))) {MSHookMessageEx(_logos_class$_ungrouped$SBDeviceLockController, @selector(attemptDeviceUnlockWithPassword:appRequested:), (IMP)&_logos_method$_ungrouped$SBDeviceLockController$attemptDeviceUnlockWithPassword$appRequested$, (IMP*)&_logos_orig$_ungrouped$SBDeviceLockController$attemptDeviceUnlockWithPassword$appRequested$);} else {HBLogError(@"logos: message not found [%s %s]", "SBDeviceLockController", "attemptDeviceUnlockWithPassword:appRequested:");}} else {HBLogError(@"logos: nil class %s", "SBDeviceLockController");}Class _logos_class$_ungrouped$SBUIPasscodeLockViewWithKeypad = objc_getClass("SBUIPasscodeLockViewWithKeypad"); if (_logos_class$_ungrouped$SBUIPasscodeLockViewWithKeypad) {if (class_getInstanceMethod(_logos_class$_ungrouped$SBUIPasscodeLockViewWithKeypad, @selector(statusTitleView))) {MSHookMessageEx(_logos_class$_ungrouped$SBUIPasscodeLockViewWithKeypad, @selector(statusTitleView), (IMP)&_logos_method$_ungrouped$SBUIPasscodeLockViewWithKeypad$statusTitleView, (IMP*)&_logos_orig$_ungrouped$SBUIPasscodeLockViewWithKeypad$statusTitleView);} else {HBLogError(@"logos: message not found [%s %s]", "SBUIPasscodeLockViewWithKeypad", "statusTitleView");}} else {HBLogError(@"logos: nil class %s", "SBUIPasscodeLockViewWithKeypad");}} }
#line 52 "Tweak.xm"
