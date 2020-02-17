import 'package:flutter/material.dart';
import 'package:big/localization/all_translations.dart';
import 'package:provider/provider.dart';
import 'package:big/Providers/languageProvider.dart';
import 'package:big/Providers/DataProvider.dart';

class ReturnPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          allTranslations.text("Returns and Refund Policy"),
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
          } else if (model.locale.languageCode == "ar") {
            return ListView.separated(
              itemCount: arabic.length,
              itemBuilder: (context, index) {
                return Text(arabic[index]);
              },
              separatorBuilder: (_, __) {
                return Text("");
              },
            );
          } else {
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
  '''IMPORTANT  NOTICE :
\u002D The subscription value is not refundable.

\u002D Refunds will be done only through the Original Mode of Payment.

\u002D You will be responsible for paying for your own shipping costs for returning your item. Shipping costs are non-refundable. If you receive a refund, the cost of return shipping will be deducted from your refund.

\u002D We do not accept any return from the items which are purchased from any Promotion or Sale. We will only accept the items which are not in the promotion.

\u002D You have 15 calendar days to return an item from the date you received it.

\u002D If you don't like the Product OR its Quality OR Changed Your Mind.

\u002D If you wish to exchange your item for another model or color, you must return the item and place a new order.

\u002D Home Essential Products are packed by manufacturers after the complete quality and damage check. Opened / Installed / Dismantled products will not be accepted for returns because they cannot be repacked.

\u002D To be eligible for a return, your item must be unused and in the same condition that you received it. If the condition of the return item is unsellable, we deserve the right no to refund you. Any extra cost occurred including shipping fee will be on your side.

\u002D Damaged Item, Wrong Item or Missing Items in Order.

\u002D If you receive an order with any wrong, damaged item or your ordered item is missing, kindly inform us at your earliest within 3 Days to our Customer Service Helpline.

\u002D We will arrange a courier to pick up the damaged or wrong item and once it received, our warehouse team will inspect. After inspection of the damaged or wrong item, we will send you the replacement accordingly. Same for the Missing items as well.

\u002D Products / Orders which cannot be returned.

\u002D If the packing of the item or product is missing, in that case, the order will not be returned.

\u002D Lingerie’s, Undergarments, Swimwear, Beachwear or Makeup items cannot be returned due to hygienic reasons.

\u002D Used/Reconditioned product or with Broken/Removed tags will not be considered for return as well as if the product is found dirty.'''
];
List<String> arabic = [
 ''' \u002D قيمة الاشتراك غير قابلة للاسترجاع.

 \u002D لن يتم استرداد الأموال إلا من خلال طريقة الدفع الأصلية.

\u002D سوف تكون مسؤولاً عن دفع تكاليف الشحن الخاصة بك للعودة البند الخاص بك. تكاليف الشحن غير قابلة للاسترداد. إذا تلقيت استرداد ، سيتم خصم تكلفة إعادة الشحن من المبلغ المسترد. 

\u002D نحن لا نقبل أي عائد من العناصر التي يتم شراؤها من أي ترويج أو بيع. نحن نقبل فقط العناصر التي ليست في الترويج.

\u002D لديك 15 يومًا تقويميًا لإرجاع عنصر من التاريخ الذي تلقيته فيه.

\u002D إذا كنت لا تحب المنتج أو جودته أو غيرت رأيك:

\u002D إذا كنت لا تحب المنتج أو جودته أو إذا غيرت رأيك بشأن أي منتج أو طلب كامل ، في هذه الحالة ، سوف تحتاج إلى دفع رسوم الشحن للتحصيل لكلا الجانبين حتى لو كان التسليم مجانيًا .

\u002D إذا كنت ترغب في استبدال العنصر الخاص بك لطراز أو لون آخر ، فيجب عليك إعادة العنصر ووضع طلب جديد.

\u002D يتم تعبئة المنتجات الأساسية المنزلية من قبل الشركات المصنعة بعد الفحص الكامل للجودة والأضرار. لن يتم قبول المنتجات التي تم فتحها / تثبيتها / تفكيكها للحصول على عوائد لأنه لا يمكن إعادة تعبئتها.

\u002D لتكون مؤهلاً للحصول على عائد ، يجب إلغاء استخدام العنصر الخاص بك وفي نفس الحالة التي حصلت عليها. إذا كانت حالة البند المرتجعة غير قابلة للإلغاء ، فنحن نستحق الحق في رد المبلغ إليك. أي تكلفة إضافية حدثت بما في ذلك رسوم الشحن ستكون على جانبكم.

\u002D العنصر التالف ، عنصر خاطئ أو العناصر المفقودة بالترتيب:

\u002D إذا تلقيت طلبًا يحتوي على أي عنصر خاطئ أو تالف أو كان العنصر الذي طلبته مفقودًا ، فيرجى إخبارنا بذلك في أقرب وقت ممكن خلال 3 أيام إلى خط مساعدة خدمة العملاء لدينا.

\u002D سنرتب ساعيًا لاستلام القطعة التالفة أو الخاطئة وبمجرد استلامها ، سيقوم فريق المستودعات التابع لنا بفحصها. بعد التفتيش على العنصر التالف أو الخطأ ، سوف نرسل لك بديل وفقا لذلك. نفس الشيء بالنسبة للعناصر المفقودة أيضًا.

\u002D المنتجات / أوامر التي لا يمكن إرجاعها:

\u002D في حالة فقد تعبئة العنصر أو المنتج ، في هذه الحالة ، لن يتم إرجاع الطلب. او لا يمكن إرجاع الملابس الداخلية أو الملابس الداخلية أو ملابس السباحة أو ملابس السباحة أو الماكياج لأسباب صحية.

\u002D لن يتم اعتبار المنتج المُستخدم / الذي تم تجديده أو به علامات مكسورة / تمت إزالته ، كما لو كان المنتج متسخًا.'''
];
