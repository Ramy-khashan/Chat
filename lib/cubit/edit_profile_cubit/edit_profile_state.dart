abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class GetImageState extends EditProfileState {}

class GetStaticImageState extends EditProfileState {}

class GettingUserDataState extends EditProfileState {}
class ResetImageFileState extends EditProfileState {}

class ChosseImageState extends EditProfileState {}

class SuccessGettingUserDataState extends EditProfileState {}

class FaildGettingUserDataState extends EditProfileState {}

class GetIsPrivacyState extends EditProfileState {}

class ChangePrivacyState extends EditProfileState {}

class UpdateUserDataState extends EditProfileState {}

class FaildUpdateUserDataState extends EditProfileState {}

class SuccessUpdateUserDataState extends EditProfileState {}

class UploadImageState extends EditProfileState {}
