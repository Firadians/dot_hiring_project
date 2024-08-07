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
![WhatsApp Image 2024-08-07 at 10 18 33_acc3ff1d](https://github.com/user-attachments/assets/97b1a4f6-0360-469f-8ca7-03fdd28d4a23)


User Introduction: Displays a greeting with the username and a motivational message to track expenses.
Expense Summary: Shows daily and monthly expenses in a card format.
Category List: Horizontally scrollable list of expense categories with icons.
Transaction List: Displays today's and yesterday's transactions in a card format. Each transaction shows the description, amount, and an associated icon.
# Add New Expense (Empty Fields)
The "Tambah Pengeluaran Baru" (Add New Expense) page allows users to add a new expense with empty input fields. Users can select the category, enter the amount, and add a description.
![WhatsApp Image 2024-08-07 at 10 17 30_0690f631](https://github.com/user-attachments/assets/9b6abbfe-484b-437f-9fc5-2b7e0059207c)

# Add New Expense (Filled Fields)
This screen is similar to the previous one but shows how the form looks when filled out. Users can see the selected category, entered amount, and description before saving the expense.
![WhatsApp Image 2024-08-07 at 10 17 29_d62dc869](https://github.com/user-attachments/assets/abee675b-7732-453d-9025-84d2f3f75bda)

![WhatsApp Image 2024-08-07 at 10 17 29_0e7b0850](https://github.com/user-attachments/assets/68c12d9f-db7b-4f1a-8f1c-2dd76d815270)
