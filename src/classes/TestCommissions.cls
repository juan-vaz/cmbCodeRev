/*
* TestCommissions
* Contains unit test for the Commissions Domain Layer class
* @author Juan Vaz
*/
@isTest
private class TestCommissions {

    @TestSetup
    static void makeData(){
        new DataLayerTestUtility().createBasicTestScenario();
    }

	@isTest static void testCalculateCommissions(){

        List<Id> salesAgentIds = new List<Id>();
        for(Sales_Agent__c salesAgent : new salesAgentsSelector().getSalesAgents('Name')){
            salesAgentIds.add(salesAgent.Id);
        }
            
        List<Commission__c> commissionList =
                   new CommissionsSelector().getCommissionsByAgentsAndOpptyStage(salesAgentIds, CommissionsService.PENDING_OPPORTUNITY_STAGE);

        Test.startTest();

            Commissions comms = new Commissions(commissionList);
            Map<Id, Decimal> commissionsByAgentId = comms.calculateCommissions();

            // assert the commissions for the agent 0 = 0+10+20+30+40
            System.assertEquals(100, commissionsByAgentId.get(salesAgentIds.get(0)));
            // assert the commissions for the agent 1 = 50+60+70+80+90
            System.assertEquals(350, commissionsByAgentId.get(salesAgentIds.get(1)));

        Test.stopTest();


    }
    
}