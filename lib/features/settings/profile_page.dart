import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:n_leaks/core/controllers/corp_controller.dart';
import 'package:n_leaks/core/data/models/corp_model.dart';
import 'package:n_leaks/core/data/models/user_model.dart';
import 'package:n_leaks/features/settings/widgets/app_material_button.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _fieldsControllers = List.generate(
    7,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    super.dispose();
    _fieldsControllers.map((controller) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
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
            'Profile',
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
              child: BlocBuilder<CorpController, CorpModel?>(
                builder: (context, corpState) {
                  final user = corpState!.currentUser;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.tertiary,
                                width: 2.w,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 47.r,
                              backgroundImage: AssetImage(
                                user.pictureUrl ??
                                    'assets/images/pngs/main_user_photo.png',
                              ),
                            ),
                          ),
                          SizedBox(width: 22.w),
                          Expanded(
                            child: Text(
                              user.name,
                              style: Theme.of(
                                context,
                              ).textTheme.displayMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Text(
                          'Information',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      NamedTextField(
                        name: 'Full Name',
                        hintText: 'Your full name',
                        controller: _fieldsControllers[0]..text = user.name,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 10.h),
                      NamedTextField(
                        name: 'Gender',
                        controller: _fieldsControllers[1]..text = user.gender,
                        options: const ['Male', 'Female'],
                      ),
                      SizedBox(height: 10.h),
                      NamedTextField(
                        name: 'Country',
                        hintText: 'Your country',
                        controller: _fieldsControllers[2]
                          ..text = user.country ?? '',
                        validator: (value) => null,
                      ),
                      SizedBox(height: 10.h),
                      NamedTextField(
                        name: 'Phone Number',
                        hintText: 'Your phone number',
                        controller: _fieldsControllers[3]
                          ..text = user.phoneNumber ?? '',
                        validator: (value) => null,
                      ),
                      SizedBox(height: 10.h),
                      NamedTextField(
                        name: 'Language',
                        controller: _fieldsControllers[4]..text = user.language,
                        options: const ['English', 'Arabic'],
                      ),
                      SizedBox(height: 10.h),
                      NamedTextField(
                        name: 'Position',
                        editable: false,
                        controller: _fieldsControllers[5]..text = user.position,
                      ),
                      SizedBox(height: 10.h),
                      NamedTextField(
                        name: 'Company',
                        editable: false,
                        controller: _fieldsControllers[6]..text = user.company,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Text(
                          'My Email Address',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 53.w,
                            height: 52.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/svgs/email_icon.svg',
                              height: 25.h,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              user.email,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      AppMaterialButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              '+ Add Email Address',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      AppMaterialButton(
                        onPressed: () {
                          _saveInfo(user);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Save',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveInfo(UserModel user) {
    if (_formKey.currentState!.validate()) {
      // Simulate saving the updated profile information to the server
      if (_fieldsControllers[0].text.trim() != user.name ||
          _fieldsControllers[1].text.trim() != user.gender ||
          _fieldsControllers[2].text.trim() != (user.country ?? '') ||
          _fieldsControllers[3].text.trim() != (user.phoneNumber ?? '') ||
          _fieldsControllers[4].text.trim() != user.language) {
        context.read<CorpController>().add(
          UpdateUserInfo(
            user.copyWith(
              name: _fieldsControllers[0].text.trim(),
              gender: _fieldsControllers[1].text.trim(),
              country: _fieldsControllers[2].text.trim().isEmpty
                  ? null
                  : _fieldsControllers[2].text.trim(),
              phoneNumber: _fieldsControllers[3].text.trim().isEmpty
                  ? null
                  : _fieldsControllers[3].text.trim(),
              language: _fieldsControllers[4].text.trim(),
            ),
          ),
        );
      }
    }
  }
}
