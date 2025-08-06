@IsTest
public with sharing class LeadTriggerHandlerTest {
    @IsTest
    public static void leadTriggerHandler_handleTitleNormalization() {
        List<Lead> testLeads = new List<Lead>();
        Lead testLead1 = new Lead(FirstName = 'Test1', LastName = 'Smith', Company = 'TestCompany1', Title = 'vp');
        testLeads.add(testLead1);
        Lead testLead2 = new Lead(FirstName = 'Test2', LastName = 'Rogers', Company = 'TestCompany2', Title = 'mgr');
        testLeads.add(testLead2);
        Lead testLead3 = new Lead(FirstName = 'Test3', LastName = 'Contreras', Company = 'TestCompany3', Title = 'chief');
        testLeads.add(testLead3);
        Lead testLead4 = new Lead(FirstName = 'Test4', LastName = 'Li', Company = 'TestCompany4', Title = 'jr');
        testLeads.add(testLead4);

        Test.startTest();
        insert testLeads;
        Test.stopTest();

        Lead updatedLead1 = [SELECT FirstName, LastName, Title FROM Lead WHERE FirstName = 'Test1'];
        Lead updatedLead2 = [SELECT FirstName, LastName, Title FROM Lead WHERE FirstName = 'Test2'];
        Lead updatedLead3 = [SELECT FirstName, LastName, Title FROM Lead WHERE FirstName = 'Test3'];
        Lead updatedLead4 = [SELECT FirstName, LastName, Title FROM Lead WHERE FirstName = 'Test4'];

        System.assertEquals('Vice President', updatedLead1.Title, 'Title was not updated correctly');
        System.assertEquals('Manager', updatedLead2.Title, 'Title was not updated correctly');
        System.assertEquals('Executive', updatedLead3.Title, 'Title was not updated correctly');
        System.assertEquals('Assistant', updatedLead4.Title, 'Title was not updated correctly');
    }
    @IsTest
    public static void leadTriggerHandler_handleAutoLeadScoring() {
        List<Lead> testLeads = new List<Lead>();
        Lead testLead1 = new Lead(FirstName = 'Test1', LastName = 'Smith', Company = 'TestCompany1', Title = 'vp', LeadSource = 'Website');
        testLeads.add(testLead1);
        Lead testLead2 = new Lead(FirstName = 'Test2', LastName = 'Rogers', Company = 'TestCompany2', Title = 'mgr', LeadSource = 'Website', Email = 'Test@Test.com');
        testLeads.add(testLead2);
        Lead testLead3 = new Lead(FirstName = 'Test3', LastName = 'Contreras', Company = 'TestCompany3', Title = 'chief', LeadSource = 'Website', Email = 'Test@Test.com', Phone = '999999');
        testLeads.add(testLead3);
        Lead testLead4 = new Lead(FirstName = 'Test4', LastName = 'Li', Company = 'TestCompany4', Title = 'jr', LeadSource = 'Website', Email = 'Test@Test.com', Phone = '999999', Industry = 'Technology');
        testLeads.add(testLead4);

        Test.startTest();
        insert testLeads;
        Test.stopTest();

        Lead updatedLead1 = [SELECT FirstName, LastName, Lead_Score__c FROM Lead WHERE FirstName = 'Test1'];
        Lead updatedLead2 = [SELECT FirstName, LastName, Lead_Score__c FROM Lead WHERE FirstName = 'Test2'];
        Lead updatedLead3 = [SELECT FirstName, LastName, Lead_Score__c FROM Lead WHERE FirstName = 'Test3'];
        Lead updatedLead4 = [SELECT FirstName, LastName, Lead_Score__c FROM Lead WHERE FirstName = 'Test4'];

        System.assertEquals(0, updatedLead1.Lead_Score__c, 'Score was not updated correctly');
        System.assertEquals(3, updatedLead2.Lead_Score__c, 'Score was not updated correctly');
        System.assertEquals(8, updatedLead3.Lead_Score__c, 'Score was not updated correctly');
        System.assertEquals(18, updatedLead4.Lead_Score__c, 'Score was not updated correctly');
        System.assertNotEquals(null, updatedLead1, 'Lead Test1 not found');
        System.assertEquals(0, updatedLead1.Lead_Score__c, 'Score was not updated correctly');

    }
    @IsTest
    public static void leadTriggerHandler_handleLeadAutoConvert() {

        List<Account> testAccounts = new List<Account>{
        new Account(Name = 'Account 1'),
        new Account(Name = 'Account 2'),
        new Account(Name = 'Account 3'),
        new Account(Name = 'Account 4')
        };

        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        Contact testContact1 = new Contact(FirstName = 'Test1', LastName = 'Smith', Email = 'Test1@test.com', AccountId = testAccounts[0].Id);
        testContacts.add(testContact1);
        Contact testContact2 = new Contact(FirstName = 'Test2', LastName = 'Rogers', Email = 'Test2@test.com', AccountId = testAccounts[1].Id);
        testContacts.add(testContact2);
        Contact testContact3 = new Contact(FirstName = 'Test3', LastName = 'Contreras', Email = 'Test3@test.com', AccountId = testAccounts[2].Id);
        testContacts.add(testContact3);
        Contact testContact4 = new Contact(FirstName = 'Tes41', LastName = 'Li', Email = 'Test4@test.com', AccountId = testAccounts[3].Id);
        testContacts.add(testContact4);

        insert testContacts;


        List<Lead> testLeads = new List<Lead>();
        Lead testLead1 = new Lead(FirstName = 'Test1', LastName = 'Smith', Company = 'TestCompany1', Title = 'vp', LeadSource = 'Website');
        testLeads.add(testLead1);
        Lead testLead2 = new Lead(FirstName = 'Test2', LastName = 'Rogers', Company = 'TestCompany2', Title = 'mgr', LeadSource = 'Website', Email = 'Test2@Test.com');
        testLeads.add(testLead2);
        Lead testLead3 = new Lead(FirstName = 'Test3', LastName = 'Contreras', Company = 'TestCompany3', Title = 'chief', LeadSource = 'Website', Email = 'Test3@Test.com', Phone = '999999');
        testLeads.add(testLead3);
        Lead testLead4 = new Lead(FirstName = 'Test4', LastName = 'Li', Company = 'TestCompany4', Title = 'jr', LeadSource = 'Website', Email = 'Test4@Test.com', Phone = '999999', Industry = 'Technology');
        testLeads.add(testLead4);
        
        Test.startTest();
        insert testLeads;
        Test.stopTest();

        Lead updatedLead1 = [SELECT FirstName, LastName, IsConverted FROM Lead WHERE FirstName = 'Test1'];
        Lead updatedLead2 = [SELECT FirstName, LastName, IsConverted FROM Lead WHERE FirstName = 'Test2'];
        Lead updatedLead3 = [SELECT FirstName, LastName, IsConverted FROM Lead WHERE FirstName = 'Test3'];
        Lead updatedLead4 = [SELECT FirstName, LastName, IsConverted FROM Lead WHERE FirstName = 'Test4'];

        System.assertEquals(false, updatedLead1.IsConverted, 'Lead was not converted correctly');
        System.assertEquals(true, updatedLead2.IsConverted, 'Lead was not converted correctly');
        System.assertEquals(true, updatedLead3.IsConverted, 'Lead was not converted correctly');
        System.assertEquals(true, updatedLead4.IsConverted, 'Lead was not converted correctly');
    }
}
