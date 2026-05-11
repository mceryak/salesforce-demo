
// PARAMETERS:

// change to whomever may be importing data
Id runningUserId = UserInfo.getUserId(); // UserInfo.getOrganizationId() for the org defaults

// to turn all triggers ON, set to TRUE. to turn OFF, set to FALSE.
Boolean onOrOff = false; 



// FUNCTION: 

fflibe_TriggerSwitches__c switches = fflibe_TriggerSwitches__c.getInstance(runningUserId);
for (String field : fflibe_TriggerSwitches__c.getSObjectType().getDescribe().fields.getMap().keySet()) {
    // skip non-custom fields
    if (!field.endsWith('__c')) { continue; }
    
    // set the switch to on or off based on the provided parameter
    switches.put(field, onOrOff);
}
upsert switches;