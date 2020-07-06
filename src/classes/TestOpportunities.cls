/*
* TestOpportunities
* Contains unit test for the Opportunities Domain Layer class
* @author Juan Vaz
*/
@isTest
private class TestOpportunities {

    @TestSetup static void makeData(){
        new DataLayerTestUtility().createBasicTestScenario();
    }

    @isTest static void testOpportunityStageUpdates(){
        // get all pending opportunities
        List<Opportunity> pendingOppties 
                = new OpportunitiesSelector().getOpportunitiesByStage(CommissionsService.PENDING_OPPORTUNITY_STAGE);

        // get all sales agents ordered by their name
        List<Sales_Agent__c> salesAgents = new salesAgentsSelector().getSalesAgents('Name');
            
        Test.startTest();
            
            // assert the commissions for the agent 0 = 0+10+20+30+40
            System.assertEquals(100, salesAgents[0].Amount_Pending__c);
            // assert the commissions for the agent 1 = 50+60+70+80+90
            System.assertEquals(350, salesAgents[1].Amount_Pending__c);

            // update one of the pending opportunities to New stage
            Opportunity toUpdate = new Opportunity(
                Id = pendingOppties[4].Id, 
                Stage__c = CommissionsService.NEW_OPPORTUNITY_STAGE
            );
            update toUpdate;

            // refresh the sales agents list from DB 
            salesAgents = new salesAgentsSelector().getSalesAgents('Name');

            // assert the commissions for the agent 0 is now = 0+10+20+30
            System.assertEquals(60, salesAgents[0].Amount_Pending__c);


        Test.stopTest();
    }

}