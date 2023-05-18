public inherited sharing class DLT_SubscriptionBatch implements Database.Batchable<SObject>, Schedulable {
    private String status;

    public DLT_SubscriptionBatch() {
        status = DLT_SubscriptionConstants.STATUS_NOT_STARTED;
    }

    // Schedulable
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new DLT_SubscriptionBatch());
    }

    // Batch
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Start_Date__c, End_Date__c, Status__c'
            + ' FROM Subscription__c'
            + ' WHERE Status__c = :status'
                + ' AND Start_Date__c <= TODAY'
                + ' AND End_Date__c >= TODAY'
            );
    }

    public void execute(Database.BatchableContext bc, List<Subscription__c> scope) {
        DLT_SubscriptionService.toggleActiveStatus(scope);

        update scope;
    }

    public void finish(Database.BatchableContext bc) {
    }
}