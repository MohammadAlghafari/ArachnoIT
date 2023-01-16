part of 'profile_provider_licenses_bloc.dart';

abstract class ProfileProviderLicensesEvent extends Equatable {
  const ProfileProviderLicensesEvent();

  @override
  List<Object> get props => [];
}

class GetAllLicenses extends ProfileProviderLicensesEvent {
  final bool newRequest;
  final String userId;
  GetAllLicenses({this.newRequest,@required this.userId});
}

class ChangeTheFileImagePath extends ProfileProviderLicensesEvent {
}

class AddNewLicense extends ProfileProviderLicensesEvent {
  final String title;
  final String description;
  final File file;
  final BuildContext context;
  AddNewLicense({this.description, this.file, this.title, this.context});
}

class UpdateLicense extends ProfileProviderLicensesEvent {
  final String title;
  final String description;
  final File file;
  final BuildContext context;
  final String id;
  UpdateLicense(
      {this.description, this.file, this.title, this.context, this.id});
}


class UpdateSelectedLicenseAfterSuccessRequest extends ProfileProviderLicensesEvent{
  final int index;
  final NewLicenseResponse license;
  UpdateSelectedLicenseAfterSuccessRequest({this.index,this.license});
}

class DeleteLicenseEvent extends ProfileProviderLicensesEvent {
  final int index;
  final String typeId;
  final BuildContext context;
  DeleteLicenseEvent({this.index, this.typeId,@required this.context});
}