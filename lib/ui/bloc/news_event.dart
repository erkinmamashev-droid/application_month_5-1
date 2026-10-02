import 'package:equatable/equatable.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class GetEverythingEvent extends NewsEvent {
  const GetEverythingEvent({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

class LoadMoreNewsEvent extends NewsEvent {
  const LoadMoreNewsEvent();
}
