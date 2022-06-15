import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import '../screens/scan_offline.dart';
import 'chat.dart';

/* Cette page gère l'affichage des interfaces pour le mâitre ou l'esclave */
enum DeviceType { advertiser, browser }

class DevicesListScreen extends StatefulWidget {
  DevicesListScreen({required this.deviceType, required this.documentId});

  final DeviceType deviceType;
  //documentId est partagé depuis le fichier components/item_list_test.dart pour se rappeler quel événement on veut scanner
  final String documentId;

  @override
  _DevicesListScreenState createState() => _DevicesListScreenState();
}

class _DevicesListScreenState extends State<DevicesListScreen> {
  List<Device> devices = [];
  List<Device> connectedDevices = [];
  late NearbyService nearbyService;
  late StreamSubscription subscription;

  late Chat activity;
  bool isInit = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    subscription.cancel();
    nearbyService.stopBrowsingForPeers();
    nearbyService.stopAdvertisingPeer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("QR Scanner"),
          leadingWidth: 100,
          leading: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_left_sharp),
              label: const Text("Back"),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  // primary: Colors.transparent,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold))),
          /* actions: [
              ElevatedButton(
                // style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all(
                //   CustomColors.backgroundColorDark,
                // )),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScanOffline(
                            connectedDevices: connectedDevices,
                            nearbyService: nearbyService,
                            documentId: widget.documentId)),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    Text("Liste",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          //color: CustomColors.textSecondary,
                        )),
                    Icon(Icons.arrow_right_sharp)
                  ],
                ),
              )
            ]*/
        ),
        backgroundColor: Colors.white,
        body: ListView.builder(
            itemCount: getItemCount(),
            itemBuilder: (context, index) {
              /*
              Condition pour différencier entre l'interface maître et escale. En effet, pour le maître on affiche les dispositifs
              disponibles, contrairement au esclave, on affiche seulement le maître connecté
               */

              final device = widget.deviceType == DeviceType.advertiser
                  ? connectedDevices[index]
                  : devices[index];
              return Container(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(textDirection: TextDirection.rtl, children: [
                      Expanded(
                          child: GestureDetector(
                            onTap: () => _onTabItemListener(device),
                            child: Column(
                              textDirection: TextDirection.rtl,
                              children: [
                                SizedBox(height: 9.0),
                                Text(
                                  device.deviceName,
                                ),
                                Text(
                                  getStateName(device.state),
                                  style:
                                  TextStyle(color: getStateColor(device.state)),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          )),
                      // Request connect
                      GestureDetector(
                        onTap: () => _onButtonClicked(device),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          height: 40,
                          width: 40,
                          color: getButtonColor(device.state),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Icon(
                                  getButtonStateIcon(device.state),
                                  color: Colors.white,
                                )
                              ]),
                        ),
                      ),
                      SizedBox.fromSize(
                        size: Size(40, 40), // button width and height
                        // child: ClipOval(

                        child: Material(
                          //color: Colors.blue, // button color
                          child: InkWell(
                            // splash color
                            onTap: () {
                              if (device.state == SessionState.connected) {
                                connectedDevices.add(device);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(" Connected"),
                                  backgroundColor: Colors.black,
                                ));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScanOffline(
                                          connectedDevices: device,
                                          nearbyService: nearbyService,
                                          documentId: widget.documentId)),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Disconnected "),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            }, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.chat,
                                  color: Colors.black,
                                ), // icon
                              ],
                            ),
                          ),
                        ),
                        // ),
                      )
                    ]),
                    SizedBox(
                      height: 8.0,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    )
                  ],
                ),
              );
            }));
  }

  //fonction pour savoir si on a toujours la connexion avec un dispositif ou non
  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "Disconnected";
      case SessionState.connecting:
        return "Connecting";
      default:
        return "Connected";
    }
  }

  //fonction pour changer l'état de connexion dans l'interface
  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "Connect";
      case SessionState.connecting:
        return "Connecting";
      default:
        return "Disconnect";
    }
  }

  IconData getButtonStateIcon(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Icons.link;
      case SessionState.connecting:
        return Icons.autorenew;
      default:
        return Icons.link_off;
    }
  }

  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.red;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.black;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  //on l'a seulement utilisé pour tester la communication
  _onTabItemListener(Device device) {
    if (device.state == SessionState.connected) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            final myController = TextEditingController();
            return AlertDialog(
              title: Text("Send message"),
              content: TextField(controller: myController),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Send"),
                  onPressed: () {
                    nearbyService.sendMessage(
                        device.deviceId, myController.text);
                    log(myController.text);
                    myController.text = '';
                  },
                )
              ],
            );
          });
    }
  }

  int getItemCount() {
    if (widget.deviceType == DeviceType.advertiser) {
      return connectedDevices.length;
    } else {
      return devices.length;
    }
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        nearbyService.invitePeer(
          deviceID: device.deviceId,
          deviceName: device.deviceName,
        );
        break;
      case SessionState.connected:
        nearbyService.disconnectPeer(deviceID: device.deviceId);
        break;
      case SessionState.connecting:
        break;
    }
  }

  void init() async {
    nearbyService = NearbyService();
    String devInfo = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      devInfo = androidInfo.model;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      devInfo = iosInfo.localizedModel;
    }
    await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: devInfo,
        strategy: Strategy.P2P_CLUSTER,
        callback: (isRunning) async {
          if (isRunning) {
            if (widget.deviceType == DeviceType.browser) {
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(Duration(microseconds: 200));
              await nearbyService.startBrowsingForPeers();
            } else {
              await nearbyService.stopAdvertisingPeer();
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(Duration(microseconds: 200));
              await nearbyService.startAdvertisingPeer();
              await nearbyService.startBrowsingForPeers();
            }
          }
        });
    subscription =
        nearbyService.stateChangedSubscription(callback: (devicesList) {
          devicesList.forEach((element) {
            print(
                " deviceId: ${element.deviceId} | deviceName: ${element.deviceName} | state: ${element.state}");

            if (Platform.isAndroid) {
              if (element.state == SessionState.connected) {
                nearbyService.stopBrowsingForPeers();
              } else {
                nearbyService.startBrowsingForPeers();
              }
            }
          });

          setState(() {
            devices.clear();
            devices.addAll(devicesList);
            connectedDevices.clear();
            connectedDevices.addAll(devicesList
                .where((d) => d.state == SessionState.connected)
                .toList());
          });
        });
  }
}

//