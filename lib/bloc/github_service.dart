import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/repository.dart';

class GitHubService {
  final String token;

  GitHubService(this.token);

  Future<Map<String, dynamic>> fetchRepositories({String? after}) async {
    final HttpLink httpLink = HttpLink(
      'https://api.github.com/graphql',
      defaultHeaders: {
        'Authorization': 'Bearer $token',
      },
    );

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: httpLink,
    );

    final String query = '''
      query(\$after: String) {
        search(query: "stars:>50000", type: REPOSITORY, first: 10, after: \$after) {
          edges {
            node {
              ... on Repository {
                name
                description
                url
                primaryLanguage {
                  name
                }
              }
            }
          }
          pageInfo {
            endCursor
            hasNextPage
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: {
        'after': after,
      },
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<dynamic> repositoriesJson = result.data!['search']['edges'];
    final List<Repository> repositories = repositoriesJson
        .map((edge) => Repository.fromJson(edge['node']))
        .toList();
    final String? endCursor = result.data!['search']['pageInfo']['endCursor'];
    final bool hasNextPage = result.data!['search']['pageInfo']['hasNextPage'];

    return {
      'repositories': repositories,
      'endCursor': endCursor,
      'hasNextPage': hasNextPage,
    };
  }
}
