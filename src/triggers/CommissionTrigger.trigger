trigger CommissionTrigger on Commission__c (after insert, after update, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            new Commissions(Trigger.new).onAfterInsert();
        }
        if(Trigger.isUpdate){
            new Commissions(Trigger.new).onAfterUpdate(Trigger.old);
        }
        if(Trigger.isDelete){
            new Commissions(Trigger.old).onAfterDelete();
        }   
    }
}