public virtual inherited sharing class fflibe_TriggerSObjectDomain extends fflib_SObjectDomain {
    
    public fflibe_TriggerSObjectDomain(SObject[] records) {
        super(records);
    }

    @TestVisible
    protected SObject[] getChangedToRecords(Schema.SObjectField fieldToken, Object changedToValue) {
        SObject[] changedRecords = new List<SObject>();
        for (SObject newRecord : Records) {
            Object oldVal = ExistingRecords?.get(newRecord.Id)?.get(fieldToken);
            Boolean isInsert = ExistingRecords == null || !ExistingRecords.containsKey(newRecord.Id);
            Boolean isNewRecordMatch = newRecord.get(fieldToken) == changedToValue;
            if (isNewRecordMatch && (isInsert || oldVal != changedToValue)) {
                changedRecords.add(newRecord);
            }
        }
        return changedRecords;
    }

    @TestVisible
    protected SObject[] getChangedToNotNullRecords(Schema.SObjectField fieldToken) {
        SObject[] changedRecords = new List<SObject>();
        for (SObject rec : Records) {
            if (rec.get(fieldToken) != null && ExistingRecords?.get(rec.Id)?.get(fieldToken) == null) {
                changedRecords.add(rec);
            }
        }
        return changedRecords;
    }

}