trigger OpportunityTrigger on Opportunity (after update, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            new Opportunities(Trigger.new).onAfterUpdate(Trigger.oldMap);
        }
        if(Trigger.isDelete){
            new Opportunities(Trigger.old).onAfterDelete();
        }   
    }
}