@isTest
private class CasePriorityHelperTest {
    /**
     * The code was removed from trigger handler, so case insert action no longer triggers prioritization
     * 
     */
    
    /*
    @IsTest
    static void testPrioritiseCasesByFeedback() {
        List<Case> casesBefore = new List<Case>();
        Case neutralFeedbackCase = new Case(
            Initial_Reason_For_Contact__c = 'Feedback',
            Tone_of_Contact__c = CaseService.NEUTRAL_TONE,
            Customer_Struggle__c = 'Customer giving feedback',
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('New_Standard_Case').getRecordTypeId()
        );
        casesBefore.add(neutralFeedbackCase);
        Case praiseFeedbackCase = new Case(
            Initial_Reason_For_Contact__c = 'Feedback',
            Tone_of_Contact__c = CaseService.PRAISE_TONE,
            Customer_Struggle__c = 'Customer giving feedback',
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('New_Standard_Case').getRecordTypeId()
        );
        casesBefore.add(praiseFeedbackCase);
        Case complaintFeedbackCase = new Case(
            Initial_Reason_For_Contact__c = 'Feedback',
            Tone_of_Contact__c = CaseService.COMPLAINT_TONE,
            Customer_Struggle__c = 'Customer giving feedback',
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('New_Standard_Case').getRecordTypeId()
        );
        casesBefore.add(complaintFeedbackCase);
        Case neutralFeedbackCaseWithPNR = new Case(
            Initial_Reason_For_Contact__c = 'Feedback',
            Tone_of_Contact__c = CaseService.NEUTRAL_TONE,
            Customer_Struggle__c = 'Customer giving feedback',
            PNR__c = 'HFG930',
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('New_Standard_Case').getRecordTypeId()
        );
        casesBefore.add(neutralFeedbackCaseWithPNR);
        Case praiseFeedbackCaseWithPNR = new Case(
            Initial_Reason_For_Contact__c = 'Feedback',
            Tone_of_Contact__c = CaseService.PRAISE_TONE,
            Customer_Struggle__c = 'Customer giving feedback',
            PNR__c = 'HFG9E3',
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('New_Standard_Case').getRecordTypeId()
        );
        casesBefore.add(praiseFeedbackCaseWithPNR);
        Case complaintFeedbackCaseWithPNR = new Case(
            Initial_Reason_For_Contact__c = 'Feedback',
            Tone_of_Contact__c = CaseService.COMPLAINT_TONE,
            Customer_Struggle__c = 'Customer giving feedback',
            PNR__c = 'HFG901',
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('New_Standard_Case').getRecordTypeId()
        );
        casesBefore.add(complaintFeedbackCaseWithPNR);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Tone_of_Contact__c, PNR__c
            FROM Case
        ];

        for (Case caseItem : casesAfter) {
            if (String.isBlank(caseItem.PNR__c) && (caseItem.Tone_of_Contact__c == CaseService.NEUTRAL_TONE)) {
                System.assertEquals('Low', caseItem.Priority);
            }
            if (String.isBlank(caseItem.PNR__c) && (caseItem.Tone_of_Contact__c == CaseService.PRAISE_TONE)) {
                System.assertEquals('Low', caseItem.Priority);
            }
            if (String.isBlank(caseItem.PNR__c) && (caseItem.Tone_of_Contact__c == CaseService.COMPLAINT_TONE)) {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (String.isNotBlank(caseItem.PNR__c) && (caseItem.Tone_of_Contact__c == CaseService.NEUTRAL_TONE)) {
                System.assertEquals('Medium', caseItem.Priority);
            } 
            if (String.isNotBlank(caseItem.PNR__c) && (caseItem.Tone_of_Contact__c == CaseService.PRAISE_TONE)) {
                System.assertEquals('Low', caseItem.Priority);
            }
            if (String.isNotBlank(caseItem.PNR__c) && (caseItem.Tone_of_Contact__c == CaseService.COMPLAINT_TONE)) {
                System.assertEquals('High', caseItem.Priority);
            }
        }
    }

    @IsTest
    static void testPrioritiseCasesBySpecialAssistance() {
        List<Case> casesBefore = new List<Case>();
        Case urgentSpecialCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Urgent special assistance',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?'
        );
        casesBefore.add(urgentSpecialCase);
        Case specialCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Special Assistance',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?'
        );
        casesBefore.add(specialCase);
        Case wheelchairCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Wheelchair or mobility scooter',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?'
        );
        casesBefore.add(wheelchairCase);
        Case dogWoofCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Assistance dog',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?'
        );
        casesBefore.add(dogWoofCase);
        Case kidsCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Children & Infants',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?'
        );
        casesBefore.add(kidsCase);
        Case minorsCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Unaccompanied Minors',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?'
        );
        casesBefore.add(minorsCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Topic__c
            FROM Case
        ];

        for (Case caseItem : casesAfter) {
            if (caseItem.Topic__c == 'Urgent special assistance') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Topic__c == 'Wheelchair or mobility scooter') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Topic__c == 'Assistance dog') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Topic__c == 'Children & Infants') {
                System.assertEquals('Low', caseItem.Priority);
            }
            if (caseItem.Topic__c == 'Unaccompanied Minors') {
                System.assertEquals('Low', caseItem.Priority);
            }
        }
    }

    @isTest
    static void testPrioritiseCasesByDate() {
        List<Case> casesBefore = new List<Case>();
        Case todayCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Today',
            Departure_Date__c = Date.today()
        );
        casesBefore.add(todayCase);
        Case weekCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Week',
            Departure_Date__c = Date.today().addDays(5)
        );
        casesBefore.add(weekCase);
        Case futureCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Future',
            Departure_Date__c = Date.today().addDays(30)
        );
        casesBefore.add(futureCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
            if (caseItem.Subject == 'Today') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'Week') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Subject == 'Future') {
                System.assertEquals('Low', caseItem.Priority);
            }
        }
    }

    @isTest
    static void testPrioritiseCasesByReturnDate() {
        List<Case> casesBefore = new List<Case>();
        Case todayCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Today',
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today()
        );
        casesBefore.add(todayCase);
        Case weekCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Week',
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today().addDays(5)
        );
        casesBefore.add(weekCase);
        Case futureCase = new Case(
            Category__c = 'Pre Travel',
            Topic__c = 'Webform case - please review',
            Initial_Reason_For_Contact__c = 'Info or Advice or Confirmation',
            Customer_Struggle__c = 'Need More Information',
            What_Is_The_Question__c = 'What Do You Offer?',
            Subject = 'Future',
            Departure_Date__c = Date.today().addDays(15),
            Return_Date__c = Date.today().addDays(15)
        );
        casesBefore.add(futureCase);

        Test.startTest();
        insert casesBefore;
        Test.stopTest();

        List<Case> casesAfter = [
            SELECT Id, Priority, Subject
            FROM Case
        ];
        for (Case caseItem : casesAfter) {
            if (caseItem.Subject == 'Today') {
                System.assertEquals('High', caseItem.Priority);
            }
            if (caseItem.Subject == 'Week') {
                System.assertEquals('Medium', caseItem.Priority);
            }
            if (caseItem.Subject == 'Future') {
                System.assertEquals('Low', caseItem.Priority);
            }
        }
    }*/
}