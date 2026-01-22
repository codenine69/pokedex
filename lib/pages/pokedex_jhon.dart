import 'package:flutter/material.dart';
import 'package:pokedexg14/apiservice/api_service.dart'; 
import 'package:pokedexg14/models/pokemon_model_list.dart';

void main() => runApp(const PokedexJhonApp());

class PokedexJhonApp extends StatelessWidget {
  const PokedexJhonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const PokemonListPage(),
    );
  }
}

// Función coleres según tipo de Pokémon
Color getPokemonColor(String type) {
  switch (type.toLowerCase()) {
    case 'fire': return Colors.orangeAccent;
    case 'water': return Colors.blueAccent;
    case 'grass': return Colors.greenAccent;
    case 'electric': return Colors.yellow;
    case 'poison': return Colors.purpleAccent;
    case 'psychic': return Colors.pinkAccent;
    case 'rock': return Colors.brown;
    case 'ground': return Colors.orange;
    case 'ice': return Colors.cyanAccent;
    case 'bug': return Colors.lightGreen;
    default: return Colors.blueGrey;
  }
}

 
    // LIST PAGE
 
class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Pokédex', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<PokemonModelList?>(
        future: apiService.getPokemonList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final pokemons = snapshot.data!.pokemon;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemCount: pokemons.length,
            itemBuilder: (_, index) {
              final p = pokemons[index];
              // Usamos el primer tipo para el color de la tarjeta
              final color = getPokemonColor(p.type.first.toString().split('.').last);

              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PokemonDetailPage(pokemon: p))),
                child: Card(
                  color: color.withOpacity(0.2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(tag: p.id, child: Image.network(p.img, height: 100)),
                      const SizedBox(height: 10),
                      Text(
                        p.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
 
    // DETAIL PAGE 

class PokemonDetailPage extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final mainColor = getPokemonColor(pokemon.type.first.toString().split('.').last);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0,
          title: Text(pokemon.name, style: const TextStyle(color: Colors.white)),
        ),
        body: Column(
          children: [
            // PARTE SUPERIOR DINÁMICA CON COLOR
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Hero(
                    tag: pokemon.id,
                    child: Image.network(pokemon.img, height: 200, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    label: Text("#${pokemon.num}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.black26,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // TAB
            TabBar(
              labelColor: mainColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: mainColor,
              tabs: const [
                Tab(child: Text("About", style: TextStyle(fontWeight: FontWeight.bold))),
                Tab(child: Text("Evolution", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            // CONTENIDO
            Expanded(
              child: TabBarView(
                children: [
                  AboutTab(pokemon: pokemon),
                  EvolutionTab(pokemon: pokemon, accentColor: mainColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
    // ABOUT TAB 

class AboutTab extends StatelessWidget {
  final Pokemon pokemon;
  const AboutTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _infoRow('Height', pokemon.height),
        _infoRow('Weight', pokemon.weight),
        _infoRow('Candy', pokemon.candy), 
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text('Weaknesses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        Wrap(
          spacing: 8,
          children: (pokemon.weaknesses ?? []).map((w) { 
            return Chip(
              label: Text(w.toString().split('.').last, style: const TextStyle(color: Color.fromARGB(255, 248, 248, 248))),
              backgroundColor: Colors.red,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
 
    // EVOLUTION TAB 
    
class EvolutionTab extends StatelessWidget {
  final Pokemon pokemon;
  final Color accentColor;
  const EvolutionTab({super.key, required this.pokemon, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final evos = pokemon.nextEvolution ?? [];

    if (evos.isEmpty) {
      return Center(child: Text('Este Pokémon ha alcanzado su forma final!.', style: TextStyle(color: accentColor)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: evos.length,
      itemBuilder: (context, index) {
        final evo = evos[index];
        final evoImageUrl = "https://www.serebii.net/pokemongo/pokemon/${evo.num}.png";

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: accentColor.withOpacity(0.1), shape: BoxShape.circle),
                  child: Image.network(evoImageUrl, height: 120, width: 120),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(evo.name ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("#${evo.num}", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, color: accentColor, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}