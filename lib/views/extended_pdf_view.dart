import 'dart:math';
import 'dart:typed_data';

import 'package:ap_common/resources/ap_icon.dart';
import 'package:ap_common/utils/analytics_utils.dart';
import 'package:ap_common/utils/ap_localizations.dart';
import 'package:ap_common/views/pdf_view.dart';
import 'package:ap_common/widgets/hint_content.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ExtendedPdfView extends StatefulWidget {
  const ExtendedPdfView({
    Key? key,
    required this.state,
    this.onRefresh,
    this.data,
    this.fileName,
  }) : super(key: key);

  final PdfState state;
  final Function()? onRefresh;
  final Uint8List? data;
  final String? fileName;

  @override
  _ExtendedPdfViewState createState() => _ExtendedPdfViewState();
}

class _ExtendedPdfViewState extends State<ExtendedPdfView> {
  @override
  void initState() {
    AnalyticsUtils.instance?.setCurrentScreen(
      'PdfView',
      'pdf_view.dart',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.state) {
      case PdfState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case PdfState.error:
        return errorContent;
      default:
        return Scaffold(
            body: PdfPreview.builder(
              build: (PdfPageFormat format) {
                return widget.data!;
              },
              useActions: false,
              pagesBuilder: (BuildContext context, List<PdfPreviewPageData> pages) => SingleChildScrollView(
                child: Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  children: [
                    for (final page in pages)
                      Container(
                        color: Colors.white,
                        child: Image(
                          image: page.image,
                          width: 600,
                        ),
                      )
                  ],
                ),
              ),
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'share',
                  onPressed: () async {
                    AnalyticsUtils.instance?.logEvent('export_by_share');
                    await Printing.sharePdf(
                      bytes: widget.data!,
                      filename: '${widget.fileName ?? 'export'}.pdf',
                    );
                  },
                  child: Icon(ApIcon.share),
                ),
                const SizedBox(height: 16.0),
                FloatingActionButton(
                  heroTag: 'export',
                  onPressed: () async {
                    AnalyticsUtils.instance?.logEvent('export_by_printing');
                    await Printing.layoutPdf(
                      name: widget.fileName ?? 'export',
                      onLayout: (PdfPageFormat format) => widget.data!,
                    );
                  },
                  child: Icon(ApIcon.print),
                ),
              ],
            ));
    }
  }

  Widget get errorContent => InkWell(
        onTap: () {
          widget.onRefresh?.call();
        },
        child: HintContent(
          icon: ApIcon.error,
          content: ApLocalizations.of(context).clickToRetry,
        ),
      );
}
