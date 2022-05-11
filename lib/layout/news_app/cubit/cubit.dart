import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/layout/news_app/cubit/states.dart';
import 'package:news/modules/business/business_screen.dart';
import 'package:news/modules/science/science_screen.dart';
import 'package:news/modules/sports/sports_screen.dart';
import 'package:news/network/local/cache_helper.dart';
import 'package:news/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  //هون لازم نستدعي الكونستركتور حتى يبدا العمل بشكل صحيحي وسليم ونعطيه الabstract class   وهمي احنا انشئناه في صفحة ال states
  NewsCubit() : super(NewsInitialState());

  //هون تقوم بارجاع صلاحية بشكل سريع وبسيط بدل من كل مره نقوم باستدعائها في كل class
  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
    BottomNavigationBarItem(icon: Icon(Icons.sports_baseball), label: 'Sports'),
    BottomNavigationBarItem(
        icon: Icon(Icons.science_outlined), label: 'Science'),
    //BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];
  dynamic item = {
    "author": "Michelle Toh, CNN Business",
    "title":
        "Bitcoin, dogecoin and ethereum are suddenly having another great week - CNN",
    "description":
        "Cryptocurrencies rallied Monday, just a week after they were hit by a major sell-off.",
    "url":
        "https://www.cnn.com/2021/07/26/investing/bitcoin-price-dogecoin-ethereum-intl-hnk/index.html",
    "urlToImage":
        "https://cdn.cnn.com/cnnnext/dam/assets/210725225614-bitcoin-illustration-0725-super-tease.jpg",
    "publishedAt": "2021-07-26T09:22:00Z",
  };
  List<dynamic> business = [];
  List<dynamic> sports = [];
  List<dynamic> science = [];
  List<dynamic> search = [];
  bool isDark = false;

  void changeThemeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(NewsChangeThemModeState());
    } else {
      isDark = !isDark;
      CacheHelper.setBoolean(key: 'isDark', value: isDark).then((value) {
        print('change theme mode done');
        emit(NewsChangeThemModeState());
      });
    }
  }

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 1) {
      getSports();
    }
    if (index == 2) {
      getScience();
    }
    emit(NewsBottomNavState());
  }

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());
    if (business.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'us',
          'category': 'business',
          'apiKey': '65f7f556ec76449fa7dc7c0069f040ca'
        },
      ).then((value) {
        business = value.data['articles'];
        emit(NewsGetBusinessSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetBusinessErrorState(error.toString()));
      });
    } else {
      emit(NewsGetBusinessSuccessState());
    }
    // business.clear();
    // business.add(item);
    print(business);
    emit(NewsGetBusinessSuccessState());
  }

  void getSports() {
    emit(NewsGetSportsLoadingState());
    if (sports.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'us',
          'category': 'sports',
          'apiKey': '65f7f556ec76449fa7dc7c0069f040ca'
        },
      ).then((value) {
        sports = value.data['articles'];
        emit(NewsGetSportsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    } else {
      emit(NewsGetSportsSuccessState());
    }
    // sports.clear();
    // sports.add(item);
    emit(NewsGetSportsSuccessState());
  }

  void getScience() {
    emit(NewsGetScienceLoadingState());
    if (science.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'us',
          'category': 'science',
          'apiKey': '65f7f556ec76449fa7dc7c0069f040ca'
        },
      ).then((value) {
        science = value.data['articles'];
        emit(NewsGetScienceSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    } else {
      emit(NewsGetScienceSuccessState());
    }
    // science.clear();
    // science.add(item);
    emit(NewsGetScienceSuccessState());
  }

  void getSearch(String value) {
    emit(NewsGetSearchLoadingState());
    DioHelper.getData(
      url: 'v2/everything',
      query: {'q': '$value', 'apiKey': '65f7f556ec76449fa7dc7c0069f040ca'},
    ).then((value) {
      search = value.data['articles'];
      emit(NewsGetScienceSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }
}
