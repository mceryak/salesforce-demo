public without sharing class lgr_LogDeletionJob implements Database.Batchable<SObject> {
    
    // query all records where Save__c is not true and that occur before the date given in constructor
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Integer lifetimeInMonths = Integer.valueOf(lgr_LogSettings__c.getInstance(UserInfo.getUserId()).LogLifetimeInMonths__c);
        return Database.getQueryLocator('SELECT Id FROM lgr_Log__c WHERE Save__c != TRUE AND Occured__c < LAST_N_MONTHS:' + lifetimeInMonths);
    }

    public void execute(Database.BatchableContext bc, sObject[] logs) {
        delete logs;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Finished CustomLogDeletionJob');
    }
}