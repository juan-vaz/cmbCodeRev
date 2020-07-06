/**
 * CommissionsSelector - Selector class for Commission__c object
 * @author Juan Vaz
 */
public with sharing class CommissionsSelector {

    /**
     * Retrieves the Commissions list filtered by 
     * sales agent ids and opportunity stage
     * @param  salesAgentIds Sales Agents id list
     * @param  opptyStage    Filter for Opportunity Satge
     * @return               returns the Commissions list filtered by 
     *                      sales agent ids and opportunity stage
     */ 
    public List<Commission__c> getCommissionsByAgentsAndOpptyStage(List<Id> salesAgentIds, String opptyStage){

        if (salesAgentIds != null && !salesAgentIds.isEmpty()) {

            String query =  'SELECT id, Sales_Agent__c, Sales_Agent__r.Amount_Pending__c, Opportunity__c, Opportunity__r.Stage__c, Opportunity__r.Amount__c '+
                            'FROM Commission__c '+
                            'WHERE Sales_Agent__c in: salesAgentIds';

            if(String.isNotBlank(opptyStage)){
                query += ' AND Opportunity__r.Stage__c =: opptyStage';
            }                        

            return Database.query(query);

        }

        return null;

    }

    /**
     * Retrieves the Commissions list filtered by opp ids
     * @param  opportunityIds opportunities id list
     * @return               returns the Commissions list filtered by 
     *                      opportunity ids
     */ 
    public List<Commission__c> getCommissionsByOpportunities(List<Id> opportunityIds){

        if (opportunityIds != null && !opportunityIds.isEmpty()) {

            String query =  'SELECT id, Sales_Agent__c, Sales_Agent__r.Amount_Pending__c, Opportunity__c, Opportunity__r.Stage__c, Opportunity__r.Amount__c '+
                            'FROM Commission__c WHERE Opportunity__c in: opportunityIds';

            return Database.query(query);

        }

        return null;

    }

}