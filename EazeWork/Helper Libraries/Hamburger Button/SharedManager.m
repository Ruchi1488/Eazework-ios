//
//  SharedManager.m
//  EazeWork
//
//  Created by User1 on 5/4/17.
//  Copyright © 2017 User1. All rights reserved.
//

#import "SharedManager.h"

@implementation SharedManager

@synthesize dictForProfileData;
@synthesize base_URL;
@synthesize sessionID;
@synthesize employeeID;
@synthesize arrayForLeaveBalancesData;
@synthesize popupFor;
@synthesize deviceID;
@synthesize arrayForRHLeaves;
@synthesize dictForUserData;
@synthesize dictEmployeeProfile;
@synthesize headerBGColor;
@synthesize headerTextColor;
@synthesize arrayForMenuData;
@synthesize arrayForMenuDescript;
@synthesize dictForGetTypeWiseList;
@synthesize dictForPayslipData;
@synthesize dictTimeLineData;
@synthesize dictAttendanceStatus;
@synthesize calendarForLeave;
@synthesize isEditOrCreateLocation;
@synthesize officeIDForDetails;
@synthesize isSelfAttendanceHistory;
@synthesize employeeIDForAttendance;
@synthesize teamCount;
@synthesize validForTeamMembers;
@synthesize arrayForEmpID;
@synthesize validForSelfViewProfile;
@synthesize paySlipMonthName;
@synthesize getEmpProfileData;
@synthesize dictForTeamProfileData;
@synthesize arrayForOfficeType;
    @synthesize arrayForMappingMembers;
static SharedManager *instance = nil;

+(SharedManager *)shareData
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [SharedManager new];
        }
    }
    return instance;
}
@end
