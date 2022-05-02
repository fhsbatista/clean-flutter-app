import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/i18n/i18n.dart';

import '../../mixins/mixins.dart';
import './components/components.dart';
import 'surveys.dart';

class SurveysPage extends StatefulWidget {
  SurveysPage(this.presenter);

  final SurveysPresenter presenter;

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with Loading, Navigation, SessionExpiration, RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      widget.presenter.loadData();
    });
  }

  @override
  void didPopNext() {
    super.didPopNext();
    widget.presenter.loadData();
  }

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<RouteObserver>().subscribe(
      this,
      ModalRoute.of(context) as PageRoute,
    );
    return Scaffold(
      appBar: AppBar(title: Text(I18n.strings.surveys)),
      body: Builder(builder: (context) {
        handleLoading(context, widget.presenter.isLoadingStream);
        handleNavigation(widget.presenter.navigateToStream);
        handleSessionExpiration(widget.presenter.isSessionExpiredStream);
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
