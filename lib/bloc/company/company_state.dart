import 'package:tractian_test_mobile/models/company_model.dart';

abstract class CompanyState {}

class CompanyInitialState extends CompanyState {}

class CompanyLoadingState extends CompanyState {}

class CompanyLoadedState extends CompanyState {
  final List<CompanyModel> companies;
  CompanyLoadedState(this.companies);
}

class CompanyErrorState extends CompanyState {
  final String message;
  CompanyErrorState(this.message);
}

class SelectedCompanyState extends CompanyState {
  final CompanyModel company;
  SelectedCompanyState(this.company);
}