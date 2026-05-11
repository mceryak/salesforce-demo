// To be extended...
public virtual inherited sharing class fflibe_UnitOfWork extends fflib_SObjectUnitOfWork{

    public fflibe_UnitOfWork(List<Schema.SObjectType> sObjectTypes) {
        super(sObjectTypes);
    }
    public fflibe_UnitOfWork(List<Schema.SObjectType> sObjectTypes, fflib_SObjectUnitOfWork.IDML dml) {
        super(sObjectTypes, dml);
    }

}