/**
 * SalesAgentsSelector - Selector class for Sales_Agent__c object
 * @author Juan Vaz
 */
public with sharing class SalesAgentsSelector {

    /**
     * Retrieves all the sales agents
     * @return list of all sales agents
     */
    public List<Sales_Agent__c> getSalesAgents(String orderBy){
        String query =  'SELECT id, Amount_Pending__c '+
                        'FROM Sales_Agent__c ';
        
        if(String.isNotBlank(orderBy)){
            query += 'Order By '+ orderBy;
        }
                        
        return Database.query(query);
    }
}