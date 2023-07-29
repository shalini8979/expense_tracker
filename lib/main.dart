// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

  class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: expensePage1(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class  expensePage1 extends StatefulWidget {
  @override
   expensePage1State createState() => expensePage1State();
}

class expensePage1State extends State<expensePage1> {
  late TextEditingController _expenseController ;
  late TextEditingController _amountController ;
  List<String> _expenses = [];
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _expenseController = TextEditingController();
    _amountController = TextEditingController();
    _loadData();
  }

  @override

  void dispose() {
    _expenseController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    setState(() {
      _expenses = prefs.getStringList('expenses') ?? [];
      _totalAmount = prefs.getDouble('totalAmount') ?? 0.0;
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('expenses', _expenses);
    await prefs.setDouble('totalAmount', _totalAmount);
  }

  void _addExpense() {
    setState(() {
      String newExpense = _expenseController.text;
      String amountText = _amountController.text;
      double amount = double.tryParse(amountText) ?? 0.0;
      if (newExpense.isNotEmpty && amount > 0) {
        _expenses.add('$newExpense                $amount');
        _totalAmount += amount;
        _expenseController.clear();
        _amountController.clear();
        _saveData();
      }
    });
  }

  void _clearExpenses() {
    setState(() {
      _expenses.clear();
      _totalAmount = 0.0;
      _saveData();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title:Text("Expense Tracker ",style: TextStyle(color:Colors.white )) ,
       ),


       body: Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),

       child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(height: 20.0,),

              Center(child: Column(

              children: [
                Text("This Month Spend ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 20.0)),
                totalexpencetext('$_totalAmount'),
              ],
            ),),



          SizedBox(height: 20.0,),
          
          Text("Add New Expenses ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700, fontSize: 15.0)),

          SizedBox(height: 20.0,),

          TextField(
              controller: _expenseController,
              decoration: const InputDecoration(
                labelText: 'Expense ',
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.add_box_rounded,color: Colors.amber,
                ),
              ),
            ),
           SizedBox(height: 20.0,),
          
          Text("Add Amount  ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700, fontSize: 15.0)),

          SizedBox(height: 20.0,),

          TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount ',
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.add_box_rounded,color: Colors.amber,
                ),
              ),
            ),

            SizedBox(height: 20,),

            Row(children: [
              Padding(padding: EdgeInsets.only(right: 2.0)),
              ElevatedButton(onPressed: _addExpense,
                    child: const Text('Add Expense'),
                  ),
                  SizedBox(width: 20,),
                  Padding(padding: EdgeInsets.only(right: 90.0)),
              ElevatedButton(onPressed: _clearExpenses,
                    child: const Text('Clear Expense'),
                  ),

            ],),

            SizedBox(height: 30,),

            Text("______________________________________________________",style: TextStyle(backgroundColor: Colors.amber,fontWeight: FontWeight.w200),),

            SizedBox(height: 20.0,),

            Row(children: [

            Text("This Month Expense ",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),],),
            SizedBox(height: 40.0,),

               Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  return expensecontainer(_expenses[index]);
                },
              ),
            ),
        ],   
          ),
       ),
       
       );
  
    }
}


Widget expensecontainer(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Container(
        height: 60,
        width: 300,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        )),
  );
}


Widget totalexpencetext(String text) {
  return Text(
    "₹" + text,
    style: GoogleFonts.poppins(
      fontSize: 50,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  );
}























































