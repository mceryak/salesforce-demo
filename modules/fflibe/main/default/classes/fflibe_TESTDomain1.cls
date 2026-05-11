@IsTest
public inherited sharing class fflibe_TESTDomain1 extends fflib_SObjectDomain {

    /*********************
    * DEFAULT DOMAIN CODE
    *********************/

    Account[] castedRecords { get { return (Account[])Records; } }

    public static fflibe_TESTDomain1 newInstance(Account[] records) {
        return (Fflibe_TESTDomain1)fflibe_APP.DOMAIN.newInstance(records);
    }

    public fflibe_TESTDomain1(Account[] records) {
        super(records);
    }

    public class Constructor implements fflib_IDomainConstructor {
        public fflib_SObjects construct(List<Object> objectList) {
            return new Fflibe_TESTDomain1((List<SObject>) objectList);
        }
    }


    /*********************
    * DOMAIN METHODS
    *********************/



}