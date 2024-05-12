
import 'package:art_inyou/core/presentation/pages/tapbar_screens/tabbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return    const Scaffold(
      body: Column(
                    children: [
                     Expanded(child: TabBarViewScreen()),
                    //  Expanded(child: GridViewScreen()),
                    ],
                  
      ),
    );
        
        
      
      
    
  }
}
// labelwidget(labelText: 'Logout', 
//             onTap: () { 
//                final authbloc=BlocProvider.of<EmailauthBloc>(context);
//              authbloc.add(LogOutEvent());
//         //       final googleAuthCubit = context.read<GoogleauthCubit>();
//         // googleAuthCubit.logout();
              
//              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
//              }
            
//            )
