
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/layout/news_app/cubit/cubit.dart';
import 'package:news/layout/news_app/cubit/states.dart';
import 'package:news/shared/components/components.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  var _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      listener: (context,state){},
      builder: (context,state){
        var list = NewsCubit.get(context).search;
        return  Scaffold(
          appBar: AppBar(),
          body: Form(
            key: _key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller : searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0),),
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'search most not be empty';
                      }
                      return null;
                    },
                    maxLength: 25,
                    onChanged: (value){
                     NewsCubit.get(context).getSearch(value);
                    },

                  ),
                ),
                Expanded(child: articleBuilder(list,list.length ,context,isSearch: true)),
              ],
            ),
          ),
        );
      },

    );
  }
}
