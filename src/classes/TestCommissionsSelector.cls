/*
* TestCommissionsSelector
* Contains unit test for the CommissionsSelector class
* @author Juan Vaz
*/
@isTest
private class TestCommissionsSelector {

    @TestSetup
    static void makeData(){
        new DataLayerTestUtility().createBasicTestScenario();
    }

    @isTest static void testgetAgentsCommissions(){

        Set<Id> salesAgentIdsSet = new Map<Id, Sales_Agent__c>([Select id from Sales_Agent__c limit 2]).keySet();
        List<Id> salesAgentIdList = new List<Id>(salesAgentIdsSet);

        Test.startTest();

            List<Commission__c> commissionList = 
                        new CommissionsSelector().getCommissionsByAgentsAndOpptyStage(
                            salesAgentIdList, CommissionsService.PENDING_OPPORTUNITY_STAGE);

            System.assertEquals(10, commissionList.size());

            //assert each one has 5 comms on opptys
            for(Commission__c c : commissionList){
                System.assertEquals(true, salesAgentIdsSet.contains(c.Sales_Agent__c));
                System.assertEquals(CommissionsService.PENDING_OPPORTUNITY_STAGE, c.Opportunity__r.Stage__c);
            }                               

            // create a new opportunity in new stage 
            Opportunity oppty = new DataLayerTestUtility().createTestOpportunity('testOppty', CommissionsService.NEW_OPPORTUNITY_STAGE, 10, true);
            // create a new commission assigned to one of the existing agents for the previous opportunity
            new DataLayerTestUtility().createTestCommission(salesAgentIdList[0], oppty.Id, true);

            commissionList = 
                        new CommissionsSelector().getCommissionsByAgentsAndOpptyStage(
                            new List<Id>(salesAgentIdsSet), CommissionsService.PENDING_OPPORTUNITY_STAGE);

            System.assertEquals(10, commissionList.size());

            //assert each commission is in Pending stage and is associated to one of the sales agents
            for(Commission__c c : commissionList){
                System.assertEquals(true, salesAgentIdsSet.contains(c.Sales_Agent__c));
                System.assertEquals(CommissionsService.PENDING_OPPORTUNITY_STAGE, c.Opportunity__r.Stage__c);
            }                   

        Test.stopTest();


    }

    @isTest static void testgetOpptiesCommissions(){

        Set<Id> opportunityIdsSet = new Map<Id, Opportunity>([Select id from Opportunity limit 10]).keySet();
        List<Id> opportunityIdList = new List<Id>(opportunityIdsSet);

        Test.startTest();

            List<Commission__c> commissionList = 
                        new CommissionsSelector().getCommissionsByOpportunities(opportunityIdList);

            System.assertEquals(10, commissionList.size());

            //assert each commission is associated to one of the opportunities
            for(Commission__c c : commissionList){
                System.assertEquals(true, opportunityIdsSet.contains(c.Opportunity__c));
            }                               

        Test.stopTest();

    }

}