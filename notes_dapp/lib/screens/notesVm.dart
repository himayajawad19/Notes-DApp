import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_dapp/models/notes_model.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class Notesvm extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<NotesModel> notes = [];

  final String _rpcUrl = 'http://10.0.2.2:7545';
  final String _wscUrl = 'ws://10.0.2.2:7545';
  final String _privateKey =
      "0x9e56e4f9eb05e02eecc61c8d77611c0f90329945aa95ebc1597a1042b02ee079";
  late Web3Client _web3Client;
  late ContractAbi _contractAbi;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;
  late DeployedContract _deployedContract;
  late ContractFunction _createNote;
  late ContractFunction _deleteNote;
  late ContractFunction _editNote;
  late ContractFunction _notes;
  late ContractFunction _noteCount;
  bool _isEdit = false;
  bool _isLoading = false;

  bool get isEdit => _isEdit;
  bool get isLoading => _isLoading;

  set isEdit(bool value) {
    _isEdit = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Notesvm() {
    init();
  }

  // Initializing web3client
  Future init() async {
    // await Future.delayed(Duration(seconds: 2));
    isLoading = true;
    notifyListeners();
    _web3Client = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wscUrl).cast<String>();
      },
    );

    await getAbi();
    await getCred();
    await getDeployedContract();
    await getNotes();
     isLoading = false;
        notifyListeners();
  }

  // Getting Abi
  Future<void> getAbi() async {
    String abiFile = await rootBundle.loadString("build/contracts/Notes.json");
    var jsonAbi = jsonDecode(abiFile);
    _contractAbi = ContractAbi.fromJson(
      jsonEncode(jsonAbi['abi']),
      "Notes.json",
    );
    _contractAddress = EthereumAddress.fromHex(
      "0xAB8801EA0993Df6aBF6d0bba491d223567e00709",
    );
  }

  Future<void> getCred() async {
    _creds = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_contractAbi, _contractAddress);
    _createNote = _deployedContract.function('createNote');
    _deleteNote = _deployedContract.function('deleteNote');
    _editNote = _deployedContract.function('updateNote');
    _notes = _deployedContract.function('notes');
    _noteCount = _deployedContract.function('noteCount');
  }

  Future<void> getNotes() async {
       isLoading = true;
       notifyListeners();
    List totalTaskList = await _web3Client.call(
      contract: _deployedContract,
      function: _noteCount,
      params: [],
    );
    int totalTaskLength = totalTaskList[0].toInt();
    notes.clear();
    for (int i = 0; i < totalTaskLength; i++) {
      var temp = await _web3Client.call(
        contract: _deployedContract,
        function: _notes,
        params: [BigInt.from(i)],
      );
      if (temp[1] != "") {
        notes.add(
          NotesModel(
            time: DateTime.fromMillisecondsSinceEpoch(
              (temp[3] as BigInt).toInt() * 1000,
            ),

            title: temp[1],
            description: temp[2],
            id: (temp[0] as BigInt).toInt(),
          ),
        );
      }
      log("Note ID: ${temp[2]}}");
    }
isLoading= false;
    notifyListeners();
  }

  Future<void> createNote(String title, String description) async {
    await _web3Client.sendTransaction(
      chainId: 1337,
      fetchChainIdFromNetworkId: false,
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createNote,
        parameters: [title, description],
      ),
    );

    notifyListeners();
    getNotes();
  }

  Future<void> deleteNote(int id) async {
    log(id.toString());

    await _web3Client.sendTransaction(
      chainId: 1337,
      fetchChainIdFromNetworkId: false,
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _deleteNote,
        parameters: [BigInt.from(id)],
      ),
    );
    notifyListeners();
    getNotes();
  }

  Future<void> editNote(int noteId, String title, String description) async {
    log(noteId.toString());
    await _web3Client.sendTransaction(
      chainId: 1337,
      fetchChainIdFromNetworkId: false,
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _editNote,
        parameters: [BigInt.from(noteId), title, description],
      ),
    );
    notifyListeners();
    getNotes();
  }

  void setData(int index) {
    if (isEdit) {
      titleController.text = notes[index].title;
      descriptionController.text = notes[index].description;
    }
    notifyListeners();
  }
}
