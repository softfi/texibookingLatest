import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:taxibooking/utils/Extensions/StringExtensions.dart';

import '../../main.dart';
import '../../service/AuthService1.dart';
import '../../utils/Colors.dart';
import '../../utils/Common.dart';
import '../../utils/Extensions/AppButtonWidget.dart';
import '../../utils/Extensions/app_common.dart';
import '../../utils/Extensions/app_textfield.dart';
import '../utils/Constants.dart';
import 'TermsConditionScreen.dart';

class RegisterScreen extends StatefulWidget {
  final bool socialLogin;
  final String? userName;
  final bool isOtp;
  final String? countryCode;
  final String? privacyPolicyUrl;
  final String? termsConditionUrl;

  RegisterScreen(
      {this.socialLogin = false,
      this.userName,
      this.isOtp = false,
      this.countryCode,
      this.privacyPolicyUrl,
      this.termsConditionUrl});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthServices authService = AuthServices();

  TextEditingController firstController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  bool mIsCheck = false;
  bool isAcceptedTc = false;
  String countryCode = defaultCountryCode;
  String selectGender = MALE;
  List<String> gender = [MALE, FEMALE, OTHER];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      debugPrint("entereddddddddddddddddddddd");
      formKey.currentState!.save();
      if (isAcceptedTc) {
        debugPrint("checkinggggggggggggggggg");
        appStore.setLoading(true);
        authService
            .signUpWithEmailPassword(
          context,
          name: firstController.text.trim(),
          mobileNumber: widget.socialLogin
              ? '$countryCode ${widget.userName}'
              : '$countryCode ${phoneController.text.trim()}',
          email: emailController.text.trim(),
          fName: firstController.text.trim(),
          lName: lastNameController.text.trim(),
          userName: widget.socialLogin
              ? widget.userName
              : userNameController.text.trim(),
          password:
              widget.socialLogin ? widget.userName : passController.text.trim(),
          userType: RIDER,
          socialLoginName: widget.socialLogin,
          isOtp: widget.isOtp,
          gender: selectGender,
        )
            .then((res) async {
          debugPrint("calleddddddddddddddddddddddddddddddddd");
          appStore.setLoading(false);
          //
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        });
      } else {
        toast(language.pleaseAcceptTermsOfServicePrivacyPolicy);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(language.createAccount, style: boldTextStyle(size: 22)),
                  SizedBox(height: 8),
                  Text(language.createYourAccountToContinue,
                      style: primaryTextStyle()),
                  SizedBox(height: 32),
                  AppTextField(
                    controller: firstController,
                    focus: firstNameFocus,
                    nextFocus: lastNameFocus,
                    autoFocus: false,
                    textFieldType: TextFieldType.NAME,
                    errorThisFieldRequired: errorThisFieldRequired,
                    decoration:
                        inputDecoration(context, label: language.firstName),
                  ),
                  SizedBox(height: 20),
                  AppTextField(
                    controller: lastNameController,
                    focus: lastNameFocus,
                    nextFocus: userNameFocus,
                    autoFocus: false,
                    textFieldType: TextFieldType.OTHER,
                    errorThisFieldRequired: errorThisFieldRequired,
                    decoration:
                        inputDecoration(context, label: language.lastName),
                  ),
                  if (widget.socialLogin != true) SizedBox(height: 20),
                  if (widget.socialLogin != true)
                    AppTextField(
                      controller: userNameController,
                      focus: userNameFocus,
                      nextFocus: emailFocus,
                      autoFocus: false,
                      textFieldType: TextFieldType.USERNAME,
                      errorThisFieldRequired: errorThisFieldRequired,
                      decoration:
                          inputDecoration(context, label: language.userName),
                    ),
                  SizedBox(height: 20),
                  AppTextField(
                    controller: emailController,
                    focus: emailFocus,
                    nextFocus: phoneFocus,
                    autoFocus: false,
                    textFieldType: TextFieldType.EMAIL,
                    keyboardType: TextInputType.emailAddress,
                    errorThisFieldRequired: errorThisFieldRequired,
                    decoration: inputDecoration(context, label: language.email),
                  ),
                  if (widget.socialLogin != true) SizedBox(height: 20),
                  if (widget.socialLogin != true)
                    AppTextField(
                      controller: phoneController,
                      textFieldType: TextFieldType.PHONE,
                      focus: phoneFocus,
                      nextFocus: passFocus,
                      decoration: inputDecoration(
                        context,
                        label: language.phoneNumber,
                        prefixIcon: IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CountryCodePicker(
                                padding: EdgeInsets.zero,
                                initialSelection: countryCode,
                                showCountryOnly: false,
                                dialogSize: Size(
                                    MediaQuery.of(context).size.width - 60,
                                    MediaQuery.of(context).size.height * 0.6),
                                showFlag: true,
                                showFlagDialog: true,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                                textStyle: primaryTextStyle(),
                                dialogBackgroundColor:
                                    Theme.of(context).cardColor,
                                barrierColor: Colors.black12,
                                dialogTextStyle: primaryTextStyle(),
                                searchDecoration: InputDecoration(
                                  iconColor: Theme.of(context).dividerColor,
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).dividerColor)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primaryColor)),
                                ),
                                searchStyle: primaryTextStyle(),
                                onInit: (c) {
                                  countryCode = c!.dialCode!;
                                },
                                onChanged: (c) {
                                  countryCode = c.dialCode!;
                                },
                              ),
                              VerticalDivider(
                                  color: Colors.grey.withOpacity(0.5)),
                            ],
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty)
                          return errorThisFieldRequired;
                        if (value.trim().length < 10 ||
                            value.trim().length > 14)
                          return language.contactLength;
                        return null;
                      },
                    ),
                  if (widget.socialLogin != true) SizedBox(height: 20),
                  if (widget.socialLogin != true)
                    AppTextField(
                      controller: passController,
                      focus: passFocus,
                      autoFocus: false,
                      textFieldType: TextFieldType.PASSWORD,
                      errorThisFieldRequired: errorThisFieldRequired,
                      decoration:
                          inputDecoration(context, label: language.password),
                    ),
                  SizedBox(height: 16),
                  Text(language.selectGender, style: boldTextStyle()),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: inputDecoration(context, label: ""),
                    value: selectGender,
                    onChanged: (String? value) {
                      setState(() {
                        selectGender = value!;
                      });
                    },
                    items: gender
                        .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              "${value.capitalizeFirstLetter()}",
                              style: primaryTextStyle(),
                            )))
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: primaryColor,
                          value: isAcceptedTc,
                          shape:
                              RoundedRectangleBorder(borderRadius: radius(2)),
                          onChanged: (v) async {
                            isAcceptedTc = v!;
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: '${language.iAgreeToThe} ',
                                style: secondaryTextStyle()),
                            TextSpan(
                              text: language.termsConditions,
                              style:
                                  boldTextStyle(color: primaryColor, size: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if (widget.termsConditionUrl != null &&
                                      widget.termsConditionUrl!.isNotEmpty) {
                                    launchScreen(
                                        context,
                                        TermsConditionScreen(
                                            title: language.termsConditions,
                                            subtitle: widget.termsConditionUrl),
                                        pageRouteAnimation:
                                            PageRouteAnimation.Slide);
                                  } else {
                                    toast(language.txtURLEmpty);
                                  }
                                },
                            ),
                            TextSpan(text: ' & ', style: secondaryTextStyle()),
                            TextSpan(
                              text: language.privacyPolicy,
                              style:
                                  boldTextStyle(color: primaryColor, size: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if (widget.privacyPolicyUrl != null &&
                                      widget.privacyPolicyUrl!.isNotEmpty) {
                                    launchScreen(
                                        context,
                                        TermsConditionScreen(
                                            title: language.privacyPolicy,
                                            subtitle: widget.privacyPolicyUrl),
                                        pageRouteAnimation:
                                            PageRouteAnimation.Slide);
                                  } else {
                                    toast(language.txtURLEmpty);
                                  }
                                },
                            ),
                          ]),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  AppButtonWidget(
                    width: MediaQuery.of(context).size.width,
                    color: primaryColor,
                    textStyle: boldTextStyle(color: Colors.white),
                    text: language.signUp,
                    onTap: () async {
                      register();
                    },
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(language.alreadyHaveAnAccount,
                            style: primaryTextStyle()),
                        SizedBox(width: 8),
                        inkWellWidget(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(language.logIn,
                              style: boldTextStyle(color: primaryColor)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Observer(builder: (context) {
            return Visibility(
              visible: appStore.isLoading,
              child: loaderWidget(),
            );
          })
        ],
      ),
    );
  }
}
