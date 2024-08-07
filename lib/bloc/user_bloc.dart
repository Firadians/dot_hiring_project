import 'package:bloc/bloc.dart';
import '../models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dot_project_app/database.dart'; // Import your database helper

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final DatabaseHelper _databaseHelper;

  UserBloc(this._databaseHelper) : super(UserInitial()) {
    on<FetchUsername>(_onFetchUsername);
  }

  Future<void> _onFetchUsername(
      FetchUsername event, Emitter<UserState> emit) async {
    try {
      final username = await _databaseHelper.fetchUsername();
      if (username != null) {
        emit(UserLoaded(user: User(username: username)));
      } else {
        emit(UserError(message: "No username found"));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
