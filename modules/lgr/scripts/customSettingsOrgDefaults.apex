
// insert log levels custom settings with default values for apex tests
insert new lgr_LogLevels__c(SetupOwnerId = UserInfo.getOrganizationId());

// insert log settings
insert new lgr_LogSettings__c(
    SetupOwnerId = UserInfo.getOrganizationId(), 
    LogLifetimeInMonths__c = 3 // feel free to change
);