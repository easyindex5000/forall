import 'package:big/Providers/DataProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:big/Providers/languageProvider.dart';

class ShippingIstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(allTranslations.text( "Shipping Istructions"),style: TextStyle(color: DataProvider().secondry,),),
    ),   body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<LanguageProvider>(builder: (context, model, _) {
          if (model.locale.languageCode == "en") {
            return ListView.separated(
              itemCount: english.length,
              itemBuilder: (context, index) {
                return Text(english[index]);
              },
              separatorBuilder: (_, __) {
                return Text("");
              },
            );
          }
          else if (model.locale.languageCode == "ar") {
 return ListView.separated(
              itemCount: arabic.length,
              itemBuilder: (context, index) {
                return Text(arabic[index]);
              },
              separatorBuilder: (_, __) {
                return Text("");
              },
            );
          }
          else{
              return ListView.separated(
              itemCount: english.length,
              itemBuilder: (context, index) {
                return Text(english[index]);
              },
              separatorBuilder: (_, __) {
                return Text("");
              },
            );
          }
        }),
      ),
    );
  }
}
List<String> english=[''' \u002D Delivery of items purchased at For All App will be carried out via an international courier company and delivered in Saudi Arabia takes 2 – 5 days, international delivery takes 7 – 15 days.

\u002D  In order to avoid any delivery problems (incorrect addresses, nobody at home, etc.), you must complete the applicable form correctly and it is advisable to leave a contact telephone number in the corresponding field.

\u002D Orders can be tracked via the, For All App Webpage, indicating the location of the goods at each moment until final reception.

\u002D For Cash on Delivery, please have the exact amount available for the courier. It will save you time.

\u002D For any questions, please call us +966548055570 during our regular working hours (Saturday to Thursday, 09:00am-6:00pm KSA Time).''',
];
List<String> arabic=['''
\u002D   سيتم تنفيذ تسليم العناصر المشترة على موقع For All App عبر شركة شحن دولية وتسلم خلال 2 - 5 ايام و التسليم دوليا خلال 7 - 15 ايام.

\u002D   لتجنب أي مشاكل في التسليم (عناوين غير صحيحة ، لا أحد في المنزل ، وما إلى ذلك) ، يجب عليك ملء النموذج المطبق بشكل صحيح ومن المستحسن ترك رقم هاتف جهة الاتصال في الحقل المقابل.

\u002D   يمكن تتبع الطلبات عبر For All App والتي تشير إلى موقع البضائع في كل لحظة حتى الاستقبال النهائي.

\u002D  الدفع عند التسليم ، يرجى الحصول على المبلغ الدقيق المتاح للبريد السريع. سوف توفر عليك الوقت.

\u002D  لأية استفسارات حول التوصيل يرجى الاتصال بنا على 966548055570+ خلال ساعات العمل المعتادة (من السبت إلى الخميس ، من الساعة 09:00 صباحًا إلى 6:00 مساءً بتوقيت المملكة العربية السعودية ).
'''];