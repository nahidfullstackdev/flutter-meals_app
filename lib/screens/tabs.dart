import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals/provider/favourites_provider.dart';
import 'package:meals/provider/filters_provider.dart';
import 'package:meals/screens/category_screen.dart';
import 'package:meals/screens/filter_screen.dart';
import 'package:meals/screens/meals_screen.dart';
import 'package:meals/widgets/main_drawer.dart';

const kinitialFilter = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends ConsumerState<TabScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

//..Function to Favourites the meal...
//...show snackbar when favourite button pressed...

  //.. Managed by Riverpod....../

  // void _showSnackbarinFav(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //     ),
  //   );
  // }

  // void togglefavourites(Meal meal) {
  //   final isExisting = favouriteMeals.contains(meal);

  //   if (isExisting) {
  //     setState(() {
  //       favouriteMeals.remove(meal);
  //       _showSnackbarinFav('Meal is removed from Favourite List');
  //     });
  //   } else {
  //     setState(() {
  //       favouriteMeals.add(meal);
  //       _showSnackbarinFav('Your Favourite meal is Listed');
  //     });
  //   }
  // }
  //............................................................//

  //..Drawer item pressing function..
  void _setScreen(String identifier) async {
    Navigator.pop(context);
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(MaterialPageRoute(
        builder: (context) => const FilterScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final availablemeals = ref.watch(filterMealsProvider);

    Widget activePage = CategoryScreen(
      availableMeals: availablemeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favouriteMeals = ref.watch(favouriteMealsProvider);
      activePage = MealsScreen(
        meals: favouriteMeals,
      );
      activePageTitle = 'Filters';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelect: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _selectPage(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.set_meal),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favourites',
            ),
          ]),
    );
  }
}
