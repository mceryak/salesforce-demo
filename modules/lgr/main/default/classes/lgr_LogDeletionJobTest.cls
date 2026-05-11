@IsTest 
private class lgr_LogDeletionJobTest {
    @TestSetup
    static void makeData(){
        lgr_LogSettings__c settings = new lgr_LogSettings__c(LogLifetimeInMonths__c = 3, SetupOwnerId = UserInfo.getOrganizationId());
        insert settings;
        Date today = Date.today();
        lgr_Log__c clOld = new lgr_Log__c(Occured__c = today.addMonths(-4), Class__c = 'TestClassDIE');   
        lgr_Log__c clOld1 = new lgr_Log__c(Occured__c = today.addMonths(-7), Class__c = 'TestClassDIE');   
        lgr_Log__c clNew = new lgr_Log__c(Occured__c = today.addMonths(-3).addDays(1), Class__c = 'TestClassLIVE');
        lgr_Log__c clNew1 = new lgr_Log__c(Occured__c = today.addDays(-1), Class__c = 'TestClassLIVE');
        insert new lgr_Log__c[] { clOld, clOld1, clNew, clNew1 };
    }

    @IsTest 
    static void testBatchJob() {
        Test.startTest();
        Database.executeBatch(new lgr_LogDeletionJob());
        Test.stopTest();
        lgr_Log__c[] logs = [SELECT Occured__c, Class__c FROM lgr_Log__c];
        System.assertEquals(2, logs.size());
        for (lgr_Log__c log : logs) { System.assertEquals('TestClassLIVE', log.Class__c); }
    }

    @IsTest 
    static void testScheduler() {
        Test.startTest();
        lgr_LogDeletionJobScheduler.scheduleEveryMonth();
        Test.stopTest();
        AsyncApexJob job = [SELECT Status FROM AsyncApexJob WHERE JobType = 'BatchApex' AND ApexClass.Name = 'lgr_LogDeletionJob' LIMIT 1];
        System.assertEquals('Queued', job.Status);
    }

}