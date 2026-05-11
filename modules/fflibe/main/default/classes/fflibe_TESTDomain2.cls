@IsTest
public inherited sharing class fflibe_TESTDomain2 extends fflib_SObjectDomain {

    /*********************
    * DEFAULT DOMAIN CODE
    *********************/

    Contact[] castedRecords { get { return (Contact[])Records; } }

    public static Fflibe_TESTDomain2 newInstance(Contact[] records) {
        return (Fflibe_TESTDomain2)fflibe_APP.DOMAIN.newInstance(records);
    }

    public Fflibe_TESTDomain2(Contact[] records) {
        super(records);
    }

    public class Constructor implements fflib_IDomainConstructor {
        public fflib_SObjects construct(List<Object> objectList) {
            return new Fflibe_TESTDomain2((List<SObject>) objectList);
        }
    }


    /*********************
    * DOMAIN METHODS
    *********************/

    

}