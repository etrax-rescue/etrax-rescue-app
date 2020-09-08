import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../backend/types/organizations.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../util/translate_error_messages.dart';
import '../../widgets/popup_menu.dart';
import '../../widgets/width_limiter.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget implements AutoRouteWrapper {
  LoginPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<LoginBloc>()..add(InitializeLogin()), child: this);
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
          } else if (state is LoginError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                translateErrorMessage(context, state.messageKey),
              ),
            ));
          }
        },
        child: CustomScrollView(
          physics: RangeMaintainingScrollPhysics()
              .applyTo(AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).backgroundColor,
              actions: <Widget>[
                PopupMenu(),
              ],
              expandedHeight: MediaQuery.of(context).size.height / 3,
              flexibleSpace: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(16),
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
                          state is OpenAppConnectionPage ||
                          state is LoginInProgress) {
                        return CircularProgressIndicator();
                      } else if (state is LoginInitializationError) {
                        return Column(
                          children: [
                            Text(state.messageKey),
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
                                BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, state) {
                                  if (state is LoginError) {
                                    return Text(
                                      translateErrorMessage(
                                          context, state.messageKey),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).accentColor),
                                    );
                                  }
                                  return Container();
                                }),
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
                                  validator: (val) => val.length < 1
                                      ? S.of(context).FIELD_REQUIRED
                                      : null,
                                  obscureText: true,
                                ),
                                /*
                                SizedBox(height: 16),
                                
                                AnimatedCrossFade(
                                  firstChild: ButtonTheme(
                                    minWidth: double.infinity,
                                    child: RaisedButton(
                                      color: Theme.of(context).accentColor,
                                      textTheme: ButtonTextTheme.primary,
                                      onPressed: submit,
                                      child: Text(S.of(context).LOGIN),
                                    ),
                                  ),
                                  secondChild: Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: CircularProgressIndicator()),
                                  ),
                                  crossFadeState: state is LoginInProgress
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  duration: const Duration(milliseconds: 250),
                                ),
                                */
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
            SliverFillRemaining(
              hasScrollBody: false,
              child: WidthLimiter(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            onPressed: () {
                              context
                                  .bloc<LoginBloc>()
                                  .add(RequestAppConnectionUpdate());
                            },
                            child: Text(S.of(context).RECONNECT)),
                        MaterialButton(
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          onPressed: submit,
                          child: Text(S.of(context).LOGIN),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      context.bloc<LoginBloc>().add(SubmitLogin(
          username: _username,
          password: _password,
          organizationID: _selectedOrganization));
    }
  }
}
