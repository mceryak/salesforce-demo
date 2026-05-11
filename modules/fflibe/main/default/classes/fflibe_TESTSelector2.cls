@IsTest
public inherited sharing class fflibe_TESTSelector2 extends fflib_SObjectSelector {

    public static final fflibe_TESTSelector2 INSTANCE = (fflibe_TESTSelector2)fflibe_APP.SELECTOR.newInstance(Contact.getSObjectType());

    public fflibe_TESTSelector2() {
        super(false, false, false, false);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new Schema.SObjectField[] {
            Contact.Id
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Contact.getSObjectType();
    }

    

}