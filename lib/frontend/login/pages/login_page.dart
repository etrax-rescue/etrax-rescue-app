import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/organizations.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../../themes.dart';
import '../../util/translate_error_messages.dart';
import '../../widgets/about_menu_entry.dart';
import '../../widgets/animated_button_sliver.dart';
import '../../widgets/popup_menu.dart';
import '../../widgets/width_limiter.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget implements AutoRouteWrapper {
  LoginPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
        data: themeData[AppTheme.LightStatusBar],
        child: BlocProvider(
            create: (_) => sl<LoginBloc>()..add(InitializeLogin()),
            child: this));
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _username;
  String _password;
  String _selectedOrganization;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ExtendedNavigator.of(context).popAndPush(Routes.missionPage);
          } else if (state is OpenAppConnectionPage) {
            ExtendedNavigator.of(context).popAndPush(Routes.appConnectionPage);
          }
        },
        child: CustomScrollView(
          physics: RangeMaintainingScrollPhysics()
              .applyTo(AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              actions: <Widget>[
                PopupMenu(actions: {
                  0: generateAboutMenuEntry(context),
                  1: PopupAction(
                    child: Text(S.of(context).RECONNECT),
                    onPressed: () {
                      context
                          .read<LoginBloc>()
                          .add(RequestAppConnectionUpdate());
                    },
                  ),
                }),
              ],
              expandedHeight: max(MediaQuery.of(context).size.height / 3, 150),
              flexibleSpace: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      16, MediaQuery.of(context).padding.top + 8, 16, 16),
                  child: Image(
                    image: AssetImage('assets/images/etrax_rescue_logo.png'),
                    width: 200,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: WidthLimiter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      if (state is LoginInitial ||
                          state is LoginSuccess ||
                          state is OpenAppConnectionPage) {
                        return CircularProgressIndicator();
                      } else if (state is LoginInitializationError) {
                        return Column(
                          children: [
                            Text(translateErrorMessage(
                                context, state.messageKey)),
                            RaisedButton(
                              onPressed: () {
                                BlocProvider.of<LoginBloc>(context)
                                    .add(InitializeLogin());
                              },
                              child: Text(S.of(context).RETRY),
                            )
                          ],
                        );
                      } else {
                        final organizations = state.organizations.organizations;
                        _selectedOrganization =
                            state.organizationID ?? organizations[0].id;
                        _username = state.username ?? '';

                        List<DropdownMenuItem<String>> _dropdownItems =
                            organizations.map((Organization organization) {
                          return DropdownMenuItem<String>(
                            value: organization.id,
                            child: Text(organization.name),
                          );
                        }).toList();

                        return Form(
                          key: _formKey,
                          child: AutofillGroup(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(S.of(context).LOGIN_HEADING,
                                    style:
                                        Theme.of(context).textTheme.headline5),
                                Visibility(
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: S.of(context).ORGANIZATION,
                                    ),
                                    items: _dropdownItems,
                                    value: _selectedOrganization,
                                    onChanged: (val) {
                                      _selectedOrganization = val;
                                    },
                                    onSaved: (val) {
                                      _selectedOrganization = val;
                                    },
                                    validator: (val) => val == null
                                        ? S.of(context).FIELD_REQUIRED
                                        : null,
                                  ),
                                  visible:
                                      state.organizations.organizations.length >
                                          1,
                                ),
                                TextFormField(
                                  autofillHints: <String>[
                                    AutofillHints.username
                                  ],
                                  decoration: InputDecoration(
                                    labelText: S.of(context).USERNAME,
                                  ),
                                  initialValue: _username,
                                  onChanged: (val) {
                                    _username = val;
                                  },
                                  onSaved: (val) {
                                    _username = val;
                                  },
                                  validator: (val) => val.length < 1
                                      ? S.of(context).FIELD_REQUIRED
                                      : null,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.visiblePassword,
                                  autofillHints: <String>[
                                    AutofillHints.password
                                  ],
                                  decoration: InputDecoration(
                                    labelText: S.of(context).PASSWORD,
                                  ),
                                  onChanged: (val) {
                                    _password = val;
                                  },
                                  onSaved: (val) {
                                    _password = val;
                                  },
                                  onFieldSubmitted: (val) => submit(),
                                  validator: (val) => val.length < 1
                                      ? S.of(context).FIELD_REQUIRED
                                      : null,
                                  obscureText: true,
                                ),
                                SizedBox(height: 16),
                                BlocBuilder<LoginBloc, LoginState>(
                                  builder: (context, state) {
                                    return AnimatedSwitcher(
                                      duration: kThemeAnimationDuration,
                                      child: state is LoginError
                                          ? Text(
                                              translateErrorMessage(
                                                  context, state.messageKey),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            )
                                          : SizedBox(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginInitial) {
                  return SliverToBoxAdapter();
                }
                return AnimatedButtonSliver(
                  selected: (state is LoginInProgress || state is LoginSuccess),
                  onPressed: submit,
                  label: S.of(context).LOGIN,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      context.read<LoginBloc>().add(SubmitLogin(
          username: _username,
          password: _password,
          organizationID: _selectedOrganization));
    }
  }
}
