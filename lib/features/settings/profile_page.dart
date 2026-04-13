import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:n_leaks/features/settings/widgets/app_material_button.dart';
import 'package:n_leaks/core/widgets/named_text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String _fullName = 'Mohamed Adel';
  final String _username = '@dula_jr17';
  final String _email = 'mohamedadel@example.com';
  final String _gender = 'Male';
  final String _country = 'Egypt';
  final String _phone = '+20 123 456 7890';
  final String _language = 'English';
  final String _position = 'Flutter Developer';
  final String _company = 'Tech Corp';

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

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
          child: Column(
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
                      backgroundImage: const AssetImage(
                        'assets/images/pngs/user_photo.png',
                      ),
                    ),
                  ),
                  SizedBox(width: 22.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _fullName,
                          style: Theme.of(context).textTheme.displayMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          _username,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.tertiary.withValues(alpha: 0.7),
                              ),
                        ),
                      ],
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
                hintText: 'Enter your full name',
                controller: _fullNameController..text = _fullName,
              ),
              SizedBox(height: 10.h),
              NamedTextField(
                name: 'Username',
                hintText: 'Enter your username',
                controller: _usernameController..text = _username,
              ),
              SizedBox(height: 10.h),
              NamedTextField(
                name: 'Gender',
                controller: _genderController..text = _gender,
                options: const ['Male', 'Female'],
              ),
              SizedBox(height: 10.h),
              NamedTextField(
                name: 'Country',
                hintText: 'Enter your country',
                controller: _countryController..text = _country,
              ),
              SizedBox(height: 10.h),
              NamedTextField(
                name: 'Phone Number',
                hintText: 'Enter your phone number',
                controller: _phoneController..text = _phone,
              ),
              SizedBox(height: 10.h),
              NamedTextField(
                name: 'Language',
                controller: _languageController..text = _language,
                options: const ['English', 'Arabic'],
              ),
              SizedBox(height: 10.h),
              NamedTextField(
                name: 'Position',
                editable: false,
                controller: _positionController..text = _position,
              ),
              SizedBox(height: 10.h),
              NamedTextField(
                name: 'Company',
                editable: false,
                controller: _companyController..text = _company,
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
                      _email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              AppMaterialButton(
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
          ),
        ),
      ),
    );
  }
}
