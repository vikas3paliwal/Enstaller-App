class ApiUrls{
  static String getAppointmentCode = "appointments/UpdateAppointmentStatus";
  static String logInUrl='users/login';
  static String getAppointMentListUrl='appointments/GetAppointmentByEngineerId';
  static String getappointmenttodaytomorrow = 'appointments/GetAppointmentByEngineerIdTodayTomorrow';
  static String getReasonUserList = 'ReasonUserMap/GetReasonUserList';
  static String updateAbortAppointment = 'appointments/UpdateAbortAppointment';
  static String getActivityLogsAppointmentIdUrl='appointments/GetActivityLogsAppointmentId';
  static String getAppointmentCommentsByAppointmentUrl='AppointmentComments/GetAppointmentCommentsByAppointment';
  static String saveAppointmentComments='AppointmentComments/SaveAppointmentComments';
  static String getAppointmentDetailsUrl='appointments/Get';
  static String getCustomerMeterListByCustomerUrl='CustomerMeter/GetCustomerMeterListByCustomer';
  static String appointmentDataEventsbyEngineerUrl='AppointmentEvents/AppointmentDataEventsbyEngineer';
  static String updateAppointmentStatusUrl='appointments/UpdateAppointmentStatus';
  static String getSurveyQuestionAppointmentWiseUrl='SurveyQuetion/GetSurveyQuestionAppointmentWise';
  static String addSurveyQuestionAnswerDetailUrl='SurveyQuestionAnswer/AddSurveyQuestionAnswerDetail';
  static String supplierDocumentUpdateEngineerRead = 'SupplierDocument/SupplierDocumentUpdateEngineerRead';
  static String getCustomerByIdUrl='Customer/GetCustomerById';
  static String getEngineerAppointmentsUrl='appointments/GetEngineerAppointments';
  static String getAppointmentByEngineerIdUrl='appointments/GetAppointmentByEngineerId';
  static String getSurveyQuestionAnswerDetailUrl='SurveyQuestionAnswer/GetSurveyQuestionAnswerDetail';
  static String getSupplierDocument = 'SupplierDocument/GetSupplierDocumentListUserwise';
  static String getEmailTemplateSenderHistoryUserWise = 'EmailTemplateSenderHistory/GetEmailTemplateSenderHistoryUserWise';
  static String getSMSClickSendNotificationUserWise = 'SMSClickSendHistory/GetSMSClickSendNotificationUserWise';
  static String getMAICheckProcess = 'DCCMAI/GetMAICheckProcess';
  //order
  static String getItemsForOrder  = 'Order/BindUserContractWiseItemModel';
  static String getContractsForOrder  = 'Location/GetStockContractList';
  static String saveOrder='Order/InsertUpdateDeleteOrder';
  static String saveOrderLine = 'Order/InsertUpdateDeleteOrderLineItems';
  static String getOrderListByEngId = 'Order/GetOrderListByEngId';
  static String getStockOrderById = 'Order/GetStockOrderById';
  static String  getStockOrderLineDetails= 'Order/GetStockOrderLineDetails';
  static String getOrderExportCSVDetails = 'Order/OrderExportCSVDetails';
  //stock check
  static String getStockCheckRequestList = 'StockCheckRequest/GetEngineerWiseStockRquestList';
  static String validateSerialsForReply = 'StockCheckRequest/ValidateSerials';
  static String saveEngineerReply = 'StockCheckRequest/SaveEngineerReply';
  static String getSerialsByRequestId = 'StockCheckRequest/GetSerialsByRequestId';
  static String getStockOrderLineItemsByOrderId= 'Order/GetStockOrderLineItemsByOrderId';
  static String getSerialListByEmployeeId = 'stkEngineerWiseStock/GetSerialListByEmployeeId';

}