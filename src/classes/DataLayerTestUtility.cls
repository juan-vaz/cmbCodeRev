/**
 * DataLayerTestUtility.cls
 * Test utility class to create instances of the objects
 * @Author Juan Vaz
 */
@isTest
public class DataLayerTestUtility {

    public Opportunity createTestOpportunity(String opptyName, String stage, Decimal amount, Boolean doDML){
        Opportunity newOppty = new Opportunity();
        newOppty.Name = opptyName;
        newOppty.Stage__c = stage;
        newOppty.Amount__c = amount;
        newOppty.StageName = stage;
        newOppty.CloseDate = Date.today();

        if(doDML){
            insert newOppty;
            System.assertNotEquals(null, newOppty.Id, 'Error while inserting the opportunity');
        }        
        return newOppty;
    }

    public List<Opportunity> createTestOpportunities(Integer oppotunitiesQty, String stage){
        List<Opportunity> oppties = new List<Opportunity>();
        for(Integer i=0; i<oppotunitiesQty; i++){
            Decimal testAmount = 10 * i;
            oppties.add(createTestOpportunity('testOppty'+i, stage, testAmount, false));
        }
        insert oppties;
        return oppties;
    }

    public Sales_Agent__c createTestSalesAgent(String agentName, Decimal amountPending, Boolean doDML){
        Sales_Agent__c agent = new Sales_Agent__c();
        agent.Name = agentName;
        agent.Amount_Pending__c = amountPending;
        if(doDML){
            insert agent;
            System.assertNotEquals(null, agent.Id, 'Error while inserting the Sales Agent');
        }        
        return agent;
    }

    public List<Sales_Agent__c> createTestSalesAgents(Integer agentsQty){
        List<Sales_Agent__c> agents = new List<Sales_Agent__c>();
        for(Integer i=0; i<agentsQty; i++){
            agents.add(createTestSalesAgent('testAgent'+i, 0, false));
        }
        insert agents;
        return agents;
    }

    public Commission__c createTestCommission(Id agentId, Id opptyId, Boolean doDML){
        Commission__c comm = new Commission__c();
        comm.Sales_Agent__c = agentId;
        comm.Opportunity__c = opptyId;
        if(doDML){
            insert comm;
            System.assertNotEquals(null, comm.Id, 'Error while inserting the Commission');
        }        
        return comm;
    }

    public void createBasicTestScenario(){
        // create 10 test opportunities
        List<Opportunity> oppties = createTestOpportunities(10, CommissionsService.PENDING_OPPORTUNITY_STAGE);
        // create 2 test sales agents
        List<Sales_Agent__c> agents = createTestSalesAgents(2);

        // Assign 5 commissions to each agent as follows:
        // agent1 - (oppty0..oppty4)
        // agent2 - (oppty5..oppty9)
        List<Commission__c> comms = new List<Commission__c>();
        for(Integer i=0;i<5; i++){
            comms.add(createTestCommission(agents[0].Id, oppties[i].Id, false));
            comms.add(createTestCommission(agents[1].Id, oppties[i+5].Id, false));
        }
        insert comms;

    }
    
}