part of 'profile_provider_certificate_bloc.dart';

abstract class ProfileProviderCertificateEvent extends Equatable {
  const ProfileProviderCertificateEvent();

  @override
  List<Object> get props => [];
}

class GetAllCertificate extends ProfileProviderCertificateEvent {
  final bool newRequest;
  final String userId;
  GetAllCertificate({this.newRequest,@required this.userId});
}

class AddNewCertificate extends ProfileProviderCertificateEvent {
  final BuildContext context;
  final String name;
  final String issueDate;
  final String expirationDate;
  final String organization;
  final String url;
  final File file;
  final bool withExpireTime;
  AddNewCertificate({
    this.file,
    this.context,
    this.name,
    this.expirationDate,
    this.issueDate,
    this.organization,
    this.url,
    this.withExpireTime,
  });
}

class UpdateSelectedCertificate extends ProfileProviderCertificateEvent {
  final BuildContext context;
  final String name;
  final String issueDate;
  final String expirationDate;
  final String organization;
  final String url;
  final File file;
  final bool withExpireTime;
  final String id;
  final List<String> removedfiles;
  UpdateSelectedCertificate({
    this.file,
    this.context,
    this.name,
    this.expirationDate,
    this.issueDate,
    this.organization,
    this.url,
    this.withExpireTime,
    this.id,
    this.removedfiles,
  });
}

class ChangeTheFileImagePath extends ProfileProviderCertificateEvent {
  final File file;
  ChangeTheFileImagePath({this.file});
}

class ChangeNoEndDateTimeValue extends ProfileProviderCertificateEvent {
  final bool value;
  ChangeNoEndDateTimeValue({this.value});
}

class UpdateSelectedLicenseAfterSuccessRequest
    extends ProfileProviderCertificateEvent {
  final int index;
  final NewCertificateResponse certificate;
  UpdateSelectedLicenseAfterSuccessRequest({this.index, this.certificate});
}

class DeleteCertificateEvent extends ProfileProviderCertificateEvent {
  final int index;
  final String typeId;
  final BuildContext context;
  DeleteCertificateEvent({this.index, this.typeId,@required this.context});
}
