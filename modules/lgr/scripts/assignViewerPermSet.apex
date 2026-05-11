

PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'lgr_LogViewer'];

PermissionSetAssignment[] psas = new List<PermissionSetAssignment>();
for (User u : [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator']) {
    psas.add(new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id));
    System.debug('Assigned to: ' + u.Name);
}
System.debug('Assigned to total of ' + psas.size() + ' users.');
insert psas;
