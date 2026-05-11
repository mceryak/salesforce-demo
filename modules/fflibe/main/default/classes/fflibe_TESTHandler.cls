@IsTest
public without sharing class fflibe_TESTHandler extends fflibe_TriggerHandler {
    
    public static Boolean shouldThrow = false;

    public fflibe_TESTHandler(Account[] accs) {
        this(accs, false);
    }

    public fflibe_TESTHandler(Account[] accs, Boolean enforceCRUD) {
        super(accs, new SObjectType[] { Account.getSObjectType(), Contact.getSObjectType() }, enforceCRUD);
    }
    
    public override void onBeforeInsert() { doInsert(0); }
    public override void onAfterInsert() { doInsert(1); }
    public override void onBeforeUpdate(Map<Id, sObject> existing) { doInsert(2); }
    public override void onAfterUpdate(Map<Id, sObject> existing) { doInsert(3); }
    public override void onBeforeDelete() { doInsert(4); }
    public override void onAfterDelete() { doInsert(5); }
    public override void onAfterUndelete() { doInsert(6); }

    private void doInsert(Integer i) {
        if (shouldThrow) {
            throw new fflibe_TESTHandler.TestHandlerException('test exception');
        }
        Account a = new Account(Name = 'a' + i);
        this.unitOfWork.registerNew(a); 
        Contact c = new Contact(LastName = 'c' + i);
        this.unitOfWork.registerNew(c, Contact.AccountId, a);
    }

    public class TestHandlerException extends Exception {}

}