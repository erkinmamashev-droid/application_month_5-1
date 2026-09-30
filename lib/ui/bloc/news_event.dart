import 'package:equatable/equatable.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class GetEverythingEvent extends NewsEvent {
  const GetEverythingEvent();
}

class LoadMoreNewsEvent extends NewsEvent {
  const LoadMoreNewsEvent();
}
