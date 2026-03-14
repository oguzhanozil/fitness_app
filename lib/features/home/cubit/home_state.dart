import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState({
    this.currentIndex = 0,
    this.historyRefreshToken = 0,
  });

  final int currentIndex;
  final int historyRefreshToken;

  HomeState copyWith({
    int? currentIndex,
    int? historyRefreshToken,
  }) {
    return HomeState(
      currentIndex: currentIndex ?? this.currentIndex,
      historyRefreshToken: historyRefreshToken ?? this.historyRefreshToken,
    );
  }

  @override
  List<Object?> get props => [currentIndex, historyRefreshToken];
}
