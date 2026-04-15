import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';
import 'package:n_leaks/core/widgets/subscription_card.dart';
import 'package:n_leaks/features/settings/components/domains_input_field.dart';
import 'package:n_leaks/features/settings/widgets/app_material_button.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final Map<String, Object> _subscriptionInfo = {
    'corporationLogoPath': 'assets/images/svgs/corporation_logo.svg',
    'corporationName': 'Acme Corporation',
    'corporationIndustry': 'Technology',
    'corporationUserCount': '130',
    'corporationAdminEmail': 'security@acme.inc',
    'corporationDomains': <String>['acme.inc', 'acme-labs.io'],
    'subscriptionDate': DateTime(2024, 1, 12),
    'subscriptionPlan': 'Pro',
    'subscriptionStatus': 'Active',
  };

  final List<TextEditingController> _fieldsControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _fieldsControllers.map((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.surface.withValues(alpha: 0.8),
        surfaceTintColor: Theme.of(
          context,
        ).colorScheme.surface.withValues(alpha: 0.8),
        title: Text(
          'Company Subscription',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.tertiary,
            size: 25.sp,
          ),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.only(left: 20.w),
        ),
        leadingWidth: 50.w,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 120.h,
            bottom: 30.h,
          ),
          child: Column(
            spacing: 20.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SubscriptionCard(
                corporationLogoPath:
                    _subscriptionInfo['corporationLogoPath'] as String,
                corporationName: _subscriptionInfo['corporationName'] as String,
                subscriptionPlan:
                    _subscriptionInfo['subscriptionPlan'] as String,
                subscriptionDate:
                    _subscriptionInfo['subscriptionDate'] as DateTime,
                subscriptionStatus:
                    _subscriptionInfo['subscriptionStatus'] as String,
              ),
              Text(
                'Company Information',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              NamedTextField(
                name: 'Company Name',
                controller: _fieldsControllers[0]
                  ..text = _subscriptionInfo['corporationName'] as String,
              ),
              NamedTextField(
                name: 'Industry',
                controller: _fieldsControllers[1]
                  ..text = _subscriptionInfo['corporationIndustry'] as String,
              ),
              NamedTextField(
                name: 'Expected User Count',
                controller: _fieldsControllers[2]
                  ..text = _subscriptionInfo['corporationUserCount'] as String,
                keyboardType: TextInputType.number,
              ),
              NamedTextField(
                name: 'Admin Contact Email',
                controller: _fieldsControllers[3]
                  ..text = _subscriptionInfo['corporationAdminEmail'] as String,
              ),
              DomainsInputField(
                domains:
                    _subscriptionInfo['corporationDomains'] as List<String>,
                controller: _fieldsControllers[4],
              ),
              Row(
                spacing: 10.w,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AppMaterialButton(
                    child: Text(
                      'Save as Draft',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  AppMaterialButton(
                    child: Row(
                      spacing: 10.w,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/images/svgs/send_icon.svg',
                          width: 15,
                        ),
                        Text(
                          'Send Update Request',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
