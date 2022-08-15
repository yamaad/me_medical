import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_medical_app/screens/dashboard/dashboard.dart';
import 'package:me_medical_app/screens/profile_pages/view_profile.dart';
import 'package:me_medical_app/screens/inventory/inventory.dart';
import 'package:me_medical_app/screens/checkup_pages/patient_checkup.dart';
import 'package:me_medical_app/screens/patients_info/patient_list.dart';
import 'package:me_medical_app/services/auth.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final Stream<QuerySnapshot> _itemsStream = FirebaseFirestore.instance
      .collection("items")
      .doc(AuthService().getCurrentUID())
      .collection('itemInfo')
      .snapshots();
  int lowStock = 0;

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
//Screens for each nav items.
  List<Widget> _navScreens() {
    return [
      Dashboard(
        persistentTabController: _controller,
      ),
      PatientCheckUp(),
      PatientListPage(),
      InventoryPage(),
      ViewProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.personal_injury_sharp),
        title: ("Check Up"),
        activeColorPrimary: CupertinoColors.activeGreen,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.sick),
        title: ("Patients"),
        activeColorPrimary: CupertinoColors.systemIndigo,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: StreamBuilder(
            stream: _itemsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                lowStock = 0;
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  DocumentSnapshot snap = snapshot.data!.docs[i];
                  if (snap['In Stock'] < 10) {
                    lowStock++;
                  }
                }

                if (lowStock != 0) {
                  return Stack(children: [
                    const Icon(Icons.medication),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          lowStock.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ]);
                } else {
                  return Icon(Icons.medication);
                }
              }
            }),
        title: ("Inventory"),
        activeColorPrimary: CupertinoColors.systemBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: CupertinoColors.systemIndigo,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _navScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: false,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      navBarStyle: NavBarStyle.style13,
      stateManagement: false,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
    );
  }
}


/*
class BottomNavScreen extends StatefulWidget {
  int _currentIndex = 0;

  BottomNavScreen(this._currentIndex);
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List _screens = [
    Dashboard(),
    PatientCheckUp(),
    PatientListPage(),
    InventoryPage(),
    ViewProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[widget._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget._currentIndex,
        onTap: (index) => setState(() => widget._currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 0.0,
        items: [
          Icons.home,
          Icons.insert_chart,
          Icons.sick_rounded,
          Icons.event_note,
          Icons.person
        ]
            .asMap()
            .map((key, value) => MapEntry(
                  key,
                  BottomNavigationBarItem(
                    title: Text(''),
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: widget._currentIndex == key
                            ? Colors.blue[600]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(value),
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }
}
*/