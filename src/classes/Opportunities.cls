public with sharing class Opportunities {

    @TestVisible List<Opportunity> records;
    
    public Opportunities(){
        this.records = new List<Opportunity>();
    }

    public Opportunities(List<Opportunity> oppties){
        this.records = oppties;
    }

    /**
     * After Update trigger event handler
     * For every opportunity having Stage changed from/to Pending 
     * updates all related sales agents commissions
     * @param  oldMap Trigger old map
     */
    public void onAfterUpdate(Map<Id, Opportunity> oldMap){

        if(this.records != null && !records.isEmpty()){

            // get all the Opprotunities having their Stage changed from/to Pending 
            List<Id> opportunityIds = getOpptiesChangedFromToPending(oldMap);
            
            // get all related sales agents 
            List<Id> salesAgentIds = new List<Id>();
            for(Commission__c comm : new CommissionsSelector().getCommissionsByOpportunities(opportunityIds)){
                salesAgentIds.add(comm.Sales_Agent__c);
            }

            // update all the involved sales agents
            new CommissionsService().updateSalesAgentsPendingCommissions(salesAgentIds);
        }
    }

    /**
     * Gathers all the Opprotunities having their Stage changed from/to Pending 
     * @param  oldMap Trigger old map
     * @return List of oppotuniy ids having their Stage changed from/to Pending 
     */
    @testVisible private List<Id> getOpptiesChangedFromToPending(Map<Id, Opportunity> oldMap){
        List<Id> opptiesInvolved = new List<Id>();

        for(Opportunity oppty : this.records){
            Opportunity oldOppty = oldMap.get(oppty.Id);

            if( oppty.Stage__c != oldOppty.Stage__c && 
                (CommissionsService.PENDING_OPPORTUNITY_STAGE.equals(oppty.Stage__c) ||
                CommissionsService.PENDING_OPPORTUNITY_STAGE.equals(oldOppty.Stage__c)) ){
                
                opptiesInvolved.add(oppty.Id);
            }

        }
        return opptiesInvolved;
    }

    /**
     * After Delete trigger event handler
     * Cascade Delete all related Commissions
     */
    public void onAfterDelete(){
        if(this.records != null && !records.isEmpty()){
            List<Id> opportunityIds = new List<Id>(new Map<Id, Opportunity>(records).keySet());
            List<Commission__c> commissionsToDelete =  new CommissionsSelector().getCommissionsByOpportunities(opportunityIds);
            if(commissionsToDelete !=  null && !commissionsToDelete.isEmpty()){
                delete commissionsToDelete;
            }
        }
    }

}