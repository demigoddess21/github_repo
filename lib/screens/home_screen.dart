import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/repository_bloc.dart';
import '../bloc/repository_event.dart';
import '../bloc/repository_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedLanguage = 'All';

  @override
  void initState() {
    super.initState();
    fetchRepo();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = context.read<RepositoryBloc>().state;
      if (state is RepositoryLoaded && state.hasNextPage) {
        context
            .read<RepositoryBloc>()
            .add(FetchMoreRepositories(state.endCursor!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Repositories'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<RepositoryBloc, RepositoryState>(
              builder: (context, state) {
                if (state is RepositoryLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is RepositoryLoaded ||
                    state is RepositoryFiltered) {
                  final languages = ['All'] +
                      (state is RepositoryLoaded
                          ? state.languages
                          : (state as RepositoryFiltered).languages);

                  return DropdownButton<String>(
                    value: _selectedLanguage,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });

                      if (_selectedLanguage == 'All') {
                        context.read<RepositoryBloc>().add(FetchRepositories());
                      } else {
                        context
                            .read<RepositoryBloc>()
                            .add(FilterRepositories(_selectedLanguage));
                      }
                    },
                    items:
                        languages.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                } else if (state is RepositoryError) {
                  return Center(
                      child: Text(state.message,
                          style: TextStyle(color: Colors.red)));
                }

                return SizedBox.shrink();
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<RepositoryBloc, RepositoryState>(
              builder: (context, state) {
                if (state is RepositoryLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is RepositoryLoaded ||
                    state is RepositoryFiltered ||
                    state is RepositoryLoadingMore) {
                  final repositories = state is RepositoryLoaded
                      ? state.repositories
                      : (state is RepositoryFiltered
                          ? state.repositories
                          : (state as RepositoryLoadingMore).repositories);
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: repositories.length +
                        (state is RepositoryLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == repositories.length) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final repo = repositories[index];
                      return Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ListTile(
                          title: Text(
                            repo.name,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          subtitle: Text(
                            '${repo.description}\nLanguage: ${repo.language}',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          trailing: Icon(
                            Icons.star,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  );
                } else if (state is RepositoryError) {
                  return Center(
                      child: Text(state.message,
                          style: TextStyle(color: Colors.red)));
                }

                return Center(
                    child: Text('Press the button to fetch repositories.'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          fetchRepo();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchRepo() {
    context.read<RepositoryBloc>().add(FetchRepositories());
  }
}
