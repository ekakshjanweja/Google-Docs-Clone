import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/constants/colors.dart';
import 'package:google_docs_clone/constants/fonts.dart';
import 'package:google_docs_clone/models/document_model.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:google_docs_clone/repository/auth_repository.dart';
import 'package:google_docs_clone/repository/document_repository.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;

  const DocumentScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: 'Untitled Document  ');
  final quill.QuillController _controller = quill.QuillController.basic();
  ErrorModel? errorModel;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void updateTitle(
    WidgetRef ref,
    String title,
  ) {
    ref.read(documentRepositoryProvider).updateDocumentTitle(
          token: ref.read(userProvider)!.token,
          id: widget.id,
          title: title,
        );
  }

  @override
  void initState() {
    super.initState();
    fetchDocumentData();
  }

  void fetchDocumentData() async {
    errorModel = await ref.read(documentRepositoryProvider).getDocumentById(
          ref.read(userProvider)!.token,
          widget.id,
        );

    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Image.asset(
                'assets/docs-logo.png',
                height: 40,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kBlueColor),
                  ),
                  contentPadding: EdgeInsets.only(left: 10),
                ),
                onSubmitted: (value) => updateTitle(ref, value),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.lock,
                size: 16,
                color: kWhiteColor,
              ),
              label: Text(
                "Share",
                style: Fonts.buttonText(context).copyWith(color: kWhiteColor),
              ),
              style: TextButton.styleFrom(
                backgroundColor: kBlueColor,
                padding: const EdgeInsets.all(8),
                elevation: 2,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: kGreyColor, width: 0.1),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            quill.QuillToolbar.basic(controller: _controller),
            Expanded(
              child: SizedBox(
                width: 750,
                child: Card(
                  elevation: 5,
                  color: kWhiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(36),
                    child: quill.QuillEditor.basic(
                      controller: _controller,
                      readOnly: false, // true for view only mode
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
}
