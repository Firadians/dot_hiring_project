import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'models/category_model.dart';
import 'models/transaction_model.dart';
import 'add_expense_screen.dart';
import 'bloc/user_bloc.dart';
import 'bloc/expense_bloc.dart';
import 'bloc/category_bloc.dart';
import 'bloc/transaction_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35), // Add space from the top of the screen
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserInitial) {
                        return UserIntroduction(username: null);
                      } else if (state is UserLoaded) {
                        return UserIntroduction(username: state.user.username);
                      } else if (state is UserError) {
                        return UserIntroduction(
                            username: 'Error: ${state.message}');
                      } else {
                        return UserIntroduction(username: null);
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  BlocBuilder<ExpenseBloc, ExpenseState>(
                    builder: (context, state) {
                      if (state is ExpenseInitial) {
                        return ExpenseSummary(
                            dailyExpense: 0, monthlyExpense: 0);
                      } else if (state is ExpenseLoaded) {
                        return ExpenseSummary(
                          dailyExpense: state.dailyExpense.toInt(),
                          monthlyExpense: state.monthlyExpense.toInt(),
                        );
                      } else if (state is ExpenseError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else {
                        return ExpenseSummary(
                            dailyExpense: 0, monthlyExpense: 0);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Pengeluaran berdasarkan kategori",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            sliver: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryInitial) {
                  return SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()));
                } else if (state is CategoryLoaded) {
                  return SliverToBoxAdapter(
                      child: CategoryList(categories: state.categories));
                } else if (state is CategoryError) {
                  return SliverToBoxAdapter(
                      child: Center(child: Text('Error: ${state.message}')));
                } else {
                  return SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()));
                }
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            sliver: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionInitial) {
                  return SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()));
                } else if (state is TransactionLoaded) {
                  final today = DateTime.now();
                  final yesterday = today.subtract(Duration(days: 1));
                  final todayTransactions =
                      state.transactions.where((transaction) {
                    final transactionDate = transaction.date;
                    return transactionDate.year == today.year &&
                        transactionDate.month == today.month &&
                        transactionDate.day == today.day;
                  }).toList();

                  final yesterdayTransactions =
                      state.transactions.where((transaction) {
                    final transactionDate = transaction.date;
                    return transactionDate.year == yesterday.year &&
                        transactionDate.month == yesterday.month &&
                        transactionDate.day == yesterday.day &&
                        transaction.description.toLowerCase() == "paket data";
                  }).toList();

                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Hari ini",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        SizedBox(height: 8), // Reduced height
                        TransactionList(transactions: todayTransactions),
                        if (yesterdayTransactions.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Kemarin",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          SizedBox(height: 8), // Reduced height
                          TransactionList(transactions: yesterdayTransactions),
                        ],
                      ],
                    ),
                  );
                } else if (state is TransactionError) {
                  return SliverFillRemaining(
                      child: Center(child: Text('Error: ${state.message}')));
                } else {
                  return SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white, // Set the icon color to white
        ),
        backgroundColor: Colors.blue, // Background color of the button
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(100), // Ensures the button is circular
        ),
      ),
    );
  }
}

class UserIntroduction extends StatelessWidget {
  final String? username;

  UserIntroduction({this.username});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: username != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "Halo, ",
                        style: TextStyle(
                          fontSize: 18, // Set the font size to 18
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: username,
                            style: TextStyle(
                              fontSize: 18, // Set the font size to 18
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4), // Space between the texts
                    Text(
                      'Jangan lupa catat keuanganmu setiap hari!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                )
              : Shimmer.fromColors(
                  baseColor: Color.fromARGB(255, 211, 211, 211),
                  highlightColor: Color.fromARGB(255, 211, 211, 211),
                  child: Container(
                    width: double.infinity,
                    height: 60.0, // Increased height to accommodate two lines
                    color: Colors.white,
                  ),
                ),
        ),
      ],
    );
  }
}

class ExpenseSummary extends StatelessWidget {
  final int dailyExpense;
  final int monthlyExpense;

  ExpenseSummary({required this.dailyExpense, required this.monthlyExpense});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ExpenseContainer(
          title: "Pengeluaran\nhari ini",
          amount: dailyExpense,
          color: Colors.blue, // Color for daily expense
        ),
        SizedBox(width: 20), // Add space between the containers
        ExpenseContainer(
          title: "Pengeluaranmu\nbulan ini",
          amount: monthlyExpense,
          color: Colors.teal, // Color for monthly expense
        ),
      ],
    );
  }
}

class ExpenseContainer extends StatelessWidget {
  final String title;
  final int amount;
  final Color color;

  ExpenseContainer(
      {required this.title, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "Rp. $amount",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final List<Category> categories;

  CategoryList({required this.categories});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return CategoryContainer(category: category);
        }).toList(),
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final Category category;

  CategoryContainer({required this.category});

  // Function to determine color based on category name
  Color _getColorForCategory(String name) {
    final colorMap = {
      'Makanan': Colors.yellow,
      'Internet': Colors.blue,
      'Transportasi': Colors.purple,
      'Edukasi': Colors.orange,
      'Hadiah': Colors.orange,
      'Belanja': Colors.orange,
      'Alat Rumah': Colors.orange,
      'Olahraga': Colors.orange,
      'Hiburan': Colors.orange,
    };

    return colorMap[name] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(12, 12, 42, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: _getColorForCategory(category.name),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/${category.icon}',
                  color: Colors.white,
                  semanticsLabel: 'Category Icon',
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              category.name,
            ),
            SizedBox(height: 8),
            Text(
              currencyFormat.format(category.amount.toInt()),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final String? title;

  TransactionList({required this.transactions, this.title});

  // Function to determine SVG asset path and color based on description
  Widget _getIconForDescription(String description) {
    final iconData = {
      'Ayam Geprek': {
        'path': 'assets/pizza_vector.svg',
        'color': Colors.yellow, // Example color
      },
      'Gojek': {
        'path': 'assets/hadiah_vector.svg',
        'color': Colors.purple, // Example color
      },
      'Paket Data': {
        'path': 'assets/makanan_vector.svg',
        'color': Colors.blue, // Example color
      },
      // Add more mappings as needed
    };

    final iconInfo = iconData[description] ??
        {
          'path': 'assets/icons/default.svg',
          'color': Colors.grey, // Default color
        };

    return SvgPicture.asset(
      iconInfo['path'] as String,
      color: iconInfo['color'] as Color, // Set icon color based on description
      width: 24, // Adjust width as needed
      height: 24, // Adjust height as needed
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
          child: ListTile(
            leading: _getIconForDescription(transaction.description),
            title: Text(
              transaction.description,
              style: TextStyle(fontSize: 14),
            ),
            trailing: Text(
              currencyFormat.format(transaction.amount.toInt()),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
