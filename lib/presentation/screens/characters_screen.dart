import 'package:breaking_bad/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bad/constants/my_colors.dart';
import 'package:breaking_bad/data/models/character.dart';
import 'package:breaking_bad/presentation/wedgits/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  late List<Character> searchedCharacters = [];
  bool _isSearch = false;
  final TextEditingController searchController = TextEditingController();

  Widget buildSearch() {
    return TextField(
      controller: searchController,
      cursorColor: MyColors.myGrey,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Find a Character...',
        hintStyle: TextStyle(fontSize: 18, color: MyColors.myGrey),
      ),
      style: const TextStyle(fontSize: 18, color: MyColors.myGrey),
      onChanged: (searchedValue) {
        search(searchedValue);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      appBar: AppBar(
        leading: _isSearch
            ? BackButton(
                color: MyColors.myGrey,
                onPressed: () {
                  Navigator.pop(context);
                  _clearSearch();
                },
              )
            : null,
        backgroundColor: MyColors.myYellow,
        title: _isSearch
            ? buildSearch()
            : const Text(
                'Characters',
                style: TextStyle(
                    color: MyColors.myGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
        actions: _buildActions(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return buildBody();
          } else {
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Image(
                      image: AssetImage(
                        'assets/images/no_connection.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('No Internet Connection'),
                  ],
                ),
              ),
            );
          }
        },
        child: const Center(child: CircularProgressIndicator(),),
      ),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearch) {
      return [
        IconButton(
            onPressed: () {
              _clearSearch();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: MyColors.myGrey,
            )),
      ];
    } else {
      return [
        IconButton(
            onPressed: () {
              _startSearch();
            },
            icon: const Icon(
              Icons.search,
              color: MyColors.myGrey,
            )),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearch));
    _isSearch = true;
  }

  void _stopSearch() {
    _clearSearch;
    setState(() {
      _isSearch = false;
    });
  }

  void _clearSearch() {
    setState(() {
      searchController.clear();
    });
  }

  Widget buildBody() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is GetCharactersSuccess) {
          allCharacters = state.characters;
          if (_isSearch && searchedCharacters.isNotEmpty) {
            return buildCharactersList(searchedCharacters);
          }
          return buildCharactersList(allCharacters);
        } else {
          return Container(
            color: MyColors.myGrey,
            child: const Center(
              child: CircularProgressIndicator(
                color: MyColors.myYellow,
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildCharactersList(List<Character> characters) {
    return SingleChildScrollView(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => CharacterItem(characters[index]),
        itemCount: characters.length,
      ),
    );
  }

  void search(String searchedValue) {
    searchedCharacters = allCharacters.where((character) {
      return character.name.toLowerCase().startsWith(searchedValue);
    }).toList();
    setState(() {
      // todo in cubit
    });
  }
}
