# lgr

A custom logging framework to make catching and resolving Apex errors in production easier.

### Usage

1. For each Apex Class containing calls to the logger, add a custom text field to lgr_LogLevels__c Custom Settings:
    - Field Type: Text(8)
    - Field Api Name: The exact name of the Apex class containing the logger call
    - Field Value: `CRITICAL`, `WARNING`, `INFO`, or `DEBUG`
2. In the Apex Class, call the logger:
    - `lgr_Logger.log('className', 'methodName', 'message',  'parameters', 'stackTrace', lgr_Logger.LogLevel.INFO);`

        - (When possible, the DML insert is done asynchronously so that it does not affect the limits of the current transaction)
    - `lgr_Logger.log(someException, 'className', 'methodName', 'parameters');`
        - (A devoted method for logging exceptions, which utilizes a 'publish immediately' platform event so that the exception can be re-thrown)

3. Clone the `All` List View for Custom Logs and filter on the Apex Class you want to see logs for.

4. Log records stick around for a default of 3 months, and are deleted in a monthly deletion job (see deployment steps). To save an individual Log record, tick the `Save` checkbox on the page layout. To change the default lifetime of all logs, Update the value on `lgr_LogSettings__c` Custom Settings.

### Deployment Steps

1. Deploy Custom Settings metadata.
    - `sfdx project deploy start -x modules/lgr/manifest/lgr_package1.xml`

2. Insert Org Defaults for Custom Settings.
    - scripts/customSettingsOrgDefaults.apex

3. Deploy the rest of the metadata.
    - `sfdx project deploy start -x modules/lgr/manifest/lgr_package2.xml -l RunSpecifiedTests --tests lgr_LogDeletionJobTest lgr_LoggerTest`

4. Assign Viewer Permissions to all Admins.
    - /modules/lgr/scripts/assignViewerPermSet.apex

5. Schedule the Deletion job.
    - /modules/lgr/scripts/scheduleDeletionJob.apex







# fflibe

fflib extensions to make implementing fflib faster and easier.



### Usage

Each of the following snippets reference the `fflibe_APP` apex class:
- For new trigger handlers, use the `newhandler` code snippet
    - When creating a new handler, add a field to `fflibe_TriggerSwitches__c` Custom Setting to enable simple de-activation:
        - field api name: Exact name of the apex trigger handler class
        - field value: checked (uncheck to deactivate)
- For new Service classes, use the `newservice` code snippet
- For new Selector classes, use the `newselector` code snippet
- For new Domain classes, use the `newdomain` code snippet
- To create a new Unit of Work, use the `uow` code snippet

In unit tests, use the following snippets for faster mocking:
- `mocks` to create the mocks instance
- `mockservice` to mock a Service class
- `mockselector` to mock a Selector class
- `stub` to start & stop stubbing
- `whenreturn` to mock return values
- `whenthrow` to mock a thrown exception
- `starttest` to start & stop test

To turn ON/OFF all triggers (use case: data import) for the organization or a specific user, you can either:
-  (slower) manually set the `fflibe_TriggerSwitches__c` custom settings field values to all checked or unchecked for the specific user or the organization
- OR
- (faster) run the apex script: /modules/fflibe/scripts/toggleTriggerSwitches.apex and fill out the parameters in the script

### Deployment Steps
1. Deploy modules/fflib
2. Deploy modules/lgr
3. `sfdx project deploy start -d modules/fflibe/main/default -l RunSpecifiedTests --tests fflibe_TriggerHandlerTest fflibe_TriggerSObjectDomainTest fflibe_UnitOfWorkTest fflibe_ApplicationTest`
4. Run Apex Script: /modules/fflibe/scripts/insertCustomSettings.apex