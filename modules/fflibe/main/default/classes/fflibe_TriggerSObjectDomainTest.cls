@IsTest 
private class fflibe_TriggerSObjectDomainTest {
    
    @IsTest 
    static void testGetChangedToRecords() {
        Account[] accs = new List<Account>();
        for (Integer i = 0; i < 9; i++) {
            accs.add(new Account(Name = 'a' + i));
        }
        fflibe_TESTHandler handler = new fflibe_TESTHandler(accs);

        // null oldMap should return all sobjects that have the given value
        handler.ExistingRecords = null;
        Account[] accounts = handler.getChangedToRecords(Account.Name, 'a3');
        System.assertEquals(1, accounts.size());
        System.assertEquals('a3', accounts[0].Name);

        // oldMap that does not contain key should return the sobject with the given value
        handler.ExistingRecords = new Map<Id, SObject>();
        accounts = handler.getChangedToRecords(Account.Name, 'a4');
        System.assertEquals(1, accounts.size());
        System.assertEquals('a4', accounts[0].Name);

        // oldMap has key and has differing value from new record, so should return the new record
        Id accId = fflib_IDGenerator.generate(Account.getSObjectType());
        handler.Records[4].Id = accId;
        handler.ExistingRecords.put(handler.Records[4].Id, new Account(Name = 'aa4', Id = accId));
        accounts = handler.getChangedToRecords(Account.Name, 'a4');
        System.assertEquals(1, accounts.size(), 'oldMap has key and has differing value from new record, so should return the new record');
        System.assertEquals('a4', accounts[0].Name);
        System.assertEquals(accId, accounts[0].Id);

        // oldMap has key but same value as new record, so should NOT return the new record
        accId = fflib_IDGenerator.generate(Account.getSObjectType());
        handler.Records[4].Id = accId;
        handler.ExistingRecords.put(handler.Records[4].Id, new Account(Name = 'a4', Id = accId));
        accounts = handler.getChangedToRecords(Account.Name, 'a4');
        System.assertEquals(0, accounts.size());

        // oldAcc.Name = 'a4';
        // accounts = handler.getChangedToRecords(Account.Name, 'a4');
        // System.assertEquals(0, accounts.size(), 'value did not change between old and new map, so it should not return any results');
    }

    @IsTest 
    static void test_getChangedToNotNullRecords() {
        Account[] accs = new List<Account>();
        for (Integer i = 0; i < 9; i++) {
            accs.add(new Account(Name = i >= 2 ? null : 'a' + i, Id = fflib_IDGenerator.generate(Account.getSObjectType())));
        }
        fflibe_TESTHandler handler = new fflibe_TESTHandler(accs);

        // null oldMap should return all sobjects that have non-null value
        handler.ExistingRecords = null;
        Account[] accounts = handler.getChangedToNotNullRecords(Account.Name);
        System.assertEquals(2, accounts.size());
        System.assertEquals(accs[0], accounts[0]);
        System.assertEquals(accs[1], accounts[1]);

        // oldMap that does not contain key should return all sobjects with non-null value
        handler.ExistingRecords = new Map<Id, SObject>();
        accounts = handler.getChangedToNotNullRecords(Account.Name);
        System.assertEquals(2, accounts.size());
        System.assertEquals(accs[0], accounts[0]);
        System.assertEquals(accs[1], accounts[1]);

        // oldMap has key and has non-null value, should not return        
        handler.ExistingRecords.put(accs[0].Id, new Account(Name = 'some name', Id = accs[0].Id));
        // oldMap has key and has null value, should return
        handler.ExistingRecords.put(accs[1].Id, new Account(Name = null, Id = accs[1].Id));
        accounts = handler.getChangedToNotNullRecords(Account.Name);
        System.assertEquals(1, accounts.size());
        System.assertEquals(accs[1], accounts[0]);
    }

}