#import "substrate.h"
#import "SpringBoard/SpringBoard.h"

static NSString* originalPasscode;

%hook SBLockScreenViewController
-(void)_handleDisplayTurnedOn:(id)arg1 {
	%log;

	//check if there are pending notifications
	//if there are notifications, just run the original IMP
	if ([self _notificationController].hasAnyContent) {
		%orig;
		return;
	}
	//if there aren't, quick unlock
	else {
		//if we don't have the original password cached, scroll to the passcode page and tell them what's going on
		if (!originalPasscode) {
			[((SBLockScreenView*)self.view) scrollToPage:0 animated:NO];
		}
		else {
			//quick unlock
			[SBDeviceLockController attemptUnlockWithPasscode:originalPasscode];
		}
	}
}
%end

%hook SBDeviceLockController
-(BOOL)attemptDeviceUnlockWithPassword:(NSString *)passcode appRequested:(BOOL)requested {
	BOOL r = %orig;
	if (r && !originalPasscode) {
		originalPasscode = passcode;
	}

	return r;
}
%end

%hook SBUIPasscodeLockViewWithKeypad
- (id)statusTitleView {
	//if we do not yet have the cached password
    if (!originalPasscode) {
        UILabel *label = MSHookIvar<UILabel *>(self, "_statusTitleView");
        label.text = @"QuickLock requires your passcode each respring";
        return label;
    }
    return %orig;
}
%end
