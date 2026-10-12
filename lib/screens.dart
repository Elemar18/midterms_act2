
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<Country>> countriesFuture;

  @override
  void initState() {
    super.initState();
    countriesFuture = ApiService.fetchCountries();
  }

  void retry() {
    setState(() {
      countriesFuture = ApiService.fetchCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Country>>(
      future: countriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 50),
                  const SizedBox(height: 12),
                  Text(
                    'Could not load countries.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: retry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final countries = snapshot.data ?? [];

        if (countries.isEmpty) {
          return const Center(
            child: Text('No countries to display.'),
          );
        }

        return ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, index) {
            final country = countries[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.public),
                ),
                title: Text(country.name),
                subtitle: Text(
                  'Capital: ${country.capital}\n'
                  'Region: ${country.region}',
                ),
                trailing: Text(
                  country.population.toString(),
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}


class BeltScreen extends StatefulWidget {
  const BeltScreen({super.key});

  @override
  State<BeltScreen> createState() => _BeltScreenState();
}

class _BeltScreenState extends State<BeltScreen> {
  late final Stream<PersonUpdate> peopleUpdates;

  @override
  void initState() {
    super.initState();
    peopleUpdates = ApiService.peopleStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PersonUpdate>(
      stream: peopleUpdates,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('Waiting for the first update...'),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Stream error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('Waiting for data...'),
          );
        }

        final update = snapshot.data!;

        if (update.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Update failed: ${update.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The app will try again in 5 seconds.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final people = update.people ?? [];

        if (people.isEmpty) {
          return const Center(
            child: Text('No people received.'),
          );
        }

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'New random people every 5 seconds',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: people.length,
                itemBuilder: (context, index) {
                  final person = people[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: person.picture.isNotEmpty
                            ? NetworkImage(person.picture)
                            : null,
                        child: person.picture.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(person.name),
                      subtitle: Text(
                        '${person.email}\n'
                        '${person.city}, ${person.country}',
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
