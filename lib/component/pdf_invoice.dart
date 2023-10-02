import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:evaccinations/component/Invoice.dart';
import 'package:evaccinations/component/pdfApi.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfInvoicApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
          build: (context) => [
                //  g = pdf.getGraphics();
                buildTitle(invoice),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "HOSPITAL",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                //  pdf.graphics.drawImage(PdfBitmap(await _readImgaData('nacoss.png')),
                // Rect.fromLTWH(150, 50, 200, 200)),
                SizedBox(height: 30),
                Text(
                  "Kangiwa Medical Centre",
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(20),
                    width: 500,
                    height: 420,
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 1,
                    )),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transaction details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Transaction No",
                                style: TextStyle(
                                  fontSize: 22.0,
                                ),
                              ),
                              Text(
                                invoice.student.transaction,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Payment date",
                                style: TextStyle(
                                  fontSize: 22.0,
                                ),
                              ),
                              Text(
                                invoice.student.date,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Transaction amount",
                                style: TextStyle(
                                  fontSize: 22.0,
                                ),
                              ),
                              Text(
                                "₦550".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Payment Status",
                                style: TextStyle(
                                  fontSize: 22.0,
                                ),
                              ),
                              Text(
                                "Success",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ])),
                SizedBox(height: 50),
                Text("Design @AKSoft Cafe, Kaduna Polytechnic",
                    textAlign: TextAlign.center),
              ]),
    );

    return PdfApi.saveDocument(
        name: "Hospital | Reciept Receipt.pdf", pdf: pdf);
  }

  static Widget buildTitle(Invoice invoice) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kaduna Polytechnic",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            Text("KANGIWA HOSPITAL PAYMENT RECIEPT",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 0.0 * PdfPageFormat.cm),
          ]);
}
