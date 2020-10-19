import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/home/job_entries/job_entries_page.dart';
import 'package:school_im/app/home/jobs/edit_job_page.dart';
import 'package:school_im/app/home/jobs/job_list_tile.dart';
import 'package:school_im/app/home/jobs/list_items_builder.dart';
import 'package:school_im/app/home/models/job.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:school_im/app/top_level_providers.dart';
import 'package:school_im/constants/strings.dart';
import 'package:pedantic/pedantic.dart';

/*
final jobsStreamProvider = StreamProvider.autoDispose<List<Job>>((ref) {
  final database = ref.watch(databaseProvider);
  return database?.jobsStream() ?? const Stream.empty();
});
*/

// watch database
class DashboardPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dash"),
      ),
      body: Text('dash'),
    );
  }
}
