import 'package:crypto_beam/provider/auth_provider.dart';
import 'package:crypto_beam/provider/transcation_provider.dart';
import 'package:crypto_beam/widgets/he3.dart';
import 'package:crypto_beam/widgets/loading.dart';
import 'package:crypto_beam/widgets/transcation_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ETHHistory extends ConsumerStatefulWidget {
  const ETHHistory({super.key});

  @override
  ConsumerState<ETHHistory> createState() => _ETHHistoryState();
}

class _ETHHistoryState extends ConsumerState<ETHHistory> {
  late Future futureHolder;

  Future<bool> fetchdata() async {
    final user = ref.read(authProvider).user;
    await ref.read(transcationProvider).fetchTranscations(user!.uid);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> newLoad() async {
    await Future.delayed(const Duration(milliseconds: 20));
    return true;
  }

  Future<void> onRefresh() async {
    setState(() {
      futureHolder = fetchdata();
    });
  }

  @override
  initState() {
    futureHolder = fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: futureHolder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            if (snapshot.hasError) {
              return Center(
                child: hes3(context),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: hes3(context),
              );
            }
            final data = ref.watch(transcationProvider).transactions;
            final newdata = data
                .where((element) =>
                    element.transcationId.isNotEmpty && element.ETH != 0)
                .toList();

            return newdata.length == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        hes3(context),
                        // buy_recieve(context),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: newdata.length,
                    itemBuilder: (context, i) {
                      var us = newdata[i];
                      return TranscationTile(transcation: us);
                    },
                  );
          }),
    );
  }
}
