public with sharing class TestHelper  {

    public String uniqueStr;

    // constructor
    public TestHelper(String x_uniqueStr) {
        this.uniqueStr = x_uniqueStr;
    }

    // didn't automake user because it has to be done in a different context
    public User adminUser {get;set;}

    // this is the lazy pattern
    public My_Formulary__c myFormulary {get {
        if(this.myFormulary == null) this.createMyFormulary();
        return myFormulary;
    } set;}
    public Formulary_Association__c formularyAssn {get {
        if(this.formularyAssn == null) this.createFormularyAssn();
        return formularyAssn;
    } set;}
    public Insured_Item__c insuredItem {get {
        if(this.insuredItem == null) this.createInsuredItem();
        return insuredItem;
    } set;}
    public My_Prescription__c myRx {get{
        if(this.myRx == null) this.createMyRx();
        return myRx;
    } set;}
    public Pill__c pill {get{
        if(pill == null) this.createPill();
        return this.pill;
    } set;}
    public Event pillTaken {get{
        if(pillTaken == null) this.takePill();
        return pillTaken;
    } set;}

    public TestHelper createAdminUser() {
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator' LIMIT 1];
        String x_emailPrefix = this.uniqueStr + 'email';
        String x_alias = x_emailPrefix.length() > 8 ? x_emailPrefix.subString(x_emailPrefix.length() - 8,x_emailPrefix.length()) : x_emailPrefix;
        adminUser = new User(
            alias = x_alias,
            email = x_emailPrefix + '=test.com@example.com',
            emailencodingkey = 'UTF-8', 
            lastname = this.uniqueStr, 
            languagelocalekey = 'en_US',
            localesidkey = 'en_US', 
            profileid = p.Id,
            timezonesidkey = 'America/Chicago',
            username = x_emailPrefix+'=test.com@example.com.testing'
        );
        insert this.adminUser;
        return this;
    }

    public TestHelper createInsuredItem() {
        insuredItem = new Insured_Item__c(
            Substance_Name__c = 'Lorazepam',
            Route__c = 'ORAL',
            Name = 'Lorazepam',
            Product_NDC__c = 'abc123',
            Drug_Coverage_Status_Code__c = 'C',
            Dosage_Form__c = 'TABLET'
        );
        insert this.insuredItem;
        return this;
    }

    public TestHelper createMyFormulary() {
        myFormulary = new My_Formulary__c(
            Coverage_Start_Date__c = Date.today().addDays(-180),
            Coverage_End_Date__c = Date.today().addDays(180),
            Group_Number__c = 'abc123',
            Health_Plan__c = 'abc123',
            Name = 'United Healthcare',
            Member_ID__c = 'abc123',
            OwnerId = adminUser.Id,
            Payer_ID__c = 'abc123',
            PCP_Name__c = 'United Healthcare',
            PCP_Phone__c = 'abc123'
        );
        insert this.myFormulary;
        return this;
    }

    public TestHelper createFormularyAssn() {
        this.formularyAssn = new Formulary_Association__c(
            Covered__c = true,
            Formulary__c = this.myFormulary.Id,
            Insured_Item__c = this.insuredItem.Id
        );
        insert this.formularyAssn;
        return this;
    }

    public TestHelper createMyRx() {
        this.myRx = new My_Prescription__c(
            Formulary_Association__c = this.formularyAssn.Id,
            My_Insurance__c = this.myFormulary.Id,
            Pill_Counter__c = 30,
            Pills_Taken__c = 0,
            Pharmacy__c = this.uniqueStr,
            Take_with_Food__c = true,
            RX_Number__c = 'RX-' + uniqueStr 
        );
        insert this.myRx;
        return this;
    }

    public TestHelper createPill() {
        this.pill = new Pill__c(
            OwnerId = this.adminUser.Id,
            Predicted_Drug_Name__c = 'Lorazepam'
        );
        insert this.pill;
        return this;
    }

    public TestHelper takePill() {
        pillTaken = new Event(
            OwnerId = this.adminUser.Id,
            WhatId = this.myRx.Id,
            Subject = 'Take Pill',
            Pill_Number__c = 1,
            Took_with_Food__c = true,
            ActivityDateTime = DateTime.now(),
            DurationInMinutes = 15
        );
        insert pillTaken;
        return this;
    }
}