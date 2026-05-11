@isTest
private class fflibe_TriggerHandlerTest {
    
    @TestSetup
    static void makeData() {
        fflibe_TriggerSwitches__c defaultTS = new fflibe_TriggerSwitches__c(SetupOwnerId=UserInfo.getOrganizationId(), fflibe_TESTHandler__c = true);
        insert defaultTS;
    }

    @IsTest 
    static void test_isTriggerActive() {
        fflibe_TESTHandler h = new fflibe_TESTHandler(new Account[] {});

        // test org defaults
        System.assertEquals(true, h.isTriggerActive);
        fflibe_TriggerSwitches__c defaultTS = fflibe_TriggerSwitches__c.getOrgDefaults();
        defaultTS.fflibe_TESTHandler__c = false;
        update defaultTS;
        System.assertEquals(false, h.isTriggerActive);

        // test for user instance
        fflibe_TriggerSwitches__c userTS = new fflibe_TriggerSwitches__c(SetupOwnerId=UserInfo.getUserId(), fflibe_TESTHandler__c = true);
        insert userTS;
        System.assertEquals(true, h.isTriggerActive);
        userTS.fflibe_TESTHandler__c = false;
        update userTS;
        System.assertEquals(false, h.isTriggerActive);
    }

    @IsTest 
    static void test_getHandlerName() {
        fflibe_TESTHandler h = new fflibe_TESTHandler(new Account[] {});
        System.assertEquals('fflibe_TESTHandler', h.getHandlerName());
    }


    @IsTest 
    static void test_init() {
        Test.startTest();
        fflibe_TriggerHandler h = new fflibe_TriggerHandler(new Account[] {}, new SObjectType[] { Account.getSObjectType(), Contact.getSObjectType() });
        Test.stopTest();
        
        System.assertEquals(2, h.unitOfWork.m_sObjectTypes.size()); 
        System.assertEquals(true, h.unitOfWork.m_sObjectTypes.contains(Account.getSObjectType()));
        System.assertEquals(true, h.unitOfWork.m_sObjectTypes.contains(Contact.getSObjectType()));

        assertIsTestHandlerEnabled(true);

        System.assertEquals(false, h.Configuration.EnforcingTriggerCRUDSecurity, 'by default, do not enforce crud security');
    }

    @IsTest 
    static void test_init_bypassed_enforceCRUD() {
        fflibe_TriggerSwitches__c defaultTS = fflibe_TriggerSwitches__c.getOrgDefaults();
        defaultTS.fflibe_TESTHandler__c = false;
        update defaultTS;

        Test.startTest();
        fflibe_TESTHandler h = new fflibe_TESTHandler(new Account[] {}, true);
        Test.stopTest();

        System.assertEquals(2, h.unitOfWork.m_sObjectTypes.size()); 
        System.assertEquals(true, h.unitOfWork.m_sObjectTypes.contains(Account.getSObjectType()));
        System.assertEquals(true, h.unitOfWork.m_sObjectTypes.contains(Contact.getSObjectType()));

        assertIsTestHandlerEnabled(false);

        System.assertEquals(true, h.Configuration.EnforcingTriggerCRUDSecurity);
    }

    @IsTest 
    static void test_logAndThrow() {
        Test.startTest();
        fflibe_TESTHandler h = new fflibe_TESTHandler(new Account[] {});
        fflibe_TESTHandler.shouldThrow = true;
        try {
            h.handleBeforeInsert();
            System.assert(false, 'should have thrown');
        } catch (fflibe_TESTHandler.TestHandlerException e) {
            // expected error
        }
        Test.stopTest();
    }

    @IsTest 
    static void testBypass() {
        assertIsTestHandlerEnabled(true);
        fflibe_TriggerHandler.bypass(fflibe_TESTHandler.class);
        assertIsTestHandlerEnabled(false);
        fflibe_TriggerHandler.clearBypass(fflibe_TESTHandler.class);
        assertIsTestHandlerEnabled(true);
    }


    // TEST TRIGGER CONTEXT METHODS

    @IsTest 
    static void test_beforeInsert() {
        Test.startTest();
        fflibe_TESTHandler h = new fflibe_TESTHandler(new Account[] {});
        h.handleBeforeInsert();
        Test.stopTest();

        assertUnitOfWork(0);
    }

    @IsTest 
    static void test_afterInsert() {
        Test.startTest();
        fflibe_TESTHandler h = new fflibe_TESTHandler(new Account[] {});
        h.handleAfterInsert();
        Test.stopTest();

        assertUnitOfWork(1);
    }

    @IsTest 
    static void test_beforeUpdate() {
        Test.startTest();
        fflibe_TESTHandler h = new fflibe_TESTHandler(new Account[] {});
        h.handleBeforeUpdate(new Map<Id, Account>());
        Test.stopTest();

        assertUnitOfWork(2);
    }

    @IsTest 
    static void test_afterUpdate() {
        Test.startTest();
        fflibe_TESTHandler h = new fflibe_TESTHandler(new Account[] {});
        h.handleAfterUpdate(new Map<Id, Account>());
        Test.stopTest();

        assertUnitOfWork(3);
    }

    @IsTest 
    static void test_beforeDelete() {
        Test.startTest();
        fflibe_TESTHandler h = new fflibe_TESTHandler(new Account[] {});
        h.handleBeforeDelete();
        Test.stopTest();

        assertUnitOfWork(4);
    }

    @IsTest 
    static void test_afterDelete() {
        Test.startTest();
        fflibe_TESTHandler h = new fflibe_TESTHandler(new Account[] {});
        h.handleAfterDelete();
        Test.stopTest();

        assertUnitOfWork(5);
    }

    @IsTest 
    static void test_afterUndelete() {
        Test.startTest();
        fflibe_TESTHandler h = new fflibe_TESTHandler(new Account[] {});
        h.handleAfterUndelete();
        Test.stopTest();

        assertUnitOfWork(6);
    }


    // HELPER METHODS

    static void assertUnitOfWork(Integer i) {
        Contact c = [SELECT LastName, Account.Name FROM Contact];
        System.assertNotEquals(null, c.Account.Name, 'unit of work should have committed insert of contact and account');
        System.assertEquals('c' + i, c.LastName);
        System.assertEquals('a' + i, c.Account.Name);
    }

    static void assertIsTestHandlerEnabled(Boolean assertVal) {
        fflib_SObjectDomain.TriggerEvent triggerEvt = fflib_SObjectDomain.TriggerEventByClass.get(fflibe_TESTHandler.class);
        if (assertVal && triggerEvt == null) {
            return; // if null, then by default the handler is enabled
        }
        System.assertNotEquals(null, triggerEvt);
        System.assertEquals(assertVal, triggerEvt.BeforeInsertEnabled);
        System.assertEquals(assertVal, triggerEvt.AfterInsertEnabled);
        System.assertEquals(assertVal, triggerEvt.BeforeUpdateEnabled);
        System.assertEquals(assertVal, triggerEvt.AfterUpdateEnabled);
        System.assertEquals(assertVal, triggerEvt.BeforeDeleteEnabled);
        System.assertEquals(assertVal, triggerEvt.AfterDeleteEnabled);
        System.assertEquals(assertVal, triggerEvt.AfterUndeleteEnabled);
    }

}