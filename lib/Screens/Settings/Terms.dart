import 'package:big/Providers/DataProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:big/Providers/languageProvider.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          allTranslations.text("Terms"),
          style: TextStyle(color: DataProvider().secondry),
        ),
      ),
      body: Padding(
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

List<String> english = [
  ''' Welcome to For All App. By entering our Website, you agree to these terms and conditions. Please review these carefully prior to making any purchases. By using this Website you agree with these Terms.
These conditions will replace any terms and/or conditions as For All App reserves the right to make changes to this site and these conditions at any time.

For All is an online service for the purpose of the sale of clothing, accessories and other items.

In order to be able to make purchases through the Website, you will be requested to register. The information sought will allow For All to handle your transaction efficiently and effectively.

Any dispute or claim arising out of or in connection with this website shall be governed and construed in accordance with the laws of Saudi Arabia.

Saudi Arabia is our country of domicile. Minors under the age of 18 shall are prohibited to register as a User of this website and are not allowed to transact or use the website.

If you make a payment for our products or services on our website, the details you are asked to submit will be provided directly to our payment provider via a secured connection.

The cardholder must retain a copy of transaction records and Merchant policies and rules. We accept payments online using Visa and MasterCard credit/debit card in AED (or any other agreed currency).

For All App will NOT deal or provide any services or products to any of OFAC (Office of Foreign Assets Control) sanctions countries in accordance with the law of Saudi Arabia.

Multiple transactions may result in multiple postings to the cardholder’s monthly statement.

IF PAYMENT WILL BE MADE ONLINE - it is important that you enter all the requested information accurately. This will ensure that there is no delay in the dispatch of your order. The information provided will be treated in the strictest confidence. We do not share any customer data to any third parties and all customer data is held on a secure server

PAYMENT METHODS - For All only accepts payment by credit or debit card (Visa and MasterCard), via cash on delivery.

Payment by credit or debit card For All accepts payments for purchases made via its Website with the following credit or debit cards: Visa and MasterCard.

For payments by credit or debit card, the charge will be made online, in other words, in real time, through the payment gateway of the corresponding financial entity, once it has been confirmed that the data sent by the user is correct.

Cash on delivery For All accepts payments cash on delivery.  Customers must pay their order's corresponding amount on the reception of the same.

MAKEUP & COSMETICS - All products should be used strictly in accordance with their instructions, precautions and guidelines. You should always check the ingredients for products to avoid potential allergic reactions.

THE FOLLOWING ITEMS CANNOT BE RETURNED OR EXCHANGED DUE TO HYGIENIC REASONS:''',
  "Lingerie",
  "Undergarments",
  "Swimwear and Beachwear",
  "Sportswear Bra"
];
List<String> arabic = [
  "مرحبًا بكم في  For All App عن طريق إدخال موقعنا ، أنت توافق على هذه الشروط والأحكام. يرجى مراجعة هذه بعناية قبل إجراء أي عمليات شراء. باستخدام هذا الموقع فإنك توافق على هذه الشروط",
  "ستحل هذه الشروط محل أي شروط و / أو شروط حيث يحتفظ الدليل السهل بالحق في إجراء تغييرات على هذا الموقع وهذه الشروط في أي وقت.",
  "For All App هي خدمة عبر الإنترنت لغرض بيع الملابس والاكسسوارات وغيرها."
      "لتتمكن من إجراء عمليات الشراء من خلال الموقع الإلكتروني ، سيُطلب منك التسجيل. ستسمح المعلومات المطلوبة لـ  For All App بمعالجة معاملتك بكفاءة وفعالية.",
  "يخضع أي نزاع أو مطالبة تنشأ عن أو فيما يتعلق بهذا الموقع الإلكتروني وتفسيره وفقًا لقوانين دولة المملكة العربية السعودية.",
  "دولة  المملكة العربية السعودية هي موطننا",
  "يُحظر على القاصرين الذين تقل أعمارهم عن 18 عامًا التسجيل كمستخدم لهذا الموقع ولا يُسمح لهم بالتعامل أو استخدام الموقع.",
  "ذا قمت بالدفع مقابل منتجاتنا أو خدماتنا على موقعنا ، فسيتم تقديم التفاصيل التي يُطلب منك تقديمها مباشرة إلى مزود الدفع الخاص بنا عبر اتصال آمن.",
  "يجب أن يحتفظ حامل البطاقة بنسخة من سجلات المعاملات وسياسات وقواعد تاجر. نحن نقبل الدفع عبر الإنترنت باستخدام بطاقة الائتمان / الخصم  الفيز او الماستر كارد بالدولار (أو أي عملة أخرى متفق عليها).",
  "موقع For All App لن يتعامل أو يقدم أي خدمات أو منتجات إلى أي من بلدان مكتب مراقبة الأصول الأجنبي وفقًا لقانون دولة المملكة العربية السعودية. ",
  "قد تؤدي المعاملات المتعددة إلى ترحيلات متعددة للبيان الشهري لحامل البطاقة.",
  "إذا كان سيتم الدفع عبر الإنترنت - من المهم أن تقوم بإدخال جميع المعلومات المطلوبة بدقة. "
      "سيضمن ذلك عدم وجود تأخير في إرسال طلبك. سيتم التعامل مع المعلومات المقدمة بسرية تامة. نحن لا نشارك أي بيانات العملاء إلى أي أطراف ثالثة وجميع بيانات العملاء يتم الاحتفاظ بها على خادم آمن.",
  "طرق الدفع لا تقبل For All App سوى الدفع عن طريق بطاقة الائتمان أو الخصم ( الفيز او الماستر كارد) ، عن طريق الدفع نقدًا عند التسليم. ",
  "الدفع عن طريق بطاقة الائتمان أو الخصم",
  "يقبل For All App مدفوعات المشتريات التي تتم عبر موقعه الإلكتروني ببطاقات الائتمان أو الخصم التالية:الفيز او        الماستر كارد. "
      "بالنسبة للمدفوعات عن طريق بطاقة الائتمان أو الخصم ، سيتم دفع الرسوم عبر الإنترنت ، بمعنى آخر ، في الوقت الفعلي ، من خلال بوابة الدفع للكيان المالي المقابل ، بمجرد تأكيد صحة البيانات المرسلة من قبل المستخدم.",
  "الدفع عند الاستلام",
  "For All App يقبل المدفوعات النقدية عند التسليم. يجب على العملاء دفع المبلغ المقابل لطلبهم عند استقباله. ",
  "مستحضرات التجميل ومستحضرات التجميل - يجب استخدام جميع المنتجات بدقة وفقًا لتعليماتهم واحتياطاتهم وإرشاداتهم. يجب عليك دائمًا التحقق من مكونات المنتجات لتجنب الحساسية المحتملة.",
  "لا يمكن إرجاع العناصر التالية أو استبدالها بسبب أسباب صحية:",
  "ملابس",
  "	ملابس سفلية",
  "ملابس سباحة وبحر",
  "حمالة الصدر الرياضية"
];
