import 'package:equatable/equatable.dart';
import '../models/repository.dart';

abstract class RepositoryState extends Equatable {
  const RepositoryState();

  @override
  List<Object> get props => [];
}

class RepositoryInitial extends RepositoryState {}

class RepositoryLoading extends RepositoryState {}

class RepositoryLoaded extends RepositoryState {
  final List<Repository> repositories;
  final List<String> languages;
  final String? endCursor;
  final bool hasNextPage;

  const RepositoryLoaded(
      this.repositories, this.languages, this.endCursor, this.hasNextPage);

  @override
  List<Object> get props => [repositories, languages, endCursor!, hasNextPage];
}

class RepositoryLoadingMore extends RepositoryState {
  final List<Repository> repositories;
  final List<String> languages;
  final String? endCursor;
  final bool hasNextPage;

  const RepositoryLoadingMore(
      this.repositories, this.languages, this.endCursor, this.hasNextPage);

  @override
  List<Object> get props => [repositories, languages, endCursor!, hasNextPage];
}

class RepositoryFiltered extends RepositoryState {
  final List<Repository> repositories;
  final List<String> languages;

  const RepositoryFiltered(this.repositories, this.languages);

  @override
  List<Object> get props => [repositories, languages];
}

class RepositoryError extends RepositoryState {
  final String message;

  const RepositoryError(this.message);

  @override
  List<Object> get props => [message];
}
