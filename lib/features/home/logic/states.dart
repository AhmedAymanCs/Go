import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final String error;
  const HomeState({this.status = HomeStatus.initial, this.error = ''});
  HomeState copyWith({HomeStatus? status, String? error}) {
    return HomeState(status: status ?? this.status, error: error ?? this.error);
  }

  @override
  List<Object?> get props => [status, error];
}
