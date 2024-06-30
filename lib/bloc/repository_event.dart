import 'package:equatable/equatable.dart';

abstract class RepositoryEvent extends Equatable {
  const RepositoryEvent();

  @override
  List<Object> get props => [];
}

class FetchRepositories extends RepositoryEvent {}

class FetchMoreRepositories extends RepositoryEvent {
  final String cursor;

  const FetchMoreRepositories(this.cursor);

  @override
  List<Object> get props => [cursor];
}

class FilterRepositories extends RepositoryEvent {
  final String language;

  const FilterRepositories(this.language);

  @override
  List<Object> get props => [language];
}
