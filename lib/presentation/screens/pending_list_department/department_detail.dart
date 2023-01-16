import 'package:arachnoit/application/pending_list_department/pending_list_department_bloc.dart';
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/department_model.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DepartmentDetail extends StatefulWidget {
  final DepartmentModel departmentModel;

  const DepartmentDetail({Key key, @required this.departmentModel})
      : super(key: key);

  @override
  _DepartmentDetailState createState() => _DepartmentDetailState();
}

class _DepartmentDetailState extends State<DepartmentDetail> {

  PendingListDepartmentBloc pendingListDepartmentBloc;
  Color primaryColor;
  Color accentColor;
  @override
  void initState() {
    super.initState();
    pendingListDepartmentBloc = serviceLocator<PendingListDepartmentBloc>();
    pendingListDepartmentBloc.add(GetDepartmentDetailByIdEvent(departmentId: widget.departmentModel?.id));
  }
  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).primaryColor;
    accentColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: appBar(context),
      body: departmentDetailBody(),
    );
  }

  Widget appBar(BuildContext context) {
    return AppBar(
      title: Text(
       AppLocalizations.of(context).pending_list,
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w300),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.black87,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      // actions: [iconPopupMenu()],
    );
  }

  Widget iconPopupMenu() {
    return PopupMenuButton(itemBuilder: (context) {
      return [
        PopupMenuItem(
            value: "delete",
            child: Text(
                AppLocalizations.of(context).delete_your_account,

          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black87),
        )),
      ];
    },
      onSelected: onSelected,
    );
  }

  void onSelected(String value) {
    if(value == "delete")
      deleteYourAccountAction();
  }

  void deleteYourAccountAction() {
    print("deleteYourAccountAction");
  }


  Widget departmentDetailBody() {
    return Stack(
      children: [
        Positioned(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              )
            ),
            child: Padding(
              padding:  EdgeInsets.only(top: 20),
              child: Text(
                  AppLocalizations.of(context).department_details,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: 50,
          child:RefreshIndicator(
            color: accentColor,
            onRefresh: ()async{
              pendingListDepartmentBloc.add(GetDepartmentDetailByIdEvent(departmentId: widget.departmentModel?.id));

            },
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 10,right: 10,top: 100),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cardHeader(
                      description: widget.departmentModel?.name,
                      title:AppLocalizations.of(context).department_name,
                      assetImage: "assets/images/hospital.svg"
                    ),
                    cardHeader(
                        description: widget.departmentModel?.totalTeamMembersCount.toString(),
                        title: AppLocalizations.of(context).total_member_count,
                        assetImage: "assets/images/team.svg"
                    ),
                  ],
                ),
                cardInformation(
                  description: widget.departmentModel?.description,
                  owner: widget.departmentModel?.owner?.inTouchPointName ,
                ),
                approvedMemberList(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget cardHeader({
    @required String assetImage,
    @required String title,
    @required String description
  }){
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 150,
      child: Card(
        elevation: 0.0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
         children: [
           SizedBox(height: 10,),
           SvgPicture.asset(
              assetImage,
             fit: BoxFit.scaleDown,
             width: 50 ,height: 50,
             alignment: Alignment.center,
           ),
           SizedBox(
             height: 10,
           ),
           Text(
             title ?? "",
             textAlign: TextAlign.center,
             style: TextStyle(
             color: accentColor
           ),),
           SizedBox(
             height: 5,
           ),
           Text(description ?? ""),
         ],
       ),
      ),
    );
  }

  Widget cardInformation({@required String owner ,@required String description}){
    return Card(
      elevation: 0.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).department_information+':' ,style: TextStyle(
              color: accentColor,
            ),),
            Divider(
              color: primaryColor,
              thickness: 1.5,
            ),
            Text(AppLocalizations.of(context).owner , style: TextStyle(
              color: accentColor,
            ),),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(owner ?? ""),
            ),
            SizedBox(
              height: 10,
            ),
            Text(AppLocalizations.of(context).description+':',style: TextStyle(
              color: accentColor,
            ),),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(description ?? ""),
            ),
          ],
        ),
      ),
    );
  }

  Widget approvedMemberList(){
    return Card(
      elevation: 0.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).approved_team_members,
                style:TextStyle(color: accentColor,)),
            Divider(
              color: primaryColor,
              thickness: 1.5,
            ),
            BlocProvider.value(
                value: pendingListDepartmentBloc,
              child: BlocConsumer<PendingListDepartmentBloc, PendingListDepartmentState>(
                listener: (_,state){},
                builder: (_ , state){
                  if(state.stateStatus == PendingListDepartmentStatus.getDepartmentByIdLoading)
                    return Center(child: CircularProgressIndicator());
                  else if(state.stateStatus == PendingListDepartmentStatus.getDepartmentByIdSuccess) {
                   final teamMemberList = state.departmentByIdModel.teamMembers;
                    return teamMemberList.isNotEmpty
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final teamMember = teamMemberList[index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(90.0),
                                  child: CachedNetworkImage(
                                    imageUrl: Urls.BASE_URL +
                                        ((teamMember.photo == null)
                                            ? ""
                                            : teamMember.photo),
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            CircularProgressIndicator(
                                                value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(teamMember.inTouchPointName),
                              );
                            },
                            itemCount: teamMemberList.length,
                            shrinkWrap: true,
                    )
                        : BlocError(
                      context: context,
                      function: (){
                        pendingListDepartmentBloc.add(GetDepartmentDetailByIdEvent(departmentId: widget.departmentModel.id));
                      },
                      blocErrorState: BlocErrorState.noPosts,
                    );
                  } else
                    return BlocError(
                      context: context,
                      function: (){
                        pendingListDepartmentBloc.add(GetDepartmentDetailByIdEvent(departmentId: widget.departmentModel.id));
                      },
                      blocErrorState: BlocErrorState.userError,
                    );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
