@IsTest 
private class fflibe_UnitOfWorkTest {
    
    @IsTest 
    static void test_init() {
        fflibe_UnitOfWork uow = new fflibe_UnitOfWork(new SObjectType[] { Account.getSObjectType(), Contact.getSObjectType() });
        fflibe_UnitOfWork uow1 = new fflibe_UnitOfWork(new SObjectType[] { Contact.getSObjectType() }, new fflib_SObjectUnitOfWork.SimpleDML());

        System.assertEquals(2, uow.m_sObjectTypes.size());
        System.assertEquals(1, uow1.m_sObjectTypes.size());
    }

}