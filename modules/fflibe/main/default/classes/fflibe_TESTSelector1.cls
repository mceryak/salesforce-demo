@IsTest
public inherited sharing class fflibe_TESTSelector1 extends fflib_SObjectSelector {

    public static final fflibe_TESTSelector1 INSTANCE = (fflibe_TESTSelector1)fflibe_APP.SELECTOR.newInstance(Account.getSObjectType());

    public fflibe_TESTSelector1() {
        super(false, false, false, false);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new Schema.SObjectField[] {
            Account.Id
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Account.getSObjectType();
    }

    

}