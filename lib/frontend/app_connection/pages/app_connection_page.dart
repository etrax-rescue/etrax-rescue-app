import 'package:auto_route/auto_route.dart';
import 'package:etrax_rescue_app/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../../routes/router.gr.dart';
import '../../util/translate_error_messages.dart';
import '../../widgets/custom_material_icons.dart';
import '../../widgets/popup_menu.dart';
import '../../widgets/width_limiter.dart';
import '../cubit/app_connection_cubit.dart';

class AppConnectionPage extends StatefulWidget implements AutoRouteWrapper {
  AppConnectionPage({Key key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return Theme(
        data: themeData[AppTheme.LightStatusBar],
        child:
            BlocProvider(create: (_) => sl<AppConnectionCubit>(), child: this));
  }

  @override
  _AppConnectionPageState createState() => _AppConnectionPageState();
}

class _AppConnectionPageState extends State<AppConnectionPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  String _connectionString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AppConnectionCubit, AppConnectionState>(
        listener: (context, state) {
          _connectionString = state.connectionString ?? '';
          _controller.text = _connectionString;

          if (state.status == AppConnectionStatus.success) {
            ExtendedNavigator.of(context).popAndPush(Routes.loginPage);
          }
        },
        child: CustomScrollView(
          physics: RangeMaintainingScrollPhysics()
              .applyTo(AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).backgroundColor,
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
              actions: [
                PopupMenu(),
              ],
            ),
            SliverToBoxAdapter(
              child: WidthLimiter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: BlocBuilder<AppConnectionCubit, AppConnectionState>(
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(S.of(context).APP_CONNECTION_HEADING,
                                style: Theme.of(context).textTheme.headline5),
                            TextFormField(
                              controller: _controller,
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                hintText: 'https://app.etrax.at',
                                suffixIcon: IconButton(
                                  icon: Icon(CustomMaterialIcons.qrCodeScanner),
                                  onPressed: () {
                                    context.bloc<AppConnectionCubit>().scanCode(
                                        S.of(context).CANCEL,
                                        S.of(context).FLASH_ON,
                                        S.of(context).FLASH_OFF);
                                  },
                                ),
                              ),
                              onChanged: (val) {
                                _connectionString = val;
                              },
                              onFieldSubmitted: (val) {
                                submit();
                              },
                              validator: (val) => val.length < 1
                                  ? S.of(context).FIELD_REQUIRED
                                  : null,
                            ),
                            SizedBox(height: 16),
                            BlocBuilder<AppConnectionCubit, AppConnectionState>(
                              builder: (context, state) {
                                print(state.messageKey);
                                return AnimatedOpacity(
                                  opacity:
                                      state.status == AppConnectionStatus.error
                                          ? 1.0
                                          : 0.0,
                                  duration: Duration(milliseconds: 250),
                                  child: Text(
                                    translateErrorMessage(
                                        context, state.messageKey),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).accentColor),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: BlocBuilder<AppConnectionCubit, AppConnectionState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: state.status == AppConnectionStatus.loading,
                        child: AnimatedOpacity(
                          opacity: state.status == AppConnectionStatus.loading
                              ? 0.0
                              : 1.0,
                          duration: Duration(milliseconds: 250),
                          child: WidthLimiter(
                            child: Container(
                              color: Theme.of(context).backgroundColor,
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: MaterialButton(
                                  color: Theme.of(context).accentColor,
                                  textColor: Colors.white,
                                  onPressed: submit,
                                  child: Text(S.of(context).CONNECT),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
      context.bloc<AppConnectionCubit>().submit(_connectionString);
    }
  }
}
