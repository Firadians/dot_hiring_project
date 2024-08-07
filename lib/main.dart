import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'database.dart';
import 'home_screen.dart';
import 'bloc/user_bloc.dart';
import 'bloc/expense_bloc.dart';
import 'bloc/category_bloc.dart';
import 'bloc/transaction_bloc.dart';
import 'models/category_model.dart';
import 'models/transaction_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the database
  final dbHelper = DatabaseHelper();

  // Insert a username (for testing purposes, you can remove this later)
  await dbHelper.insertUser("User!");
  // await dbHelper.insertExpenses(30000, 335500);

  // // Insert categories (for testing purposes, you can remove this later)
  // await dbHelper.insertCategories([
  //   Category(name: "Makanan", amount: 70000, icon: "pizza_vector.svg"),
  //   Category(name: "Internet", amount: 50000, icon: "makanan_vector.svg"),
  //   Category(name: "Edukasi", amount: 20000, icon: "hadiah_vector.svg"),
  //   Category(name: "Hadiah", amount: 20000, icon: "alat_rumah_vector.svg"),
  //   Category(name: "Transportasi", amount: 20000, icon: "belanja_vector.svg"),
  //   Category(name: "Belanja", amount: 20000, icon: "alat_rumah_vector.svg"),
  //   Category(name: "Alat Rumah", amount: 20000, icon: "olahraga_vector.svg"),
  //   Category(name: "Olahraga", amount: 20000, icon: "belanja_vector.svg"),
  //   Category(name: "Hiburan", amount: 20000, icon: "belanja_vector.svg"),
  // ]);

  // // Insert transactions (for testing purposes, you can remove this later)
  // await dbHelper.insertTransactions([
  //   Transaction(
  //       description: "Ayam Geprek", amount: 15000, date: DateTime.now()),
  //   Transaction(description: "Gojek", amount: 15000, date: DateTime.now()),
  //   Transaction(
  //       description: "Paket Data",
  //       amount: 50000,
  //       date: DateTime.now().subtract(Duration(days: 1))),
  // ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(DatabaseHelper())..add(FetchUsername()),
        ),
        BlocProvider(
          create: (context) =>
              ExpenseBloc(DatabaseHelper())..add(FetchExpenses()),
        ),
        BlocProvider(
          create: (context) =>
              CategoryBloc(DatabaseHelper())..add(FetchCategories()),
        ),
        BlocProvider(
          create: (context) =>
              TransactionBloc(DatabaseHelper())..add(FetchTransactions()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
