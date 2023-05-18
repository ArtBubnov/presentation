@isTest
public class CompApp_ScheduledPreTravelCompTest {
	
    @isTest
    public static void testTodayTickets() {

        AccoutingServiceMock serviceMock = new AccoutingServiceMock(true);
        Test.setMock(HttpCalloutMock.class, serviceMock);
		createPreTravelCompensationRules('TodaysTicket',null,null, null,true,10,null,100);
        // tickets with Travel_DateTime__c Today
        insertTestRecords(3,1, Date.today(), Date.today());
        List<Compensation__c> compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());

        List<Ticket__c> tickets = [SELECT Id FROM Ticket__c];
        for (Ticket__c ticket : tickets) {
            ticket.Checked_In__c = true;
        }

        update tickets;
        Test.startTest();
        Database.executeBatch(new CompApp_ScheduledPreTravelCompensation(), 200);
        Test.stopTest();

        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());
    }

    @isTest
    public static void testYesterdayTickets() {

        AccoutingServiceMock serviceMock = new AccoutingServiceMock(true);
        Test.setMock(HttpCalloutMock.class, serviceMock);

        // tickets with Travel_DateTime__c Yesterday
        createPreTravelCompensationRules('YesterdaysTickets',null,null, null,true,10,null,100);
        insertTestRecords(3,1, Date.today().addDays(-1), Date.today());
        List<Compensation__c> compensations = [SELECT Id FROM Compensation__c];
        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());

        List<Ticket__c> tickets = [SELECT Id FROM Ticket__c];
        for (Ticket__c ticket : tickets) {
            ticket.Checked_In__c = true;
        }
        update tickets;

        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());

        Test.startTest();
        Database.executeBatch(new CompApp_ScheduledPreTravelCompensation(), 200);
        Test.stopTest();

        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());
    }
    
    @isTest
    public static void testFutureTicketsAnyTrains() {

        AccoutingServiceMock serviceMock = new AccoutingServiceMock(true);
        Test.setMock(HttpCalloutMock.class, serviceMock);

        // tickets with Travel_DateTime__c Yesterday
        createPreTravelCompensationRules('Future All Trains',null,null, null,true,10,null,100);
        insertTestRecords(3,1, Date.today().addDays(10), Date.today());
        List<Compensation__c> compensations = [SELECT Id FROM Compensation__c];
        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());

        List<Ticket__c> tickets = [SELECT Id FROM Ticket__c];
        for (Ticket__c ticket : tickets) {
            ticket.Checked_In__c = true;
        }
        update tickets;

        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());

        Test.startTest();
        Database.executeBatch(new CompApp_ScheduledPreTravelCompensation(), 200);
        Test.stopTest();

        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());
    }

    @isTest
    public static void testFutureTicketsSpecificTrains() {

        AccoutingServiceMock serviceMock = new AccoutingServiceMock(true);
        Test.setMock(HttpCalloutMock.class, serviceMock);

        // tickets with Travel_DateTime__c Yesterday
        createPreTravelCompensationRules('Future-09010','09010', null,null,true,null,Date.valueOf('2021-01-01'),100);
        createPreTravelCompensationRules('Future-09011','09011', null,null,false,null,Date.valueOf('2021-02-01'),50); 
        createPreTravelCompensationRules('Future-09012','09012', Date.today().addDays(-10),Date.today().addDays(-1),false,null,Date.valueOf('2021-02-01'),50); 
        insertTestRecords(4,2, Date.today().addDays(+5), Date.today().addDays(-5));
        List<Compensation__c> compensations = [SELECT Id FROM Compensation__c];
        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());
		
        Boolean firstTicket=true;
        List<Ticket__c> tickets = [SELECT Id, Train__r.Train_number__c,Booking_DateTime__c, Name FROM Ticket__c];
        for (Ticket__c ticket : tickets) {
            ticket.Checked_In__c = false;
            
            if (ticket.Train__r.Train_number__c =='09012' && firstTicket){
                firstTicket=false;
                System.debug('TICKET NUMBER---'+ticket.Name);
                ticket.Booking_DateTime__c=String.valueOf(Date.today().AddDays(-5).day()).leftPad(2,'0') + '/'
                + String.valueOf(Date.today().AddDays(-5).month()).leftPad(2,'0') + '/'
                + String.valueOf(Date.today().AddDays(-5).year()) + ' 01:00:00';
            }
            
        }
        update tickets;
		Train__c tr =[SELECT pre_travel_rule__c, Train_Number__c FROM TRAIN__c where Train_Number__c='09010' limit 1];
        System.debug('Rule - '+tr.Train_Number__c+'-'+tr.Pre_Travel_Rule__c);
        compensations = [SELECT Id FROM Compensation__c];
        System.assertEquals(0, compensations.size());

        Test.startTest();
        System.debug('Test Start Here');
        Database.executeBatch(new CompApp_ScheduledPreTravelCompensation(), 200);
        Test.stopTest();

        compensations = [SELECT Id FROM Compensation__c];
        system.debug('compensations.size()' + compensations.size());
        System.assertEquals(5, compensations.size());
        
        compensations = [SELECT Id, Pre_Travel__c, Total_Online_Compensation__c, Voucher_expiry_date__c, Total_Online_Points__c FROM Compensation__c Where Train__r.Name='09010'];
        System.assertEquals(2, compensations.size());
        System.assertEquals(Date.valueOf('2021-01-01'), compensations[0].Voucher_expiry_date__c);
        System.assertEquals(10, compensations[0].Total_Online_Compensation__c);
        SYstem.debug('ompensations[0].Total_Online_Points__'+compensations[0].Total_Online_Points__c);
        System.assert(compensations[0].Total_Online_Points__c==50);//No Rate Specified. Hence convertion rate is .20
        
        compensations = [SELECT Id, Pre_Travel__c, Total_Online_Compensation__c, Voucher_expiry_date__c, Total_Online_Points__c FROM Compensation__c Where Train__r.Name='09011'];
        System.assertEquals(2, compensations.size());
        System.assertEquals(Date.valueOf('2021-02-01'), compensations[0].Voucher_expiry_date__c);
        System.assertEquals(5, compensations[0].Total_Online_Compensation__c);
        System.assert(compensations[0].Total_Online_Points__c==0);
        
        compensations = [SELECT Id, Pre_Travel__c, Total_Online_Compensation__c, Voucher_expiry_date__c, Total_Online_Points__c  FROM Compensation__c Where Train__r.Name='09013'];
        System.assertEquals(0, compensations.size()); 
        
        compensations = [SELECT Id, Pre_Travel__c, Total_Online_Compensation__c, Voucher_expiry_date__c, Total_Online_Points__c, Ticket__r.Name,Ticket__r.Ticket_price__c  FROM 
                         Compensation__c Where Train__r.Name='09012' and Total_Online_Compensation__c=5];
        
         System.assertEquals(1, compensations.size()); 
    }

    public static List<SObject> insertTestRecords(Integer numberOfTrains, Integer numberOfTicketsPerTrain, Date departureDate, Date bookingDate ) {

        String departureDateString = String.valueOf(departureDate.day()).leftPad(2,'0') + '/'
                + String.valueOf(departureDate.month()).leftPad(2,'0') + '/'
                + String.valueOf(departureDate.year()) + ' 01:00:00';
        String bookingDateString = String.valueOf(departureDate.day()).leftPad(2,'0') + '/'
                + String.valueOf(departureDate.month()).leftPad(2,'0') + '/'
                + String.valueOf(departureDate.year()) + ' 01:00:00';

        List<Train__c> testTrains = new List<Train__c>();
        List<Ticket__c> testTickets = new List<Ticket__c>();

        for (Integer i = 0; i < numberOfTrains; i++) {
            Train__c train;
            train = new Train__c(
                    Name = '0901' + String.valueOf(i),
                    Departure_Date_Time__c = departureDateString,
                    Cancelled__c = false,
                	Train_number__c= '0901' + String.valueOf(i),
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
                    	Booking_DateTime__c = bookingDateString,
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
        //prepareAdditionalCompensationRules();
       
    }
     
    private static void createPreTravelCompensationRules(String Justification, String TrainNumber, Date BookingDateFrom, Date BookingDateTo, Boolean AllowLoyaltyPoints, Integer VoucherLifeInMonths, Date VoucherExpiryDate, Integer CompensationPct){ 
         List<Additional_Compensation_Rules__c> rules =  new  List<Additional_Compensation_Rules__c> ();
         system.debug('Creating rules');
         Id RecordTypeIdPreTravel = Schema.SObjectType.Additional_Compensation_Rules__c.getRecordTypeInfosByName().get('Pre-Travel Rule').getRecordTypeId();

         rules.add(new Additional_Compensation_Rules__c(Trains__c=TrainNumber,Rule_Justification__c=Justification, date_from__c = Date.today().addDays(-1) , 
                                                        date_to__c = Date.today().adddays(100),Additional_Percentage__c=CompensationPct,
                                                        RecordTypeId=RecordTypeIdPreTravel,
                                                        Additional_PRR_Percentage__c=30, 
                                                        Booking_Date_From__c=BookingDateFrom ,
                   										Booking_Date_To__c=BookingDateTo,
             											Allow_Loyalty_points__c=AllowLoyaltyPoints,
             											Voucher_Life_In_Months__c = VoucherLifeInMonths,
             											Fixed_Expiry_Date__c = VoucherExpiryDate )); 
     	 
    	 insert rules;        
    }	
}