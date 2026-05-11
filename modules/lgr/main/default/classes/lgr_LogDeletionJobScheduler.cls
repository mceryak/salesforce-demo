public with sharing class lgr_LogDeletionJobScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new lgr_LogDeletionJob());
    }

    // schedule this class to run on the first of every month at midnight
    public static void scheduleEveryMonth() {
        System.schedule(Test.isRunningTest() ? 'TEST_CustomLogDeletionJob' : 'CustomLogDeletionJob', '0 0 0 1 1/1 ? *', new lgr_LogDeletionJobScheduler());
    }

}