import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/i18n/i18n.dart';

import './components/components.dart';
import 'surveys.dart';

class SurveysPage extends StatefulWidget {
  SurveysPage(this.presenter);

  final SurveysPresenter presenter;

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      widget.presenter.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(I18n.strings.surveys)),
      body: Builder(builder: (context) {
        widget.presenter.isLoadingStream.listen((isLoading) async {
          if (isLoading) {
            await showLoading(context);
          } else {
            hideLoading(context);
          }
        });
        widget.presenter.navigateToStream.listen((route) {
          if (route?.isNotEmpty ?? false) {
            Get.toNamed(route!);
          }
        });
        widget.presenter.isSessionExpiredStream.listen((isExpired) async {
          if (isExpired) {
            Get.offAllNamed('/login');
          }
        });
        return StreamBuilder<List<SurveyViewModel>>(
          stream: widget.presenter.surveysStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: ReloadScreen(
                  error: snapshot.error.toString(),
                  onReloadClick: widget.presenter.loadData,
                ),
              );
            }
            if (snapshot.hasData) {
              return ListenableProvider(
                create: (_) => widget.presenter,
                child: SurveyItemsList(snapshot.data ?? []),
              );
            }
            return SizedBox.shrink();
          },
        );
      }),
    );
  }
}
