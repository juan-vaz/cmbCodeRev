/**
 * Domains Layer class for Commission__c sObject
 */
public with sharing class Commissions {

    @TestVisible List<Commission__c> records;
    
    public Commissions(){
        this.records = new List<Commission__c>();
    }

    public Commissions(List<Commission__c> comms){
        this.records = comms;
    }

    /**
     * Calculates the Sales Agent Commissions for all records 
     * @return returns a Map from Sales Agent Id to Commissions Amount
     */ 
    public Map<Id, Decimal> calculateCommissions(){
        Map<Id, Decimal> agentCommissionsMap = new Map<Id, Decimal>();
        if(this.records != null){
            for(Commission__c comm : records){

                if(comm.Opportunity__r != null && comm.Opportunity__r.Amount__c != null){
                    Decimal commissionAmount = 0;
                    if(agentCommissionsMap.containsKey(comm.Sales_Agent__c)){
                        commissionAmount = agentCommissionsMap.get(comm.Sales_Agent__c);
                    }
                    agentCommissionsMap.put(comm.Sales_Agent__c, 
                            commissionAmount + comm.Opportunity__r.Amount__c);

                }
            }
        }
        return agentCommissionsMap;        
    }

    /**
     * After Insert trigger event handler
     * Updates all related sales agents commissions
     * for every inserted Commission having a pending associated oppty
     */
    public void onAfterInsert(){

    }

    /**
     * After Update trigger event handler
     * Updates all related sales agents commissions
     * for every Commission having opportunity changed from/to a pending oppty
     * or having the sales agent changed and a pending associated oppty
     * @param  oldMap Trigger old map
     */
    public void onAfterUpdate(List<Commission__c> oldRecords){
        
    }
    
    /**
     * After Delete trigger event handler
     * Updates all related sales agents commissions
     * for every deleted Commission having a pending associated oppty
     */
    public void onAfterDelete(){

    }

}