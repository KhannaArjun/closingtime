import 'package:closingtime/registration/sign_in.dart';
import 'package:closingtime/volunteer/data_model/volunteer_food_list_response.dart';
import 'package:closingtime/volunteer/food_history_volunteer.dart';
import 'package:closingtime/volunteer/volunteer_food_description_screen.dart';
import 'package:closingtime/volunteer/volunteer_profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:shimmer/shimmer.dart';


class VolunteerDashboard extends StatefulWidget {
  const VolunteerDashboard({Key? key}) : super(key: key);

  @override
  State<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> with TickerProviderStateMixin {
  static const appTitle = 'Volunteer Dashboard';

  List<Data> _addedFoodList = [];
  List<Data> _filteredFoodList = [];
  List<Data> _pendingFoodList = [];
  List<Data> _activeFoodList = [];

  // Tab controller
  late TabController _tabController;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize tab controller
    _tabController = TabController(length: 2, vsync: this);
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    configureNotifications(context);
    checkVersion(context);
    getUserId();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void checkVersion(context) async {
    final newVersion = NewVersion();
    newVersion.showAlertIfNecessary(context: context);
  }

  void fcmSubscribe(firebaseMessaging) {
    firebaseMessaging.subscribeToTopic(Constants.FB_FOOD_ADDED_TOPIC);
  }

  void fcmUnSubscribe(firebaseMessaging) {
    firebaseMessaging.unsubscribeFromTopic('TopicToListen');
  }

  bool isDataEmpty = false;
  bool isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Handle background messages
  }

  void configureNotifications(context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      SnackBar snackBar = SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                "New food added by donor",
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: ColorUtils.volunteerPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Refresh',
          onPressed: () {
            getUserId();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VolunteerDashboard()));
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  String _username = "";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (Navigator.of(context).userGestureInProgress) {
          return;
        }
      },
      child: MaterialApp(
        title: appTitle,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: ColorUtils.volunteerPrimary,
            primary: ColorUtils.volunteerPrimary,
            secondary: ColorUtils.volunteerSecondary,
            brightness: Brightness.light,
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        home: Scaffold(
          key: _scaffoldKey,
          backgroundColor: ColorUtils.volunteerSurface,
          appBar: AppBar(
            title: const Text(appTitle),
            backgroundColor: ColorUtils.volunteerPrimary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: ColorUtils.volunteerGradient,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'Active'),
              ],
            ),
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.search),
            //     onPressed: () => _showSearchDialog(),
            //   ),
            //   IconButton(
            //     icon: const Icon(Icons.filter_list),
            //     onPressed: () => _showFilterBottomSheet(),
            //   ),
            // ],
          ),
          body: RefreshIndicator(
            onRefresh: getUserId,
            color: ColorUtils.volunteerPrimary,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(_pendingFoodList, 0),
                _buildTabContent(_activeFoodList, 1),
              ],
            ),
          ),
          drawer: _buildModernDrawer(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => getUserId(),
            backgroundColor: ColorUtils.volunteerSecondary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            elevation: 6,
          ),
        ),
      ),
    );
  }

  Widget _buildModernDrawer() {
    return Drawer(
      child: ListView(
        children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            gradient: ColorUtils.volunteerGradient,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.volunteer_activism,
                  color: ColorUtils.volunteerPrimary,
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Hello, $_username',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        // ListTile(
        //   leading: const Icon(Icons.home),
        //   title: const Text('Dashboard'),
        //   onTap: () => Navigator.pop(context),
        // ),
        ListTile(
          leading: Icon(Icons.person, color: ColorUtils.volunteerPrimary),
          title: const Text('My Profile'),
          onTap: () {
            // Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const VolunteerProfile()));
          },
        ),
        ListTile(
          leading: Icon(Icons.history, color: ColorUtils.volunteerPrimary),
          title: const Text('History'),
          onTap: () {
            // Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const VolunteerFoodHistory()));
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: ColorUtils.volunteerError),
          title: Text('Logout', style: TextStyle(color: ColorUtils.volunteerError)),
          onTap: () {
            // Navigator.pop(context);
            _showLogoutAlertDialog();
          },
        ),
        ],
      ),
    );
  }

  Widget _buildTabContent(List<Data> list, int tabIndex) {
    if (isLoading) {
      return _buildShimmerLoading();
    }

    // If this specific tab's list is empty, show tab-specific empty state
    // (This handles both cases: no data at all, or data exists but not in this tab)
    if (list.isEmpty) {
      return _buildEmptyStateForTab(tabIndex);
    }

    // Show the food list for this tab
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildFoodList(list),
      ),
    );
  }

  Widget _buildEmptyStateForTab(int tabIndex) {
    String title;
    String message;
    IconData icon;

    if (tabIndex == 0) {
      // Pending tab
      title = 'No Pending Food';
      message = 'No available food items to collect at the moment';
      icon = Icons.pending_actions;
    } else {
      // Active tab
      title = 'No Active Tasks';
      message = 'You don\'t have any active food collection or delivery tasks';
      icon = Icons.check_circle_outline;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 120,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget getWidget() {
    if (isLoading) {
      return _buildShimmerLoading();
    }

    if (isDataEmpty) {
      return _buildEmptyState();
    } else {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildFoodList(_filteredFoodList),
        ),
      );
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 120,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No Food Available',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'List of donated foods will be shown here',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          // // const SizedBox(height: 24),
          // // FilledButton.icon(
          // //   onPressed: getUserId,
          // //   icon: const Icon(Icons.refresh),
          // //   label: const Text('Refresh'),
          // //   style: FilledButton.styleFrom(
          // //     backgroundColor: ColorUtils.primaryColor,
          // //     foregroundColor: Colors.white,
          // //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildFoodList(List<Data> list) {
    return Column(
      children: [
        _buildPromotionalCard(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: list.length,
            itemBuilder: (context, i) {
              Data addedFoodModel = list[i];
              return AnimatedContainer(
                duration: Duration(milliseconds: 300 + (i * 100)),
                child: _buildModernFoodCard(context, addedFoodModel),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionalCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            gradient: ColorUtils.volunteerAccentGradient,
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(
                Icons.celebration,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Volunteer Certificate",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Claim your volunteer hours certificate now!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernFoodCard(BuildContext context, Data addedFoodModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            var result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VolunteerFoodDescription(addedFoodModel, false),
              ),
            );
            if (result == true) {
              getUserId();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Food Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: addedFoodModel.image.isEmpty
                        ? Image.network(
                            "https://source.unsplash.com/400x400/?food",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: ColorUtils.volunteerPrimary.withOpacity(0.1),
                                child: Icon(
                                  Icons.restaurant,
                                  color: ColorUtils.volunteerPrimary,
                                  size: 40,
                                ),
                              );
                            },
                          )
                        : Image.network(
                            addedFoodModel.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: ColorUtils.volunteerPrimary.withOpacity(0.1),
                              child: Icon(
                                Icons.restaurant,
                                color: ColorUtils.volunteerPrimary,
                                size: 40,
                              ),
                            );
                          },
                        ),
                ),
                ),
                const SizedBox(width: 16),
                // Food Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        addedFoodModel.foodName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${addedFoodModel.distance} mi',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Pick up ${addedFoodModel.pickUpDate}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(addedFoodModel.status)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (addedFoodModel.status != Constants.STATUS_AVAILABLE)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 4),
                                        child: Icon(
                                          Icons.check_circle,
                                          size: 14,
                                          color: _getStatusColor(addedFoodModel.status),
                                        ),
                                      ),
                                    Text(
                                      addedFoodModel.status == Constants.waiting_for_pickup
                                          ? "Available"
                                          : addedFoodModel.status == Constants.STATUS_AVAILABLE
                                              ? "Available"
                                              : addedFoodModel.status,
                                      style: TextStyle(
                                        color: _getStatusColor(addedFoodModel.status),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (addedFoodModel.status != Constants.STATUS_AVAILABLE && 
                                  addedFoodModel.status != Constants.waiting_for_pickup)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorUtils.volunteerWarning.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          size: 12,
                                          color: ColorUtils.volunteerWarning,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Assigned',
                                          style: TextStyle(
                                            color: ColorUtils.volunteerWarning,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ColorUtils.volunteerInfo.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${addedFoodModel.quantity} servings',
                              style: const TextStyle(
                                color: ColorUtils.volunteerInfo,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case Constants.STATUS_AVAILABLE:
        return ColorUtils.volunteerSuccess; // Green - available
      case Constants.pick_up_scheduled:
        return ColorUtils.volunteerInfo; // Blue - scheduled
      case Constants.collected_food:
        return ColorUtils.volunteerAccent; // Orange/Purple - in transit
      case Constants.delivered:
        return ColorUtils.volunteerSuccess; // Green - completed
      case Constants.expired:
        return ColorUtils.volunteerError; // Red - expired
      default:
        return ColorUtils.volunteerWarning; // Amber - other
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Food'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Search by food name...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _filterFoodList();
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _filterFoodList();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Status',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...['All', 'Available', 'Picked Up', 'Expired'].map((filter) {
                return RadioListTile<String>(
                  title: Text(filter),
                  value: filter,
                  groupValue: _selectedFilter,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFilter = value!;
                      _filterFoodList();
                    });
                    Navigator.of(context).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _filterFoodList() {
    setState(() {
      // Filter by search query
      List<Data> searchFiltered = _addedFoodList.where((food) {
        final matchesSearch = food.foodName.toLowerCase()
            .contains(_searchQuery.toLowerCase());
        final matchesFilter = _selectedFilter == 'All' ||
            food.status.toLowerCase().contains(_selectedFilter.toLowerCase());
        return matchesSearch && matchesFilter;
      }).toList();

      _filteredFoodList = searchFiltered;
      
      // Separate into Pending and Active
      _pendingFoodList = searchFiltered.where((food) {
        return food.status == Constants.STATUS_AVAILABLE;
      }).toList();

      _activeFoodList = searchFiltered.where((food) {
        return food.status == Constants.pick_up_scheduled ||
               food.status == Constants.collected_food ||
               food.status == Constants.delivered;
      }).toList();
    });
  }

  File fetchImage(String encodedString) {
    Uint8List bytes = base64Decode(encodedString);
    var file = File("decodedBezkoder.png");
    file.writeAsBytesSync(bytes);
    return file;
  }

  String _userId = "";

  Future<void> getUserId() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userId = sharedPreferences.getString(Constants.user_id) ?? '';
    double userLat = sharedPreferences.getDouble(Constants.lat) ?? 0.0;
    double userLng = sharedPreferences.getDouble(Constants.lng) ?? 0.0;
    String name = sharedPreferences.getString(Constants.name) ?? "Guest";
    String servingDistance = sharedPreferences.getString(Constants.serving_distance) ?? '';

    setState(() {
      _username = name;
    });

    _userId = userId;

    volunteerFoodListApiCall(userId, userLat, userLng, servingDistance);
  }

  void volunteerFoodListApiCall(userId, userLat, userLng, servingDistance) {
    Map body = {
      // "isFoodAccepted": true,
      "volunteer_lat": userLat,
      "volunteer_lng": userLng,
      "serving_distance": servingDistance
    };

    try {
      Future<VolunteerFoodListModel> addedFoodListModel = 
          ApiService.getAvailableFoodListForVolunteer(jsonEncode(body));
      addedFoodListModel.then((value) {
        print(value);
        if (!value.error) {
          setState(() {
            _addedFoodList = value.data.reversed.toList();
            isDataEmpty = value.data.isEmpty;
            isLoading = false;
          });
          _filterFoodList(); // Update pending and active lists
          if (!isDataEmpty) {
            _fadeController.forward();
            _slideController.forward();
          }
        } else {
          setState(() {
            isLoading = false;
            isDataEmpty = true;
            _addedFoodList = [];
            _pendingFoodList = [];
            _activeFoodList = [];
          });
        }
      }).catchError((onError) {
        setState(() {
          isLoading = false;
          isDataEmpty = true;
          _addedFoodList = [];
          _pendingFoodList = [];
          _activeFoodList = [];
        });
        Constants.showToast(Constants.something_went_wrong);
      });
    } on Exception {
      Constants.showToast("Please try again");
    }
  }

  Future<void> _showLogoutAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Do you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: ColorUtils.volunteerError,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                logoutApiCall();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void logoutApiCall() {
    setState(() {
      isLoading = true;
    });

    Map body = {
      "user_id": _userId,
    };

    try {
      Future<dynamic> response = ApiService.logout(jsonEncode(body));
      response.then((value) {
        setState(() {
          isLoading = false;
        });

        if (value['message'] == Constants.success) {
          removeSharedPreferences();
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        } else {
          Constants.showToast("Please try again");
        }
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        Constants.showToast(Constants.something_went_wrong);
      });
    } on Exception {
      Constants.showToast("Please try again");
    }
  }

  void removeSharedPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    for (String key in sp.getKeys()) {
      if (key != Constants.firebase_token) {
        sp.remove(key);
      }
    }
  }
}