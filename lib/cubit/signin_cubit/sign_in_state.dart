abstract class SignInState {}

class SignInInitial extends SignInState {}

class VisablePasswordState extends SignInState {}

class StartSignInProcessState extends SignInState {}

class SucessSignInProcessState extends SignInState {}

class FaildSignInProcessState extends SignInState {}
