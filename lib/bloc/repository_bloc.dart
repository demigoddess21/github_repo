import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo/bloc/github_service.dart';
import 'package:github_repo/models/repository.dart';

import 'repository_event.dart';
import 'repository_state.dart';

class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState> {
  final GitHubService gitHubService;
  List<Repository> _allRepositories = [];
  RepositoryBloc(this.gitHubService) : super(RepositoryInitial()) {
    on<FetchRepositories>((event, emit) async {
      emit(RepositoryLoading());

      try {
        final result = await gitHubService.fetchRepositories();
        _allRepositories = result['repositories'];
        final languages =
            _allRepositories.map((repo) => repo.language).toSet().toList();
        emit(RepositoryLoaded(_allRepositories, languages, result['endCursor'],
            result['hasNextPage']));
      } catch (e) {
        emit(RepositoryError('Error fetching repositories: ${e.toString()}'));
      }
    });

    on<FetchMoreRepositories>((event, emit) async {
      if (state is RepositoryLoaded) {
        final currentState = state as RepositoryLoaded;
        emit(RepositoryLoadingMore(
          currentState.repositories,
          currentState.languages,
          currentState.endCursor,
          currentState.hasNextPage,
        ));

        try {
          final result =
              await gitHubService.fetchRepositories(after: event.cursor);
          final newRepositories = result['repositories'];
          _allRepositories.addAll(newRepositories);
          final languages =
              _allRepositories.map((repo) => repo.language).toSet().toList();
          emit(RepositoryLoaded(
            _allRepositories,
            languages,
            result['endCursor'],
            result['hasNextPage'],
          ));
        } catch (e) {
          emit(RepositoryError(
              'Error fetching more repositories: ${e.toString()}'));
        }
      }
    });

    on<FilterRepositories>((event, emit) {
      try {
        final filteredRepositories = _allRepositories
            .where((repo) =>
                repo.language.toLowerCase() == event.language.toLowerCase())
            .toList();
        final languages =
            _allRepositories.map((repo) => repo.language).toSet().toList();
        emit(RepositoryFiltered(filteredRepositories, languages));
      } catch (e) {
        emit(RepositoryError('Error filtering repositories: ${e.toString()}'));
      }
    });
  }
}
