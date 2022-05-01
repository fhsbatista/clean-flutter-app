import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/i18n/i18n.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class SurveyResultPage extends StatelessWidget with Loading, SessionExpiration {
  final SurveyResultPresenter presenter;

  const SurveyResultPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(I18n.strings.surveys)),
      body: Builder(builder: (context) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          handleLoading(context, presenter.isLoadingStream);
          handleSessionExpiration(presenter.isSessionExpiredStream);
          presenter.loadData();
        });

        return StreamBuilder<SurveyResultViewModel?>(
          stream: presenter.surveyResultStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: ReloadScreen(
                  error: snapshot.error.toString(),
                  onReloadClick: presenter.loadData,
                ),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return SurveyResult(
                  viewModel: snapshot.data!,
                  onClick: (answer) {
                    presenter.save(answer: answer);
                  },
                );
              }
            }
            return SizedBox.shrink();
          },
        );
      }),
    );
  }
}
