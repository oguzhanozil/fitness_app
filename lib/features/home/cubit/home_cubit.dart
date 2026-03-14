import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void selectTab(int index) {
    final shouldRefreshHistory = index == 1;
    emit(
      state.copyWith(
        currentIndex: index,
        historyRefreshToken: shouldRefreshHistory
            ? state.historyRefreshToken + 1
            : state.historyRefreshToken,
      ),
    );
  }

  void refreshHistory() {
    emit(
      state.copyWith(historyRefreshToken: state.historyRefreshToken + 1),
    );
  }
}
