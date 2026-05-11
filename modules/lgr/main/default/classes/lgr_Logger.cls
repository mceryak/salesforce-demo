public without sharing class lgr_Logger {
    
    public enum LogLevel { // IN ORDER!
        CRITICAL, WARNING, INFO, DEBUG
    }

    // PUBLIC METHODS

    public static void log(String className, String methodName, String message, String parameters, String stackTrace, LogLevel level) {
        if (validateLogLevelSettings(className, level)) { 
            createLog(className, methodName, parameters, stackTrace, message, level); 
        }
    }

    public static void log(Exception e, String className, String methodName, String parameters) {
        logImmediately(className, methodName, e.getMessage(), parameters, e.getStackTraceString(), LogLevel.CRITICAL);
    }

    public static void logImmediately(String className, String methodName, String message, String parameters, String stackTrace, LogLevel level) {
        if (validateLogLevelSettings(className, level)) {
            lgr_LogEvent__e e = new lgr_LogEvent__e(
                Class__c = className,
                Level__c = level.name(),
                Message__c = message,
                Method__c = methodName,
                Occured__c = DateTime.now(),
                Parameters__c = parameters,
                Save__c = false,
                StackTrace__c = stackTrace
            );
            EventBus.publish(e);
        }
    }


    // PRIVATE METHODS

    // Determines if log record should be created based on lgr_LogLevels__c custom setting.
    // If no setting is found, only validate if it is a CRITICAL Log Level.
    private static Boolean validateLogLevelSettings(String className, LogLevel level) {
        String fieldName = className + '__c';
        try {
            String setting = (String)lgr_LogLevels__c.getInstance(UserInfo.getUserId()).get(fieldName);
            return level.ordinal() <= LogLevel.valueOf(setting).ordinal();
        } catch (Exception e) {
            return level == LogLevel.CRITICAL;
        }
    }

    private static void createLog(String className, String methodName, String parameters, String stackTrace, String message, LogLevel level) {
        lgr_Log__c log = new lgr_Log__c(
            Class__c = className,
            Method__c = methodName,
            Message__c = message,
            StackTrace__c = stackTrace,
            Parameters__c = parameters,
            Level__c = level.name(),
            Occured__c = System.now()
        );
        if (!System.isBatch() && !System.isFuture()) {
            insertLogFuture(JSON.serialize(log));
        } else {
            handleLogInsert(log);
        }
    }

    @TestVisible
    private static void handleLogInsert(lgr_Log__c log) {
        try {
            insert log;
        } catch (Exception e) {
            System.debug('failed to insert custom log because of exception: ' + e.getMessage() + ', ' + e.getStackTraceString());
        }
    }

    @future
    private static void insertLogFuture(String jsonLog) {
        lgr_Log__c log = (lgr_Log__c)JSON.deserialize(jsonLog, lgr_Log__c.class);
        handleLogInsert(log);
    }

}