import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian_test_mobile/bloc/company/company_bloc.dart';
import 'package:tractian_test_mobile/bloc/company/company_event.dart';
import 'package:tractian_test_mobile/bloc/company/company_state.dart';
import 'package:tractian_test_mobile/routes/my_router.dart';
import 'package:tractian_test_mobile/styles/app_colors.dart';
import 'package:tractian_test_mobile/styles/app_icons.dart';
import 'package:tractian_test_mobile/styles/app_images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CompanyBloc? _companyBloc;

  @override
  void initState() {
    super.initState();
    _companyBloc = Provider.of(context, listen: false);
    _companyBloc?.addEvent(FetchCompaniesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbar,
        title: Image.asset(AppImages.logo),
      ),
      body: _companyList(),
    );
  }

  Widget _companyList() {
    return StreamBuilder<CompanyState>(
      stream: _companyBloc?.streamState,
      builder: _streamCompanyBuilder,
    );
  }

  Widget _streamCompanyBuilder(
    BuildContext context,
    AsyncSnapshot<CompanyState> snapshot,
  ) {
    if (!snapshot.hasData || snapshot.data is CompanyInitialState) {
      return const Center(child: Text('Welcome to Company App'));
    }

    final state = snapshot.data;

    if (state is CompanyLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CompanyLoadedState) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: state.companies.length,
        itemBuilder: (context, index) {
          final company = state.companies[index];
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                MyRouter.assets,
                arguments: company.id,
              );
            },
            child: Container(
              width: 317,
              height: 76,
              margin: const EdgeInsets.only(
                top: 32,
                left: 32,
                right: 32,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.card,
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  const SizedBox(width: 32),
                  AppIcons.icon,
                  const SizedBox(width: 16),
                  Text(
                    company.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    if (state is CompanyErrorState) {
      return Center(child: Text('Error: ${state.message}'));
    }

    return const Center(child: Text('Unknown State'));
  }
}
