## README for Flutter Expense Tracker App
#Introduction
This Flutter application is an expense tracker that helps users manage their daily and monthly expenses. The app is built using the Flutter framework with state management handled by the Bloc pattern and data persistence using SQFlite.

# Features
User Authentication: Simple username storage and retrieval.
Expense Management: Track daily and monthly expenses.
Category Management: Add and display expense categories.
Transaction Management: Add and view transactions with associated categories.
Screens
# Home Page
The home page provides a summary of the user's daily and monthly expenses, a list of expenses categorized by type, and a transaction list displaying today's and yesterday's transactions.

User Introduction: Displays a greeting with the username and a motivational message to track expenses.
Expense Summary: Shows daily and monthly expenses in a card format.
Category List: Horizontally scrollable list of expense categories with icons.
Transaction List: Displays today's and yesterday's transactions in a card format. Each transaction shows the description, amount, and an associated icon.
# Add New Expense (Empty Fields)
The "Tambah Pengeluaran Baru" (Add New Expense) page allows users to add a new expense with empty input fields. Users can select the category, enter the amount, and add a description.

# Add New Expense (Filled Fields)
This screen is similar to the previous one but shows how the form looks when filled out. Users can see the selected category, entered amount, and description before saving the expense.
