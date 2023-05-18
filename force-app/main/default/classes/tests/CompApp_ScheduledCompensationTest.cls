@isTest
public class CompApp_ScheduledCompensationTest {

    @isTest
    public static void testTodayTickets() {

        AccoutingServiceMock serviceMock = new AccoutingServiceMock(true);
        Test.setMock(HttpCalloutMock.class, serviceMock);

        // tickets with Travel_DateTime__c Today
        insertTestRecords(3,1, Date.today());
        List<Compensation__c> compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());

        List<Ticket__c> tickets = [SELECT Id FROM Ticket__c];
        for (Ticket__c ticket : tickets) {
            ticket.Checked_In__c = true;
        }

        update tickets;
        Test.startTest();
        Database.executeBatch(new CompApp_ScheduledCompensation(CompApp_CompensationScheduler.getScopeQuery()), 200);
        Test.stopTest();

        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());
    }

    @isTest
    public static void testYesterdayTickets() {

        AccoutingServiceMock serviceMock = new AccoutingServiceMock(true);
        Test.setMock(HttpCalloutMock.class, serviceMock);

        // tickets with Travel_DateTime__c Yesterday
        insertTestRecords(3,1, Date.today().addDays(-1));
        List<Compensation__c> compensations = [SELECT Id FROM Compensation__c];
        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());

        List<Ticket__c> tickets = [SELECT Id, Compensation_Ticket__c FROM Ticket__c];
        System.debug('TICKETS ------- ' + tickets);
        for (Ticket__c ticket : tickets) {
            ticket.Checked_In__c = true;
        }
        update tickets;

        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());

        Test.startTest();
        Database.executeBatch(new CompApp_ScheduledCompensation(CompApp_CompensationScheduler.getScopeQuery()), 200);
        Test.stopTest();
    }

    public static List<SObject> insertTestRecords(Integer numberOfTrains, Integer numberOfTicketsPerTrain, Date departureDate ) {

        String departureDateString = String.valueOf(departureDate.day()).leftPad(2,'0') + '/'
                + String.valueOf(departureDate.month()).leftPad(2,'0') + '/'
                + String.valueOf(departureDate.year()) + ' 01:00:00';

        List<Train__c> testTrains = new List<Train__c>();
        List<Ticket__c> testTickets = new List<Ticket__c>();

        for (Integer i = 0; i < numberOfTrains; i++) {
            Train__c train;
            train = new Train__c(
                    Name = 'TestTrain' + String.valueOf(i),
                    Departure_Date_Time__c = departureDateString,
                    Cancelled__c = false,
                    // now fields was lacking for compensation create
                    All__c = 10

            );
            insert train;

            for (Integer j = 0; j < numberOfTicketsPerTrain; j++) {
                Ticket__c ticket;
                ticket = new Ticket__c(
                        Name = String.valueOf(j).leftPad(9,'0'),
                        Train__c = train.Id,
                        Ticket_Price__c = 10,
                        Travel_DateTime__c = departureDateString,
                        // now fields was lacking for compensation create
                        Checked_In__c = false
                );
                testTickets.add(ticket);
            }
        }

        insert testTickets;

        return testTickets;
    }

    @testSetup
    public static void Initialize() {

        Compensation_App_Metadata__c compensationSettings = new Compensation_App_Metadata__c(
                Name = 'Compensation Policy Change Date',
                Data__c = '29/10/15'
        );

        insert compensationSettings;

        List<Compensation_Rules__c> compRules = new List<Compensation_Rules__c>();
        Compensation_Rules__c compensationRule = new Compensation_Rules__c(
                Name = 'Delay',
                Type__c = 'Cancelled',
                Eligible_Compensation__c = 100,
                Point_Conversion__c = 0,
                isValidRule__c = true
        );
        compRules.add(compensationRule);
        compensationRule = new Compensation_Rules__c(
                Name = 'N060-119',
                Type__c = 'Delay',
                Delay_Start__c = 60,
                Delay_End__c = 119,
                Eligible_Compensation__c = 25,
                Eligible_PRR_Compensation__c = 25,
                Point_Conversion__c = 0,
                isValidRule__c = true
        );
        compRules.add(compensationRule);
        compensationRule = new Compensation_Rules__c(
                Name = 'N120-179',
                Type__c = 'Delay',
                Delay_Start__c = 120,
                Delay_End__c = 179,
                Eligible_Compensation__c = 50,
                Eligible_PRR_Compensation__c = 50,
                Point_Conversion__c = 0,
                isValidRule__c = true
        );
        compRules.add(compensationRule);
        compensationRule = new Compensation_Rules__c(
                Name = 'N180+',
                Type__c = 'Delay',
                Delay_Start__c = 180,
                Delay_End__c = 9999,
                Eligible_Compensation__c = 75,
                Eligible_PRR_Compensation__c = 50,
                Point_Conversion__c = 0,
                isValidRule__c = true
        );
        compRules.add(compensationRule);
        insert compRules;
    }
}