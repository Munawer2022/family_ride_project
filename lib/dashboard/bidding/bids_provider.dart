import 'package:flutter/material.dart';

import 'bids_model.dart';
import 'bids_services.dart';

class BidsProvider extends ChangeNotifier {
  final _service = BidsService();
  bool isLoading = false;
  List<BidsModel> _bids = [];
  List<BidsModel> get bids => _bids;

  Future<void> getAllBids() async {
    // isLoading = true;
    // notifyListeners();

    final response = await _service.getAll();

    _bids = response;
    isLoading = false;
    notifyListeners();
  }
}
