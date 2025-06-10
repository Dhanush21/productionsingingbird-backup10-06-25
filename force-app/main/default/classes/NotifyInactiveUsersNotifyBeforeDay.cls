global class NotifyInactiveUsersNotifyBeforeDay implements Database.Batchable<SObject>, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        Integer daysToCheck = Integer.valueOf(Label.Inactive_User_Days_To_Check_Two);
        Date cutoffDate = Date.today().addDays(-daysToCheck);
        //String query = 'SELECT Id, Email, LastLoginDate FROM User WHERE LastLoginDate <= :cutoffDate';
String query = 'SELECT Id, Email, LastLoginDate FROM User WHERE IsActive = true AND Id = \'0055i000007QRZIAA4\' AND (LastLoginDate <= :cutoffDate OR LastLoginDate = null)';
        //String query = 'SELECT Id, Email, LastLoginDate FROM User WHERE IsActive = true AND (LastLoginDate <= :cutoffDate OR LastLoginDate = null)';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<User> usersToUpdate = new List<User>();
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        Set<Id> userIds = new Set<Id>();
        
        // Get list of users and user Ids to update
        for (SObject s : scope) {
            User user = (User) s;
            
            usersToUpdate.add(user);
            userIds.add(user.Id);
        }

        // Query for records owned by the users
Map<Id, List<SObject>> recordsByUser = new Map<Id, List<SObject>>();
List<SObject> records = new List<SObject>();
        
// Query for accounts owned by the users
records = [SELECT Id, OwnerId FROM Account WHERE OwnerId IN :userIds];
for (SObject s : records) {
    Id ownerId = (Id) s.get('OwnerId');
    if (recordsByUser.containsKey(ownerId)) {
        recordsByUser.get(ownerId).add(s);
    } else {
        recordsByUser.put(ownerId, new List<SObject>{s});
    }
}
        
// Query for contacts owned by the users
records = [SELECT Id, OwnerId FROM Contact WHERE OwnerId IN :userIds];
for (SObject s : records) {
    Id ownerId = (Id) s.get('OwnerId');
    if (recordsByUser.containsKey(ownerId)) {
        recordsByUser.get(ownerId).add(s);
    } else {
        recordsByUser.put(ownerId, new List<SObject>{s});
    }
}
        
// Query for opportunities owned by the users
records = [SELECT Id, OwnerId FROM Opportunity WHERE OwnerId IN :userIds];
for (SObject s : records) {
    Id ownerId = (Id) s.get('OwnerId');
    if (recordsByUser.containsKey(ownerId)) {
        recordsByUser.get(ownerId).add(s);
    } else {
        recordsByUser.put(ownerId, new List<SObject>{s});
    }
}
        
// Query for leads owned by the users
records = [SELECT Id, OwnerId FROM Lead WHERE OwnerId IN :userIds];
for (SObject s : records) {
    Id ownerId = (Id) s.get('OwnerId');
    if (recordsByUser.containsKey(ownerId)) {
        recordsByUser.get(ownerId).add(s);
    } else {
        recordsByUser.put(ownerId, new List<SObject>{s});
    }
}
        
// Query for cases owned by the users
records = [SELECT Id, OwnerId FROM Case WHERE OwnerId IN :userIds];
for (SObject s : records) {
    Id ownerId = (Id) s.get('OwnerId');
    if (recordsByUser.containsKey(ownerId)) {
        recordsByUser.get(ownerId).add(s);
    } else {
        recordsByUser.put(ownerId, new List<SObject>{s});
    }
}

        // Send emails to users and their managers
         // v3 starts	
          EmailTemplate emailTemplateOne  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = : 'Mov_UserDeactivationNotifyOne' LIMIT 1];	
        EmailTemplate emailTemplateOneManager  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = : 'Mov_UserDeactivationNotifyOneManager' LIMIT 1];	
        // v3 ends
        for (User user : usersToUpdate) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{user.Email});
             // v3 starts commentthis  	
            //email.setSubject('Reminder to log in');	
             //email.setPlainTextBody('Please log in to your account to keep it active.');	
            // v3 ends commentthis 	
             // v3 starts	
           email.setTemplateId(emailTemplateOne.Id);	
            email.setTargetObjectId(user.id); 	
            email.setSaveAsActivity(false);	
             // v3 ends
            emailsToSend.add(email);

            if (recordsByUser.containsKey(user.Id)) {
                Set<Id> managerIds = new Set<Id>();
                for (SObject recordOwnedByUser : recordsByUser.get(user.Id)) {
                   
                    Id ownerId = (Id) recordOwnedByUser.get('OwnerId');
                    User owner = [SELECT Id, ManagerId FROM User WHERE Id = :ownerId];
                    if (owner.ManagerId != null) {
                        managerIds.add(owner.ManagerId);
                    } 
                }

                List<User> managers = [SELECT Id, Email FROM User WHERE Id IN :managerIds];
                for (User manager : managers) {
                    Messaging.SingleEmailMessage managerEmail = new Messaging.SingleEmailMessage();
                    System.debug('manager>>> '+manager);
                    System.debug('Manager email: ' + manager.Email);
                    managerEmail.setToAddresses(new List<String>{manager.Email});
                    System.debug('ToAddresses: ' + managerEmail.getToAddresses());
                    System.debug('manager>>> '+manager.Email);
                    /* v3 starts commentthis  	
            managerEmail.setSubject('Reminder to log in');	
                    managerEmail.setPlainTextBody('Please remind your team member to log in to their account to keep it active.');	
             v3 ends commentthis */	
             // v3 starts	
           managerEmail.setTemplateId(emailTemplateOneManager.Id);	
            managerEmail.setTargetObjectId(manager.id); 	
            managerEmail.setSaveAsActivity(false);	
             //v3 ends 
                    emailsToSend.add(managerEmail);
                }
            }
        }

        try {
            Messaging.sendEmail(emailsToSend);
        } catch (Exception e) {
            // Handle exception
        }
    }

    global void finish(Database.BatchableContext bc) {
        // No action needed
    }
}