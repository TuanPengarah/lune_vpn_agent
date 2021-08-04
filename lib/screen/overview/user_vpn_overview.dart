import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:lune_vpn_agent/config/constant.dart';
import 'package:lune_vpn_agent/dialog/cancel_req_dialog.dart';
import 'package:lune_vpn_agent/provider/current_user.dart';
import 'package:lune_vpn_agent/provider/firestore_services.dart';
import 'package:lune_vpn_agent/snackbar/error_snackbar.dart';
import 'package:lune_vpn_agent/snackbar/success_snackbar.dart';
import 'package:lune_vpn_agent/ui/circular_loading_dialog.dart';
import 'package:ndialog/ndialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

class VpnOverview extends StatelessWidget {
  final String? uid;
  final String? userName;
  final String? duration;
  final String? status;
  final String? location;
  final int? price;
  final String? email;
  final bool? isPending;
  final String? remarks;
  final Timestamp? timeStamp;
  final String? vpnEnd;
  final String? agent;

  VpnOverview({
    this.uid,
    this.userName,
    this.duration,
    this.status,
    this.location,
    this.price,
    this.isPending,
    this.remarks,
    this.timeStamp,
    this.email,
    this.vpnEnd,
    this.agent,
  });

  void _fabAction(BuildContext context, String? userUID) async {
    if (status == 'Pending') {
      await showCancelRequest(
              context,
              'Are you sure want to cancel this '
              'request?')
          .then((b) async {
        if (b == true) {
          CustomProgressDialog progressDialog =
              CustomProgressDialog(context, blur: 6);
          progressDialog.setLoadingWidget(
            Center(
              child: CircularLoadingDialog('Deleting your vpn...'),
            ),
          );
          progressDialog.show();
          await Future.delayed(Duration(seconds: 1));
          progressDialog.dismiss();
          Navigator.of(context).pop();
          await context
              .read<FirebaseFirestoreAPI>()
              .deletingVPN(userUID!, uid.toString())
              .then((s) {
            if (s == 'operation-completed') {
              showSuccessSnackBar('Deleting completed', 2);
            } else {
              showErrorSnackBar(
                  'Aw snap! An error occured, please try '
                  'again later',
                  2);
            }
          });
        }
      });
    } else if (status == 'Expired') {
      showCancelRequest(context, 'Are you sure want to renew this vpn?')
          .then((b) async {
        if (b == true) {
          CustomProgressDialog progressDialog =
              CustomProgressDialog(context, blur: 6);
          progressDialog.setLoadingWidget(
            Center(
              child: CircularLoadingDialog('Requesting your vpn..'),
            ),
          );
          progressDialog.show();
          await Future.delayed(Duration(seconds: 1));
          progressDialog.dismiss();
          Navigator.of(context).pop();
          await context
              .read<FirebaseFirestoreAPI>()
              .renewVPN(
                userUID: userUID.toString(),
                vpnUID: uid.toString(),
                isReport: false,
                price: price,
                serverLocation: location,
                duration: duration,
                email: email,
                customer: agent,
                username: userName.toString(),
              )
              .then((s) {
            if (s == 'operation-completed') {
              showSuccessSnackBar('Requesting completed', 2);
            } else {
              showErrorSnackBar(
                  'Aw snap! An error occured, please try '
                  'again later',
                  2);
            }
          });
        }
      });
    } else if (status == 'Active') {
      showCancelRequest(
              context,
              'Are you sure want to report problem for '
              'this vpn? Our Admin will contact you soon')
          .then((b) async {
        if (b == true) {
          CustomProgressDialog progressDialog =
              CustomProgressDialog(context, blur: 6);
          progressDialog.setLoadingWidget(
            Center(
              child: CircularLoadingDialog('Generating report...'),
            ),
          );
          progressDialog.show();
          await Future.delayed(Duration(seconds: 1));
          progressDialog.dismiss();
          Navigator.of(context).pop();
          await context
              .read<FirebaseFirestoreAPI>()
              .reportVPN(
                agent: agent,
                email: email,
                remarks: remarks,
                duration: duration,
                timeStamp: timeStamp,
                vpnName: userName.toString(),
                vpnStatus: status.toString(),
                serverLocation: location,
                vpnEnd: vpnEnd,
                userUID: userUID,
                vpnUID: uid,
                price: price,
              )
              .then((s) {
            if (s == 'completed') {
              showSuccessSnackBar('Report successfully send to our admin', 2);
            } else {
              showErrorSnackBar('Aw snap! An error occured: $s', 2);
            }
          });
        }
      });
    } else if (status == 'Canceled') {
      showCancelRequest(context, 'Are you sure want to delete this vpn?')
          .then((b) async {
        if (b == true) {
          CustomProgressDialog progressDialog =
              CustomProgressDialog(context, blur: 6);
          progressDialog.setLoadingWidget(
            Center(
              child: CircularLoadingDialog('Deleting your vpn...'),
            ),
          );
          progressDialog.show();
          await Future.delayed(Duration(seconds: 1));
          progressDialog.dismiss();
          Navigator.of(context).pop();
          await context
              .read<FirebaseFirestoreAPI>()
              .deletingVPN(userUID!, uid.toString())
              .then((s) {
            if (s == 'operation-completed') {
              showSuccessSnackBar('Deleting completed', 2);
            } else {
              showErrorSnackBar(
                  'Aw snap! An error occured, please try '
                  'again later',
                  2);
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? _userUID = context.watch<CurrentUser>().uid;
    return DismissiblePage(
      onDismiss: () => Navigator.of(context).pop(),
      child: Hero(
        tag: '$uid',
        child: Scaffold(
          appBar: AppBar(
            title: Text('Details'),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Padding(
                padding: kPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title('Vpn Username'),
                    _subTitle(userName.toString()),
                    _title('Vpn Duration'),
                    _subTitle(duration.toString()),
                    _title('Server Location'),
                    _subTitle(location.toString()),
                    _title('Status'),
                    _subTitle(status.toString()),
                    _title('Last Update'),
                    _subTitle(
                      DateFormat('d/MM/yyyy hh:mm a')
                          .format(timeStamp!.toDate())
                          .toString(),
                    ),
                    status == 'Active' ? _title('Expired Dated') : Container(),
                    status == 'Active' ? _subTitle('$vpnEnd') : Container(),
                    _title('Remarks'),
                    _subTitle(remarks == '' || remarks == null
                        ? '--'
                        : remarks.toString()),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: SpeedDial(
            icon: status == 'Expired'
                ? Icons.autorenew
                : status == 'Active'
                    ? Icons.bug_report
                    : Icons.delete,
            label: status == 'Expired'
                ? Text('Renew')
                : status == 'Canceled'
                    ? Text('Delete')
                    : status == 'Active'
                        ? Text('Report Problem')
                        : Text('Cancel Request'),
            onPress: () {
              print(email);
              _fabAction(context, _userUID);
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: Theme.of(context).primaryColor,
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    CustomProgressDialog progressDialog =
                        CustomProgressDialog(context, blur: 6);
                    progressDialog.setLoadingWidget(
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText(
                              'VPN Unique Identifier\n\n$uid',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 15),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white12)),
                              onPressed: () {
                                Share.share(uid.toString(),
                                    subject: 'Vpn Unique Identifier');
                              },
                              child: Text(
                                'Share',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    progressDialog.show();
                  },
                  icon: Icon(
                    Icons.vpn_key,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _subTitle(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }

  Padding _title(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
