import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/data/models/corp_model.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';
import 'package:n_leaks/core/widgets/subscription_card.dart';
import 'package:n_leaks/features/settings/widgets/app_material_button.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _fieldsControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    _fieldsControllers.map((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CorpModel corpInfo = context.watch<CorpController>().state!;
    return SafeArea(
      top: false,
      child: Scaffold(
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
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 20.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SubscriptionCard(
                    corporationLogoPath: corpInfo.logoUrl,
                    corporationName: corpInfo.name,
                    subscriptionPlan: corpInfo.subscriptionPlan,
                    subscriptionDate: corpInfo.subscriptionDate,
                    subscriptionStatus: corpInfo.subscriptionStatus,
                  ),
                  Text(
                    'Company Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  NamedTextField(
                    name: 'Company Name',
                    controller: _fieldsControllers[0]..text = corpInfo.name,
                  ),
                  NamedTextField(
                    name: 'Industry',
                    controller: _fieldsControllers[1]..text = corpInfo.industry,
                  ),
                  NamedTextField(
                    name: 'Domain',
                    controller: _fieldsControllers[2]..text = corpInfo.domain,
                  ),
                  NamedTextField(
                    name: 'Expected User Count',
                    controller: _fieldsControllers[3]
                      ..text = corpInfo.usersLimit.toString(),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    spacing: 10.w,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AppMaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle save as draft logic
                          }
                        },
                        child: Text(
                          'Save as Draft',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      AppMaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle send update request logic
                          }
                        },
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
        ),
      ),
    );
  }
}
