
// insert log levels custom settings with default values for apex tests
insert new api_LogLevels__c(SetupOwnerId = UserInfo.getOrganizationId());

// insert log settings
insert new api_LogLevels__c(
    SetupOwnerId = UserInfo.getOrganizationId(),
    api_IRequestHandler__c = 'default',
    LogLevel__c = 1
);