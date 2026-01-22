import 'dart:convert';

import 'package:pokedexg14/models/pokemon_model_list.dart';
import 'package:http/http.dart' as http;

class ApiService {
  String urlBase =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json?fbclid=IwZXh0bgNhZW0CMTAAAR1NvRhYdIz7HvFIbjRRZryG-5j4516YvSxaCzm4aH6RynNyp9tLZLTGz9Q_aem_OC7UyN2S8ri_YUImzNS2_g";

  Future<PokemonModelList?> getPokemonList() async {
    Uri url = Uri.parse(urlBase);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      PokemonModelList pokemonModelList = PokemonModelList.fromJson(data);
      print(pokemonModelList.pokemon[0].name);
      return pokemonModelList;
    }
    return null;
  }
}
