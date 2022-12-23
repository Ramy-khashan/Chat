abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class GetImageState extends EditProfileState {}

class GetStaticImageState extends EditProfileState {}

class GettingUserDataState extends EditProfileState {}

class SuccessGettingUserDataState extends EditProfileState {}

class FaildGettingUserDataState extends EditProfileState {}

class UpdateUserDataState extends EditProfileState {}

class FaildUpdateUserDataState extends EditProfileState {}

class SuccessUpdateUserDataState extends EditProfileState {}

class UploadImageState extends EditProfileState {}
