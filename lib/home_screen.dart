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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50), // Add space from the top of the screen
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInitial) {
                  return UserIntroduction(username: null);
                } else if (state is UserLoaded) {
                  return UserIntroduction(username: state.user.username);
                } else if (state is UserError) {
                  return UserIntroduction(username: 'Error: ${state.message}');
                } else {
                  return UserIntroduction(username: null);
                }
              },
            ),
            SizedBox(height: 20),
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseInitial) {
                  return ExpenseSummary(dailyExpense: 0.0, monthlyExpense: 0.0);
                } else if (state is ExpenseLoaded) {
                  return ExpenseSummary(
                    dailyExpense: state.dailyExpense,
                    monthlyExpense: state.monthlyExpense,
                  );
                } else if (state is ExpenseError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return ExpenseSummary(dailyExpense: 0.0, monthlyExpense: 0.0);
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              "Pengeluaran berdasarkan kategori",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryInitial) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CategoryLoaded) {
                  return CategoryList(categories: state.categories);
                } else if (state is CategoryError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionInitial) {
                    return Center(child: CircularProgressIndicator());
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

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hari ini",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          TransactionList(transactions: todayTransactions),
                          if (yesterdayTransactions.isNotEmpty) ...[
                            Text(
                              "Kemarin",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TransactionList(
                                transactions: yesterdayTransactions),
                          ],
                        ],
                      ),
                    );
                  } else if (state is TransactionError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddExpenseScreen(),
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
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
                        style: Theme.of(context).textTheme.headline6,
                        children: [
                          TextSpan(
                            text: username,
                            style: TextStyle(
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
  final double dailyExpense;
  final double monthlyExpense;

  ExpenseSummary({required this.dailyExpense, required this.monthlyExpense});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ExpenseCard(
          title: "Pengeluaran\nhari ini",
          amount: dailyExpense,
          color: Colors.blue, // Color for daily expense
        ),
        SizedBox(width: 20), // Add space between the cards
        ExpenseCard(
          title: "Pengeluaranmu\nbulan ini",
          amount: monthlyExpense,
          color: Colors.teal, // Color for monthly expense
        ),
      ],
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;

  ExpenseCard({required this.title, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
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
          return CategoryCard(category: category);
        }).toList(),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({required this.category});

  // Function to determine color based on category name
  Color _getColorForCategory(String name) {
    final colorMap = {
      'Makanan': Colors.yellow,
      'Internet': Colors.blue,
      'Transportasi': Colors.purple,
      'Hiburan': Colors.orange,
      'Lainnya': Colors.purple,
    };

    // Return a color or a default color if the name is not found
    return colorMap[name] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0, // Remove default shadow if needed
        child: Column(
          children: [
            Container(
              width: 50, // Adjust width as needed
              height: 50, // Adjust height as needed
              decoration: BoxDecoration(
                color: _getColorForCategory(
                    category.name), // Get color based on name
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    blurRadius: 4.0, // Shadow blur radius
                    spreadRadius: 2.0, // Shadow spread radius
                    offset: Offset(0, 2), // Shadow offset
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/${category.icon}', // Your SVG file path
                  color: Colors.white, // SVG icon color
                  semanticsLabel: 'Category Icon',
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(category.name),
            Text("Rp. ${category.amount}"),
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(transactions[index].description),
          trailing: Text("Rp. ${transactions[index].amount}"),
        );
      },
    );
  }
}
