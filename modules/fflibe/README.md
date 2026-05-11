# fflibe

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