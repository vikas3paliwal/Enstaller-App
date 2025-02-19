
import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:enstaller/core/constant/app_colors.dart';
import 'package:enstaller/core/model/appointmentDetailsModel.dart';
import 'package:enstaller/core/constant/app_string.dart';
import 'package:enstaller/core/constant/appconstant.dart';
import 'package:enstaller/core/constant/image_file.dart';
import 'package:enstaller/core/constant/size_config.dart';
import 'package:enstaller/core/enums/view_state.dart';
import 'package:enstaller/core/model/send/answer_credential.dart';
import 'package:enstaller/core/provider/base_view.dart';
import 'package:enstaller/core/viewmodel/home_screen_viewmodel.dart';
import 'package:enstaller/core/viewmodel/survey_screen_viewmodel.dart';
import 'package:enstaller/ui/screen/widget/homescreen/home_page_list_widget.dart';
import 'package:enstaller/ui/screen/widget/homescreen/homepage_expandsion_widget.dart';
import 'package:enstaller/ui/screen/widget/homescreen/view_appointment_list_widget.dart';
import 'package:enstaller/ui/screen/widget/homescreen/view_single_date_widget.dart';
import 'package:enstaller/ui/shared/app_drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  DateTime selectedDate = DateTime.now();
  ScrollController _scrollController = new ScrollController();
  SharedPreferences preferences;
  List<Appointment> _listofappointment =[];

  _subscribeconnectivity() async{
     preferences = await SharedPreferences.getInstance();
     _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_change);
   
  }
  _change(ConnectivityResult result){
  print("change");
  String status =  _updateConnectionStatus(result);
  String removeid;
  if(status!="NONE" && preferences.getStringList("listOfUnSubmittedForm")!=null){
  List<String> _listOfUnSubmittedForm = preferences.getStringList("listOfUnSubmittedForm");
  _listOfUnSubmittedForm.forEach((appointmentid) { 
    removeid = appointmentid;
     for(int i=0;i<3;i++){
       List<AnswerCredential> _answerlist = [];
       List<String> _listofEachKey = preferences.getStringList("key${i.toString()}+$appointmentid");
       if(_listofEachKey!=null){
        _listofEachKey.forEach((element) { 
           _answerlist.add(AnswerCredential.fromJson(jsonDecode(element)));
        }); 
        preferences.remove("key${i.toString()}+$appointmentid");
        SurveyScreenViewModel().onSubmitOffline(i, appointmentid, _answerlist);
       } 
     }
  });
  _listOfUnSubmittedForm.remove(removeid);
  }
  }
  String _updateConnectionStatus(ConnectivityResult result)  {
    switch (result) {
      case ConnectivityResult.wifi:
        return "WIFI";
        break;
      case ConnectivityResult.mobile:
        return "MOBILE";
        break;
      case ConnectivityResult.none:
        return "NONE";
        break;
      default:
        return "NO RECORD";
        break;
    }
  }


  @override
  void initState() {
    _subscribeconnectivity();
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    FlutterStatusbarcolor.setStatusBarColor(AppColors.green);

    SizeConfig.sizeConfigInit(context);
    return SafeArea(
      child: BaseView<HomeScreenViewModel>(
        onModelReady: (model) => model.getAppointmentList(),
        builder: (context,model,child){
          _listofappointment = model.appointMentList;
          return Scaffold(
            backgroundColor: AppColors.scafoldColor,
            key: _scaffoldKey,
            drawer: Drawer(
              child:AppDrawerWidget(),
            ),
            appBar: AppBar(
              backgroundColor: AppColors.green,
              leading: Padding(
                padding: const EdgeInsets.all(18.0),
                child: InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Image.asset(
                      ImageFile.menuIcon,
                    )),
              ),
              title: Text(AppStrings.dashboard,style: TextStyle(
                color: AppColors.whiteColor,fontWeight: FontWeight.w500
              ),),
              centerTitle: true,
              actions: [
                // model.dateSelected?InkWell(child: Icon(Icons.clear), onTap: (){
                //   model.onToggleDateSelected();
                // }):InkWell(
                //   child: Image.asset(
                //     ImageFile.calendarIcon,
                //     width: MediaQuery.of(context).size.width * 0.06,
                //     height: MediaQuery.of(context).size.height * 0.06,
                //   ),
                //   onTap: ()async{
                //     final DateTime picked = await showDatePicker(
                //         context: context,
                //         initialDate: selectedDate,
                //         firstDate: DateTime(2000,12,1),
                //         lastDate:  DateTime(3000,12,1),);
                //     if (picked != null && picked != selectedDate)
                //       setState(() {
                //         selectedDate = picked;
                //         model.onSelectIndex(selectedDate.day-1);
                //         _scrollController.jumpTo((SizeConfig.screenHeight*.15+SizeConfig.verticalC13Padding.top+
                //             SizeConfig.verticalC13Padding.bottom)*(selectedDate.day-1));
                //         model.onToggleDateSelected();


                //       });
                //   },
                // ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.03,
                // ),
                // Icon(Icons.notifications_none,
                // size: MediaQuery.of(context).size.height * 0.035,),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
              ],
            ),
            body: model.state == ViewState.Busy
                ? AppConstants.circulerProgressIndicator()
                :Padding(
              padding: SizeConfig.padding,
              child: model.dateSelected?SingleChildScrollView(
                child: ViewSingleDateWidget(
                  day: (selectedDate.day < 9
                          ? int.parse("0${selectedDate.day}")
                          : (selectedDate.day)) ,
                  appointmentList: model.appointMentList,
                  dateString: selectedDate.year.toString() +
                      "-" +
                      selectedDate.month.toString() +
                      "-" +
                      (selectedDate.day < 9
                          ? "0${selectedDate.day}"
                          : (selectedDate.day).toString()),
                ),
              ):ListView.builder(
                controller: _scrollController,
                  itemCount: 2
                  //model.appointMentList.length
                  ,
                  itemBuilder: (context, int index) {
                    return Padding(
                      padding: SizeConfig.verticalC8Padding,
                      child: InkWell(
                        onTap: () {},
                        child: BaseView<HomeScreenViewModel>(
                          
                          builder: (context,pModel,child){
                            var date = DateTime.now()?.year.toString() +
                                "-" +
                                DateTime.now()?.month.toString() +
                                "-" +
                                (index == 0
                                    ? getCurrentDay(DateTime.now()).toString()
                                    : getNextDay(DateTime.now()).toString());

                            String dateString = index==0? DateFormat.MMMM().format(DateTime.now()) +
                                                        " " + getCurrentDay(DateTime.now()).toString() : DateFormat.MMMM().format(getNextDate(DateTime.now())) +
                                                        " " +getNextDay(DateTime.now()).toString();
                            return HomePageExpansionWidget(
                              onTap: (){
                                model.onSelectIndex(index); 
//                              pModel.getTable(date);
                              },
                              showSecondWidget:index==model.selectedIndex ,
                              firstWidget: HomePageListWidget(

                                height: SizeConfig.screenHeight*.15,
                                dateString: dateString ,
                                expanded: index==model.selectedIndex,
                              ),
                              secondWidget:  Container(
//                                color:  AppColors.appbarColor,
                                child: BaseView<HomeScreenViewModel>(
                                  onModelReady: (model)=>model.getTable(index==0? getCurrentDay(DateTime.now()):  getNextDay(DateTime.now()), _listofappointment),
                                  builder: (context,secondModel,child){
                                    if(secondModel.state==ViewState.Busy){
                                      return AppConstants.circulerProgressIndicator();
                                    }
                                    return Container(
//                                      color: AppColors.expansionColor,

                                      child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxHeight:
                                              AppConstants.getExpandedListHeight(secondModel.tables.isEmpty,secondModel.tables.length)),
                                          child: (secondModel.tables.length>0)
                                              ? ViewAppointmentListWidget(
                                            tables: secondModel.tables,
                                          ) : Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color:
                                              Colors.white,
                                                border: Border.all(color: AppColors.lightGrayDotColor)
                                            ),
                                            padding:
                                            EdgeInsets.all(0),

                                            height:
                                            MediaQuery.of(context).size.height * 0.21,
                                            width:
                                            double.infinity,
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(AppStrings.noDataFound),
                                            ),
                                          )),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }
  
  int getCurrentDay(DateTime date){
    return date.day;
  }
  int getNextDay(DateTime date){
    final tomorrow = DateTime(date.year, date.month, date.day + 1);
    return tomorrow.day;
  }
  getNextDate(DateTime date){
    return DateTime(date.year, date.month, date.day + 1);
  }

}
