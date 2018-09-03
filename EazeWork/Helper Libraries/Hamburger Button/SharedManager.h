//
//  SharedManager.h
//  EazeWork
//
//  Created by User1 on 5/4/17.
//  Copyright © 2017 User1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SharedManager : NSObject

+(SharedManager*)shareData;

@property NSDictionary *dictForProfileData;
@property NSDictionary *dictForUserData;
@property NSDictionary *dictEmployeeProfile;
@property NSDictionary *dictForGetTypeWiseList;
@property NSDictionary *dictForPayslipData;
@property NSDictionary *dictTimeLineData;
@property NSDictionary *dictAttendanceStatus;
@property NSDictionary *dictForTeamProfileData;

@property NSString *base_URL;
@property NSString *sessionID;

@property NSString *deviceID;
@property NSString *popupFor;
    
@property NSString *paySlipMonthName;
    
@property NSString *officeIDForDetails;
    
@property NSArray *arrayForRHLeaves;
@property NSArray *arrayForLeaveBalancesData;
@property NSArray *arrayForMenuData;
@property NSArray *arrayForOfficeType;
@property NSArray *arrayForMappingMembers;
@property NSMutableArray *arrayForMenuDescript;
    
@property NSInteger employeeID;

// mohit

@property NSString *onBehalfEmpID;
@property BOOL isOnBehalfLeaveApplied;

@property UIColor *headerBGColor;
@property UIColor *headerTextColor;

@property NSInteger calendarForLeave;
@property NSInteger isEditOrCreateLocation;

@property NSInteger isSelfAttendanceHistory;
@property NSString *employeeIDForAttendance;
@property NSInteger teamCount;
@property NSInteger validForTeamMembers;
@property NSMutableArray *arrayForEmpID;
@property NSInteger validForSelfViewProfile;

@property NSInteger getEmpProfileData; // 0 - No, 1 - Yes
// var headerBGColor = UIColor()
//var headerTextColor  = UIColor()
@end
