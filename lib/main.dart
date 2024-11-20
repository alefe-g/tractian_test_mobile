import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tractian_test_mobile/bloc/asset/asset_bloc.dart';
import 'package:tractian_test_mobile/bloc/company/company_bloc.dart';
import 'package:tractian_test_mobile/routes/my_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => CompanyBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider(create: (_) => AssetBloc()),
      ],
      child: _materialApp(),
    );
  }

  MaterialApp _materialApp() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      routes: MyRouter.routes,
      initialRoute: MyRouter.home,
    );
  }
}
