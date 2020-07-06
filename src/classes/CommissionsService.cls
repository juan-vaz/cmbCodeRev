/**
 * CommissionsService
 * Service class 
 * @author Juan Vaz
 */
public with sharing class CommissionsService {

    public static final String NEW_OPPORTUNITY_STAGE = 'New';
    public static final String PENDING_OPPORTUNITY_STAGE = 'Pending';

    public void updateSalesAgentsPendingCommissions(List<Id> salesAgentIds){
        List<Commission__c> agentPendingCommissions = 
                new CommissionsSelector().getCommissionsByAgentsAndOpptyStage(salesAgentIds, PENDING_OPPORTUNITY_STAGE);
        
        if(agentPendingCommissions != null && !agentPendingCommissions.isEmpty()){
            // calculate the commissions amount for the agents involved
            Map<Id, Decimal> agentCommissionsMap = new Commissions(agentPendingCommissions).calculateCommissions();

            List<Sales_Agent__c> agentsToUpdate = new List<Sales_Agent__c>();

            for(Id agentId : agentCommissionsMap.keySet()){
                agentsToUpdate.add(
                    new Sales_Agent__c(
                        Id = agentId, 
                        Amount_Pending__c = agentCommissionsMap.get(agentId)
                    )
                );
            }

            update agentsToUpdate;
        }
        
    }

}