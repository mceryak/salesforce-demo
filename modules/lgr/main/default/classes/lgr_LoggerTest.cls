@isTest
private class lgr_LoggerTest {

    private class TestException extends Exception {}

    @TestSetup
    static void makeData(){
        lgr_LogLevels__c defaultSetting = new lgr_LogLevels__c(SetupOwnerId=UserInfo.getOrganizationId());
        defaultSetting.put('ZZZ_TEST_C__c', lgr_Logger.LogLevel.CRITICAL.name());
        defaultSetting.put('ZZZ_TEST_W__c', lgr_Logger.LogLevel.WARNING.name());
        defaultSetting.put('ZZZ_TEST_I__c', lgr_Logger.LogLevel.INFO.name());
        defaultSetting.put('ZZZ_TEST_D__c', lgr_Logger.LogLevel.DEBUG.name());
        insert defaultSetting;
    }

    @IsTest 
    static void testLogFields() {
        Test.startTest();
        DateTime beforeOccured = System.now().addSeconds(-1);
        lgr_Logger.log('ZZZ_TEST_C', 'methodB', 'Message C', 'Params C', 'Stack F', lgr_Logger.LogLevel.CRITICAL);
        DateTime afterOccured = System.now().addSeconds(1);
        Test.stopTest();
        assertLogFields(beforeOccured, afterOccured, 'ZZZ_TEST_C', 'methodB', 'Message C', 'Stack F', lgr_Logger.LogLevel.CRITICAL, 'Params C');
    }

    @IsTest 
    static void testLogException() { // ! this also tests the lgr_LogEvent__e platform-event-triggered flow, so be sure that is activated!
        Test.startTest();
        DateTime beforeOccured = System.now().addSeconds(-1);
        TestException e = new TestException('uh oh!');
        lgr_Logger.log(e, 'ZZZ_TEST_C', 'method1', 'params1');
        DateTime afterOccured = System.now().addSeconds(1);
        Test.stopTest();
        assertLogFields(beforeOccured, afterOccured, 'ZZZ_TEST_C', 'method1', 'uh oh!', e.getStackTraceString(), lgr_Logger.LogLevel.CRITICAL, 'params1');
    }

    @IsTest 
    static void testLogCritical() {
        Test.startTest();
        lgr_Logger.log('ZZZ_TEST_C', 'methodB', 'Message C', 'Params C', 'Stack F', lgr_Logger.LogLevel.CRITICAL);
        lgr_Logger.log('ZZZ_TEST_W', 'methodB', 'Message W', 'Params C', 'Stack F', lgr_Logger.LogLevel.CRITICAL);
        lgr_Logger.log('ZZZ_TEST_I', 'methodB', 'Message I', 'Params C', 'Stack F', lgr_Logger.LogLevel.CRITICAL);
        lgr_Logger.log('ZZZ_TEST_D', 'methodB', 'Message D', 'Params C', 'Stack F', lgr_Logger.LogLevel.CRITICAL);
        lgr_Logger.log('Not a class', 'methodB', 'Message X', 'Params C', 'Stack F', lgr_Logger.LogLevel.CRITICAL); // still should be logged since it is critical
        DateTime afterOccured = System.now().addSeconds(1);
        Test.stopTest();
        lgr_Log__c[] logs = [SELECT Id, Class__c FROM lgr_Log__c];
        System.assertEquals(5, logs.size(), 'all logs should have been created.');
    }

    @IsTest 
    static void testLogWarning() {
        Test.startTest();
        lgr_Logger.log('ZZZ_TEST_C', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.WARNING);
        lgr_Logger.log('ZZZ_TEST_W', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.WARNING);
        lgr_Logger.log('ZZZ_TEST_I', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.WARNING);
        lgr_Logger.log('ZZZ_TEST_D', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.WARNING);
        lgr_Logger.log('Not a class', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.WARNING);
        Test.stopTest();
        lgr_Log__c[] logs = [SELECT Id, Class__c FROM lgr_Log__c];
        System.assertEquals(3, logs.size());
        // make sure the correct logs were created
        for (lgr_Log__c log : logs) {
            System.assertNotEquals('ZZZ_TEST_C', log.Class__c);
            System.assertNotEquals('Not a class', log.Class__c);
        }
    }

    @IsTest 
    static void testLogInfo() {
        Test.startTest();
        lgr_Logger.log('ZZZ_TEST_C', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.INFO);
        lgr_Logger.log('ZZZ_TEST_W', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.INFO);
        lgr_Logger.log('ZZZ_TEST_I', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.INFO);
        lgr_Logger.log('ZZZ_TEST_D', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.INFO);
        lgr_Logger.log('Not a class', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.INFO);
        Test.stopTest();
        lgr_Log__c[] logs = [SELECT Id, Class__c FROM lgr_Log__c];
        System.assertEquals(2, logs.size());
        // make sure the correct logs were created
        for (lgr_Log__c log : logs) {
            System.assertNotEquals('ZZZ_TEST_C', log.Class__c);
            System.assertNotEquals('Not a class', log.Class__c);
            System.assertNotEquals('ZZZ_TEST_W', log.Class__c);
        }
    }

    @IsTest 
    static void testLogDebug() {
        Test.startTest();
        lgr_Logger.log('ZZZ_TEST_C', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.DEBUG);
        lgr_Logger.log('ZZZ_TEST_W', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.DEBUG);
        lgr_Logger.log('ZZZ_TEST_I', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.DEBUG);
        lgr_Logger.log('ZZZ_TEST_D', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.DEBUG);
        lgr_Logger.log('Not a class', 'methodB', 'Message A', 'Params C', 'Stack F', lgr_Logger.LogLevel.DEBUG);
        Test.stopTest();
        lgr_Log__c[] logs = [SELECT Id, Class__c FROM lgr_Log__c];
        System.assertEquals(1, logs.size());
        // make sure the correct logs were created
        System.assertEquals('ZZZ_TEST_D', logs[0].Class__c);
    }

    static void assertLogFields(DateTime beforeOccured, DateTime afterOccured, String className, String method, String message, String stackTrace, lgr_Logger.LogLevel logLevel, String params) {
        lgr_Log__c[] logs = [SELECT Class__c, Method__c, Parameters__c, Level__c, StackTrace__c, Message__c, Occured__c FROM lgr_Log__c];
        system.assertEquals(1, logs.size());
        lgr_Log__c log = logs[0];
        System.assertEquals(className, log.Class__c);
        System.assertEquals(method, log.Method__c);
        System.assertEquals(message, log.Message__c);
        System.assertEquals(stackTrace, log.StackTrace__c);
        System.assertEquals(logLevel.name(), log.Level__c);
        System.assertEquals(params, log.Parameters__c);
        System.assert(log.Occured__c < afterOccured && log.Occured__c > beforeOccured, 'Occured__c time is not accurate. log.Occured = ' + log.Occured__c + ', beforeOccured = ' + beforeOccured + ', afterOccured = ' + afterOccured);
    }
}