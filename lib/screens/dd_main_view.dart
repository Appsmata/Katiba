import 'package:flutter/material.dart';
import 'package:katiba/utils/constants.dart';
import 'package:katiba/widgets/as_search.dart';

class DdMainView extends StatefulWidget {
  const DdMainView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DdMainViewState();
}

class DdMainViewState extends State<DdMainView> {
  int _currentTabIndex = 0;
  List<String> blocks = [
    'Preamble',
    'Chapters',
    'Articles',
    'Schedules',
  ];
  @override
  Widget build(BuildContext context) {
    AsSearch searchview = AsSearch.getList();
    final _kTabPages = <Widget>[
      Center(child: searchview),
      Center(child: Icon(Icons.history, size: 64.0, color: Colors.green)),
      Center(child: Icon(Icons.star_border, size: 64.0, color: Colors.green)),
    ];
    final _kBottmonNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Search')),
      BottomNavigationBarItem(icon: Icon(Icons.history), title: Text('History')),
      BottomNavigationBarItem(icon: Icon(Icons.star), title: Text('Favourites')),
    ];

    assert(_kTabPages.length == _kBottmonNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      items: _kBottmonNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(LangStrings.appName),
      ),
      body: _kTabPages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }

  Widget gridView() {
    return GridView.count(
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(10),
      children: <Widget>[
        gridItem(0),
        gridItem(1),
        gridItem(2),
        gridItem(3),
      ],
    );
  }

  Widget gridItem(index) {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          //setSearchingLetter(letters[index]);
        },
        child: Card(
          elevation: 5,
          child: Hero(
            tag: blocks[index],
            child: Container(
              padding: const EdgeInsets.all(2),
              child: Center(
                child: Text(
                  blocks[index],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
