public virtual without sharing class fflibe_TriggerHandler extends fflibe_TriggerSObjectDomain {
    
    @TestVisible
    protected fflibe_UnitOfWork unitOfWork;
    
    public fflibe_TriggerHandler(SObject[] records, SObjectType[] unitOfWorkSObjectTypes) {
        this(records, unitOfWorkSObjectTypes, false); // default to disabling CRUD security
    }

    public fflibe_TriggerHandler(SObject[] records, SObjectType[] unitOfWorkSObjectTypes, Boolean enableCRUDSecurity) {
        super(records);

        // set up the unit of work that gets committed at the end of each trigger context method
        if (unitOfWorkSObjectTypes != null && !unitOfWorkSObjectTypes.isEmpty()) {
            this.unitOfWork = new fflibe_UnitOfWork(unitOfWorkSObjectTypes);
        }

        // if custom settings is configured to bypass this trigger, make sure the context methods do not run
        if (!isTriggerActive) {
            fflibe_TriggerHandler.bypass(Type.forName(getHandlerName()));
        }

        // determine if we should check for create, read, update, delete access before running trigger methods
        if (!enableCRUDSecurity) {
            Configuration.disableTriggerCRUDSecurity();
        }
    }

    @TestVisible
    private Boolean isTriggerActive {
        get {
            try {
                // field name is the name of the handler + __c
                return (Boolean)fflibe_TriggerSwitches__c.getInstance(UserInfo.getUserId()).get(getHandlerName() + '__c') ?? true;
            } catch (Exception e) {
                // trigger is active by default, if there is no configuration set up (or is set up incorrectly)
                return true;
            }
        }
    }

    @TestVisible
    private String getHandlerName() {
        Integer len = String.valueOf(this).indexOf(':');
        if(len > 0) {
            return String.valueOf(this).substring(0,len);
        } else {
            return String.valueOf(this);
        }    
    }

    protected void commitWork() {
        this.unitOfWork?.commitWork();
    }

    @TestVisible
    void logAndThrow(Exception e, String triggerContextMethod) { 
        // lgr_Logger.SHARED.log(getHandlerName(), triggerContextMethod, e.getMessage(), 'Records = ' + Records + (ExistingRecords != null ? ' ... Existing Records = ' + ExistingRecords : ''), e.getStackTraceString(), lgr_Logger.LogLevel.CRITICAL);
        lgr_Logger.log(e, getHandlerName(), triggerContextMethod, 'Records = ' + Records + (ExistingRecords != null ? ' ... Existing Records = ' + ExistingRecords : ''));
        throw e;
    }

    // TRIGGER CONTEXT METHODS

    public virtual override void handleBeforeInsert() {
        try {
            super.handleBeforeInsert();
            this.commitWork();
        } catch (Exception e) {
            logAndThrow(e, 'handleBeforeInsert');
        }
    }

    public virtual override void handleAfterInsert() {
        try {
            super.handleAfterInsert();
            this.commitWork();
        } catch (Exception e) {
            logAndThrow(e, 'handleAfterInsert');
        }
    }

    public virtual override void handleBeforeUpdate(Map<Id,SObject> existingRecords) {
        try {
            super.handleBeforeUpdate(existingRecords);
            this.commitWork();
        } catch (Exception e) {
            logAndThrow(e, 'handleBeforeUpdate');
        }
    }

    public virtual override void handleAfterUpdate(Map<Id,SObject> existingRecords) {
        try {
            super.handleAfterUpdate(existingRecords);
            this.commitWork();
        } catch (Exception e) {
            logAndThrow(e, 'handleAfterUpdate');
        }
    }

    public virtual override void handleAfterDelete() {
        try {
            super.handleAfterDelete();
            this.commitWork();
        } catch (Exception e) {
            logAndThrow(e, 'handleAfterDelete');
        }
    }

    public virtual override void handleBeforeDelete() {
        try {
            super.handleBeforeDelete();
            this.commitWork();
        } catch (Exception e) {
            logAndThrow(e, 'handleBeforeDelete');
        }
    }

    public virtual override void handleAfterUndelete() {
        try {
            super.handleAfterUndelete();
            this.commitWork();
        } catch (Exception e) {
            logAndThrow(e, 'handleAfterUndelete');
        }
    }

    
    // STATIC METHODS

    public static void bypass(Type handlerClass) {
        fflib_SObjectDomain.getTriggerEvent(handlerClass)?.disableAll();
    }

    public static void clearBypass(Type handlerClass) {
        fflib_SObjectDomain.getTriggerEvent(handlerClass)?.enableAll();
    }

}