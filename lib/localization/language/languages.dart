import 'package:flutter/material.dart';

abstract class Languages {

  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  String get labelWelcome;

  String get labelInfo;

  String get labelSelectLanguage;

  String get appAccount;
  String get update_number;
  String get select;
  String get numphone;
  String get entersim;
  String get saved;
  String get error;
  String get errormsg;
  String get save;
  String get savehouse;
  String get appsetting;
  String get langu;
  String get exitapp;
  String get exitreally;
  String get nostay;
  String get yes;
  String get setting;
  String get notifaudio;
  String get displaynotif;
  String get modenoncote;
  String get termandcond;
  String get apropos;
  String get aide;
  String get historique;
  String get all;
  String get embou;
  String get routebarre;
  String get autre;
  String get noalert;
  String get addressunknown;
  String get zonedanger;
  String get accidentdecircu;
  String get routechantier;
  String get pubposition;
  String get completetocreatealert;
  String get cat;
  String get enterpositionexact;
  String get notks;
  String get noresult;
  String get msgsearchbefore;
  String get searchlieu;
  String get notavail;
  String get alertinactive;
  String get alertsent;
  String get alertsuccess;
  String get at;
  String get positionexc;
  String get enterexactposition;
  String get infolegale;
  String get selectnumber;
  String get compteexiste;
  String get inscrisok;
  String get continuer;
  String get welcomemapane;
  String get mapanepresentation;
  String get closeall;
  String get localiser;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;
  // String get update_number;

}