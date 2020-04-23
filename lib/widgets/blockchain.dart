import 'dart:math';
import 'dart:io';
import 'package:http/http.dart';
import 'package:path/path.dart' show join, dirname;
import 'package:web_socket_channel/io.dart';

import 'package:web3dart/web3dart.dart';

Credentials fromHex = EthPrivateKey.fromHex("92u3908i219030129380921832109");
var rng = new Random.secure();

//PRIVATE KEY SHOULD BE BROUGHT IN BY WALLET
const String privateKey =
    '85d2242ae1b7759934d4b0d4f0d62d666cf7d73e21dbd09d73c7de266b72a25a';

const String rpcUrl = "https://ropsten.infura.io/v3/485dc3cc3cd340e5bfca58dbf28b9226";
const String wsUrl = 'wss://ropsten.infura.io/ws/v3/485dc3cc3cd340e5bfca58dbf28b9226';
final abiFile = File(join(dirname(Platform.script.path), 'abi.json'));

final EthereumAddress contractAddr =
    EthereumAddress.fromHex('0x4A6DD27A6122f02fDA6E2B9b9cCb800db7120637');
final EthereumAddress receiver =
    EthereumAddress.fromHex('');


void main() async {
  // establish a connection to the ethereum rpc node. The socketConnector
  // property allows more efficient event streams over websocket instead of
  // http-polls. However, the socketConnector property is experimental.
  final client = Web3Client(rpcUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(wsUrl).cast<String>();
  });
  final credentials = await client.credentialsFromPrivateKey(privateKey);
  final ownAddress = await credentials.extractAddress();

  // read the contract abi and tell web3dart where it's deployed (contractAddr)
  final abiCode = await abiFile.readAsString();
  final contract =
      DeployedContract(ContractAbi.fromJson(abiCode, 'ImgSqr'), contractAddr);

  // extracting some functions and events that we'll need later
  final getById = contract.event('getById');
  final getCount = contract.function('getCount');
  final createAsset = contract.function('createAsset');
  final getIdByPosition = contract.function('getIdByPosition');


  final balance = await client.call(
    contract: contract, function: getCount, params: []);
    print(contract);




  // // listen for the Transfer event when it's emitted by the contract above
  // final subscription = client
  //     .events(FilterOptions.events(contract: contract, event: transferEvent))
  //     .take(1)
  //     .listen((event) {
  //   final decoded = transferEvent.decodeResults(event.topics, event.data);

  //   final from = decoded[0] as EthereumAddress;
  //   final to = decoded[1] as EthereumAddress;
  //   final value = decoded[2] as BigInt;

  //   print('$from sent $value MetaCoins to $to');
  // });

  // // check our balance in MetaCoins by calling the appropriate function
  // final count = await client.call(
  //     contract: contract, function: getCount, params: [ownAddress]);
  // print('We have ${count.first} MetaCoins');

  // // send all our MetaCoins to the other address by calling the sendCoin
  // // function
  // await client.sendTransaction(
  //   credentials,
  //   Transaction.callContract(
  //     contract: contract,
  //     function: sendFunction,
  //     parameters: [receiver, balance.first],
  //   ),
  // );

  // await subscription.asFuture();
  // await subscription.cancel();

  await client.dispose();
}