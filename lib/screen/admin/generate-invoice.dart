import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../component/Invoice.dart';
import '../../component/defaultAppBar.dart';
import '../../component/pdf_invoice.dart';
import '../../constant/constant.dart';

class GenerateInvoice extends StatefulWidget {
  const GenerateInvoice({Key? key}) : super(key: key);

  @override
  State<GenerateInvoice> createState() => _GenerateInvoiceState();
}

class _GenerateInvoiceState extends State<GenerateInvoice> {
  List payemntData = [];
  var user_id;

  Future<List> getUserData() async {
    SharedPreferences pred = await SharedPreferences.getInstance();
    setState(() {
      user_id = pred.getString("id");
    });

    try {
      var res = await http.post(Uri.parse(myurl), body: {
        "request": "FETCH PAYMENT",
      });

      setState(() {
        payemntData = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
    return payemntData;
  }

  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateToday = new DateTime.now();
    String date = dateToday.toString().substring(0, 10);

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kDefault,
        title: DefaultAppBar(
          txt: "Payment side",
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                "img/status.png",
              ),
              width: 200,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Transaction Successfull",
              style: TextStyle(fontSize: 20.0, fontFamily: "RobotoBold"),
            ),
            Text(date,
                style: TextStyle(
                  fontSize: 16.0,
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: payemntData.isEmpty
                  ? CircularProgressIndicator(
                      color: kDefault,
                    )
                  : Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transaction details",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "RobotoBold"),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Transaction No"),
                              Text(
                                payemntData[0]['tran_id'],
                                style: TextStyle(
                                    fontSize: 14.0, fontFamily: "RobotoBold"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Dates"),
                              Text(
                                payemntData[0]['dates'],
                                style: TextStyle(
                                    fontSize: 14.0, fontFamily: "RobotoBold"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Transaction amount"),
                              Text(
                                payemntData[0]['amount'],
                                style: TextStyle(
                                    fontSize: 14.0, fontFamily: "RobotoBold"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: kBlue,
              ),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(side: BorderSide.none),
                onPressed: () async {
                  final PdfDocument document = PdfDocument();
                  final invoice = Invoice(
                    student: Student(
                        date: payemntData[0]['dates'],
                        name: "Kamalu yahaya".toUpperCase(),
                        course: "",
                        transaction: payemntData[0]['tran_id'],
                        level: "HND"),
                  );
                  // createPdf();
                  await PdfInvoicApi.generate(invoice);
                  // PdfApi.openFile(pdfile);
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: ((context) => Receipt())));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.picture_as_pdf_outlined,
                      color: kWhite,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "GENERATE RECIEPT",
                      style: TextStyle(
                        color: kWhite,
                        fontFamily: "RobotoBold",
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
