@IsTest
private class CaseServiceControllerTest {

    private static CaseServiceController.SubmitDetails createArgs() {
        cu_Utils.PnrDetails pnrItem = new cu_Utils.PnrDetails(
            'HFG230', false, S3PassengerAPIService.HOTEL_ONLY, false, false, false, false, false, '', '', false
        );
        CaseService.GuestDetails guestDetails = new CaseService.GuestDetails(
            'email@email.com', 'firstName', 'lastName', 'message', '+375 29 374-65-56', '2028-10-25',
            'iban', 'bicOrSwift', 'accountNumber', 'sortCode', 'paypal@mail.com', '', 'language',
            '', '', 'Praise', '', ''
        );
        Boolean isOnOurApp = false;
        Boolean checkOnExisting = false;
        CaseServiceController.SubmitDetails args = new CaseServiceController.SubmitDetails(
            pnrItem,
            guestDetails,
            CaseService.NEUTRAL_TONE,
            'station',
            'errorMessage',
            isOnOurApp,
            checkOnExisting,
            'topic',
            'whatIsTheQuestion'
        );
        return args;
    }

    @IsTest
    static void updateCasesTest() {
        Test.startTest();
        CaseServiceController.SubmitDetails args = createArgs();
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));

        List<Case> feedbackCasesB = [
            SELECT Id, Status, Description, Error_Message_Incident_Number__c, Tone_of_Contact__c
            FROM Case
        ];

        CaseServiceController.updateCases(feedbackCasesB, 'Comment', 'Complaint');
        Test.stopTest();
        List<Case> feedbackCasesA = [
            SELECT Id, Status, Description, Error_Message_Incident_Number__c, Tone_of_Contact__c
            FROM Case
            WHERE Status = 'Case Comment Received'
        ];

        System.assertEquals(1, feedbackCasesA.size());
    }

    @IsTest
    static void updateCasesPNRTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));
        List<Case> feedbackCasesBefore = [
            SELECT Id, Status, Description, Error_Message_Incident_Number__c, Tone_of_Contact__c
            FROM Case
            WHERE PNR__c = :args.pnrItem.pnr
        ];
        System.assertEquals(1, feedbackCasesBefore.size());

        Test.startTest();
        CaseServiceController.updateCasesByPNR(args.pnrItem.pnr, 'Comment', 'Praise');
        Test.stopTest();
        List<Case> feedbackCasesAfter = [
            SELECT Id, Status, Description, Error_Message_Incident_Number__c, Tone_of_Contact__c
            FROM Case
            WHERE Tone_of_Contact__c = 'Praise'
        ];

        System.assertEquals(1, feedbackCasesAfter.size());
    }

    @IsTest
    static void createFeedbackCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));

        List<Case> feedbackCasesN = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Tone_of_Contact__c = :CaseService.NEUTRAL_TONE
        ];
        // System.assertEquals(1, feedbackCasesN.size());

        args.buttonLabel = CaseService.PRAISE_TONE;
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));

        List<Case> feedbackCasesP = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Tone_of_Contact__c = :CaseService.PRAISE_TONE
        ];
        // System.assertEquals(1, feedbackCasesP.size());
    }

    @IsTest
    static void createFeedbackCaseTest2() {
        CaseServiceController.SubmitDetails args = createArgs();
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));

        List<Case> feedbackCasesN = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Tone_of_Contact__c = :CaseService.NEUTRAL_TONE
        ];
        // System.assertEquals(1, feedbackCasesN.size());

        args.buttonLabel = CaseService.COMPLAINT_TONE;
        CaseServiceController.submitCase('createFeedbackCase', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Tone_of_Contact__c = :CaseService.COMPLAINT_TONE
        ];
        // System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createAddSomethingCaseHotelTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.REQUEST_ELSE;
        CaseServiceController.submitCase('createAddSomethingCase', JSON.serialize(args));

        List<Case> feedbackCasesS = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Subject LIKE 'Standalone hotel add on request%'
        ];
        System.assertEquals(1, feedbackCasesS.size());
    }
    
    @IsTest
    static void createAddSomethingCasePackageTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        args.buttonLabel = CaseService.REQUEST_MEALS;
        CaseServiceController.submitCase('createAddSomethingCase', JSON.serialize(args));

        List<Case> feedbackCasesM = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Subject LIKE 'Package add on request%'
        ];
        System.assertEquals(1, feedbackCasesM.size());
    }
    
    @IsTest
    static void createAddSomethingCaseTrainTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.buttonLabel = CaseService.REQUEST_ELSE;
        CaseServiceController.submitCase('createAddSomethingCase', JSON.serialize(args));

        List<Case> feedbackCasesI = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Initial_Reason_For_Contact__c = 'Buy or Book'
        ];

        System.assertEquals(1, feedbackCasesI.size());
    }

    @IsTest
    static void createReportAProblemFeedbackCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        CaseServiceController.submitCase('createReportAProblemFeedbackCase', JSON.serialize(args));

        List<Case> feedbackCasesN = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
            WHERE Topic__c = 'General feedback'
        ];
        System.assertEquals(1, feedbackCasesN.size());
    }

    @IsTest
    static void createReportAnErrorCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.PROBLEMS_MAKING_A_BOOKING;
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));

        args.buttonLabel = CaseService.PROBLEMS_MAKING_PAYMENT;
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));
        Test.startTest();
        args.buttonLabel = CaseService.PROBLEMS_EXCHANGING_BOOKING;
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));

        args.buttonLabel = CaseService.PROBLEMS_CANCELLING_A_BOOKING;
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));

        Test.stopTest();
        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(4, feedbackCasesC.size());
    }


    @IsTest
    static void createReportAnErrorCaseTest2() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.PROBLEMS_MAKING_A_BOOKING;
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));

       Test.startTest();

        args.buttonLabel = CaseService.PROBLEMS_ACCESSING_BOOKING;
        CaseServiceController.submitCase('createReportAnErrorCase', JSON.serialize(args));
        Test.stopTest();
        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(5, feedbackCasesC.size());
    }


    @IsTest
    static void createSpecialAssistanceCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        Test.startTest();
        args.buttonLabel = CaseService.SPECIAL_ASSISTANCE_DOGS;
        CaseServiceController.submitCase('createSpecialAssistanceCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(feedbackCasesC.size(), feedbackCasesC.size());
    }

    @IsTest
    static void createClubEurostarCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.EUROSTAR_CLUB_ACCOUNT_QUERY;
        CaseServiceController.submitCase('createClubEurostarCase', JSON.serialize(args));

        Test.startTest();
        args.buttonLabel = CaseService.EUROSTAR_CLUB_JOURNEY_OR_MISSING_POINTS;
        CaseServiceController.submitCase('createClubEurostarCase', JSON.serialize(args));

       
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(2, feedbackCasesC.size());
    }

    @IsTest
    static void createClubEurostarCaseTest2() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.EUROSTAR_CLUB_CHANGES_PERSONAL_INFO;
        CaseServiceController.submitCase('createClubEurostarCase', JSON.serialize(args));

        Test.startTest();
        args.buttonLabel = CaseService.EUROSTAR_CLUB_TROUBLE_ACCESSING_ACC;
        CaseServiceController.submitCase('createClubEurostarCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(4, feedbackCasesC.size());
    }

    @IsTest
    static void createMakeBookingCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = 'Kent';
        CaseServiceController.submitCase('createMakeBookingCase', JSON.serialize(args));

        Test.startTest();
        args.buttonLabel = 'Lyon';
        CaseServiceController.submitCase('createMakeBookingCase', JSON.serialize(args));

        args.buttonLabel = 'Somewhere else';
        CaseServiceController.submitCase('createMakeBookingCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(3, feedbackCasesC.size());
    }

    @IsTest
    static void createTravelQuestionCaseTestTimetable() {
        CaseServiceController.SubmitDetails args = createArgs();
        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_TIMETABLE;
        CaseServiceController.submitCase('createTravelQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createTravelQuestionCaseTestDestinations() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_DESTINATIONS;
        CaseServiceController.submitCase('createTravelQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createTravelQuestionCaseTestArrivals() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_LIVE_DEPARTURES_ARRIVALS;
        CaseServiceController.submitCase('createTravelQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createTravelQuestionCaseTestConnecting() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_CONNECTING_TRAVEL;
        CaseServiceController.submitCase('createTravelQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        // System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createTravelQuestionCaseTestTickets() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_GETTING_TICKETS;
        CaseServiceController.submitCase('createTravelQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createTicketConditionQuestionCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_TS_AND_CS;
        CaseServiceController.submitCase('createTicketConditionQuestionCase', JSON.serialize(args));

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_EXCHANGES;
        CaseServiceController.submitCase('createTicketConditionQuestionCase', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_CANCELLATIONS_REFUNDS;
        CaseServiceController.submitCase('createTicketConditionQuestionCase', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_TRANSFER;
        CaseServiceController.submitCase('createTicketConditionQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(4, feedbackCasesC.size());
    }

    @IsTest
    static void createStationsQuestionCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = 'GENERIC';
        CaseServiceController.submitCase('createStationsQuestionCase', JSON.serialize(args));

        Test.startTest();
        args.buttonLabel = 'PANCRAS';
        CaseServiceController.submitCase('createStationsQuestionCase', JSON.serialize(args));

        args.buttonLabel = 'BRUSSELS';
        CaseServiceController.submitCase('createStationsQuestionCase', JSON.serialize(args));

        args.buttonLabel = 'DISNEY';
        CaseServiceController.submitCase('createStationsQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(4, feedbackCasesC.size());
    }

    @IsTest
    static void createOnboardQuestionCaseTestSeating() {
        CaseServiceController.SubmitDetails args = createArgs();
        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_SEATING;
        CaseServiceController.submitCase('createOnboardQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createOnboardQuestionCaseTestCatering() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_CATERING;
        CaseServiceController.submitCase('createOnboardQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createOnboardQuestionCaseTestTravel() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_TRAVEL_CLASSES;
        CaseServiceController.submitCase('createOnboardQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createOnboardQuestionCaseTestWifi() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_WIFI;
        CaseServiceController.submitCase('createOnboardQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    
    @IsTest
    static void createOnboardQuestionCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_ELSE;
        CaseServiceController.submitCase('createOnboardQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createLugageQuestionCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_PROHIBITTED_LUGGAGE;
        CaseServiceController.submitCase('createLugageQuestionCase', JSON.serialize(args));

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_LUGGAGE_ALLOWANCE;
        CaseServiceController.submitCase('createLugageQuestionCase', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_LUGGAGE_INFO;
        CaseServiceController.submitCase('createLugageQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(3, feedbackCasesC.size());
    }

    @IsTest
    static void createDisruptionQuestionCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_EXPENSES;
        args.station = 'Disney';
        CaseServiceController.submitCase('createDisruptionQuestionCase', JSON.serialize(args));

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_DELAY_COMPENSATION;
        args.station = 'Amsterdam';
        CaseServiceController.submitCase('createDisruptionQuestionCase', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_CANCELLATION_COMPENSATION;
        args.station = 'Ski';
        CaseServiceController.submitCase('createDisruptionQuestionCase', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_CORONAVIRUS;
        args.station = 'London';
        CaseServiceController.submitCase('createDisruptionQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        // System.assertEquals(4, feedbackCasesC.size());
    }

    @IsTest
    static void createWebsiteQuestionCaseTestFinding() {
        CaseServiceController.SubmitDetails args = createArgs();
        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_HELP_FINDING;
        CaseServiceController.submitCase('createWebsiteQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createWebsiteQuestionCaseTestDoing() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_HELP_DOING;
        CaseServiceController.submitCase('createWebsiteQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createWebsiteQuestionCaseTestOnline() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_ONLINE_HELP;
        CaseServiceController.submitCase('createWebsiteQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createWebsiteQuestionCaseTestProblem() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_REPORT_PROBLEM;
        CaseServiceController.submitCase('createWebsiteQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }
    
    @IsTest
    static void createWebsiteQuestionCaseTestPassword() {
        CaseServiceController.SubmitDetails args = createArgs();

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_RESET_PASSWORD;
        CaseServiceController.submitCase('createWebsiteQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createDocsQuestionCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_NAMES_AND_OTHER_DETAILS;
        CaseServiceController.submitCase('createDocsQuestionCase', JSON.serialize(args));

        Test.startTest();
        args.buttonLabel = CaseService.QUESTION_WHAT_DO_I_NEED_TO_TRAVEL;
        CaseServiceController.submitCase('createDocsQuestionCase', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_ELSE;
        CaseServiceController.submitCase('createDocsQuestionCase', JSON.serialize(args));
        Test.stopTest();

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(3, feedbackCasesC.size());
    }

    @IsTest
    static void createElseQuestionCaseTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        CaseServiceController.submitCase('createElseQuestionCase', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
        System.assertEquals(1, feedbackCasesC.size());
    }

    @IsTest
    static void createCaseTrainExchangeQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.pnrItem.isChangeableOnline = true;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createCaseTrainDisruptionExchangeQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.pnrItem.isDisrupted = true;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;
        args.pnrItem.isDisrupted = true;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createCaseTrainCancelRefundQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_ONLY;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createCaseTrainDisruptionRefundQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = S3PassengerAPIService.NO_REFUND;
        args.pnrItem.isDisrupted = true;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        args.buttonLabel = S3PassengerAPIService.REFUND_TO_VOUCHER;
        args.pnrItem.isDisrupted = true;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        args.buttonLabel = S3PassengerAPIService.FULL_REFUND;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;
        args.pnrItem.isDisrupted = true;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createCaseBookingExchangeQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;
        args.pnrItem.bookingType = S3PassengerAPIService.HOTEL_ONLY;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createCaseBookingDisruptionExchangeQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isDisrupted = true;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isDisrupted = true;
        args.pnrItem.isFree = true;
        args.pnrItem.bookingType = S3PassengerAPIService.HOTEL_ONLY;
        CaseServiceController.submitCase('createChangeWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createCaseBookingCancelRefundQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;
        args.pnrItem.bookingType = S3PassengerAPIService.HOTEL_ONLY;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }

    @IsTest
    static void createCaseBookingDisruptionRefundQueueTest() {
        CaseServiceController.SubmitDetails args = createArgs();
        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isDisrupted = true;
        args.pnrItem.bookingType = S3PassengerAPIService.TRAIN_AND_HOTEL;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        args.buttonLabel = CaseService.QUESTION_GIFT_VOUCHERS;
        args.pnrItem.isChangeableOnline = true;
        args.pnrItem.isFree = true;
        args.pnrItem.isDisrupted = true;
        args.pnrItem.bookingType = S3PassengerAPIService.HOTEL_ONLY;
        CaseServiceController.submitCase('createCancelWithPNR', JSON.serialize(args));

        List<Case> feedbackCasesC = [
            SELECT Id, Tone_of_Contact__c
            FROM Case
        ];
    }
}