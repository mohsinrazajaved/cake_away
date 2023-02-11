import 'package:cake_away/Utilities/constants.dart';
import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  final Function callback;
  Terms({this.callback});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Text("""
Objet

Les présentes conditions de vente ont pour but de définir les relations contractuelles entre Cake Away et les Utilisateurs ainsi que les conditions applicables à toute réservation de prestation, ci-après dénommé « Prestation ou réalisation» via l’application informatique afférente, que l’Utilisateur soit particulier ou professionnel. Ces conditions générales de vente prévalent sur toutes autres conditions générales ou particulières non expressément agréées par Cake Away. L’application est dédiée au référencement et à la mise en relation d’intervenants indépendants et extérieurs à Cake Away réalisant des Prestations dans le domaine de la pâtisserie et des ateliers pâtisseries à domicile ou chez les clients. Ci-après dénommé « Utilisateurs » .

Le non-respect par un Utilisateurs de ses obligations au titre des présentes Conditions Générales de Vente pourra entraîner la suspension voire la résiliation de son compte, sans préjudice de tous dommages et intérêts que pourrait solliciter Cake Away.
 
Acceptation des conditions générales de vente

La réservation d’un service à travers le Site ou applications afférentes implique une acceptation sans réserve par l’Utilisateur des présentes conditions générales de vente. Cake Away se réserve le droit de pouvoir adapter ou modifier ses conditions générales de vente à tout moment. Les Conditions générales de vente applicables sont celles en vigueur le jour de la commande par l’Utilisateur. En cas de manquement à l’une des obligations prévues par les présentes, Cake Away se réserve la possibilité de supprimer tout profil créé par l’Utilisateur (ci-après dénommé « Compte utilisateur ») concerné.
 
Les prestations proposées

L’Utilisateur doit impérativement procéder à la création d’un Compte d’utilisateur personnel préalablement à toute réservation  d’une Prestation. Les offres de Prestations sont valables tant qu’elles sont annoncées et ceci en fonction de la disponibilité et la zone géographique d’intervention annoncée ou validée lors de la réservation. Chaque utilisateur fait l’objet d’une description sur sa page personnelle. Chaque utilisateur propose différentes Prestations. Chaque utilisateur gère lui-même ses tarifs, son calendrier (ses heures de travails), ses réalisations proposés et sa zone d’intervention.
 
Responsabilité

L’Utilisateur est seul responsable de son accès à internet et de tout équipement nécessaire à l’accès et à l’utilisation du Site. Il revient à l’Utilisateur de prendre toutes les précautions nécessaires afin que son système informatique et ses propres données soient protégées de toute contamination par d’éventuels virus ou de tentatives d’intrusions dans son système. L’Utilisateur s’engage à communiquer des informations exactes et sincères. En cas de manquement à cette disposition, Cake Away se réserve la possibilité de supprimer le Compte de l’utilisateur concerné.

Cake Away n’exerce notamment pas de contrôle de manière systématique et n’assume aucune responsabilité en rapport avec les informations communiquées  et ne serait être tenue responsable d’informations inexactes. L’utilisateur est seul responsable des réalisations ou des ateliers pâtisseries qu’il prépare ou qu’il réalise et des conséquences dommageables pouvant en résulter notamment en cas d’intoxication alimentaire ou inadéquation de la prestation  réalisé  présenté sur l’application.

Cake Away ne peut être tenue responsable d’un dommage et/ou de toute perte de données résultant de l’utilisation du Site par l’Utilisateur. En outre, Cake Away ne peut être tenue responsable de tout dysfonctionnement du réseau ou des serveurs ou de tout autre événement échappant à son contrôle, qui empêcherait ou dégraderait l’accès au Site. Cake Away n’est pas partie au contrat de Prestation. Prestations qui sont réalisées directement et sous leur entière responsabilité. Cake Away ne s’expose à aucune responsabilité en relation avec les pourparlers, la conclusion puis l’exécution des Prestations des Chefs. Cake Away n’exerce notamment pas de contrôle de manière systématique et n’assume aucune responsabilité en rapport avec les informations communiquées par les utilisateurs et ne serait être tenue responsable d’informations inexactes. Par ailleurs, Cake Away ne peut être tenue responsable de l’exactitude de toute information relative à l’identification des Utilisateurs et ne garantit pas la solvabilité des Utilisateurs.
 
Propriété intellectuelle

Cake Away reste titulaire de tous les droits de propriété intellectuelle relatifs au Site, son contenu et de façon générale tous les éléments le constituant. L’accès et l’utilisation du Site ne confère aucun droit sur les droits de propriété intellectuelle relatifs au Site, son contenu et tous les éléments le constituant, qui restent la propriété exclusive de Cake Away. Cake Away est une marque déposée. L’utilisation de cette marque est interdite sans autorisation préalable et écrite de son titulaire. Seule Cake Away peut autoriser la reproduction de l’un des éléments du Site lui appartenant. L’Utilisateur s’engage notamment, de manière non exhaustive, à ne pas reproduire, modifier, transmettre, publier, adapter, sur quelque support que ce soit, tout ou partie du Site ou de tout élément le constituant sans l’autorisation expresse de Cake Away. Le non-respect de ces dispositions constituerait une contrefaçon.
 
Fichier nominatif

Les utilisateurs et utilisateurs se déclarent informés que les données les concernant et qu’ils renseignent sur le Site Cake Away.com sont conservées sous la forme d’un fichier nominatif. Ils donnent à Cake Away l’autorisation de constituer ce fichier et de l’exploiter d ans les termes et conditions de la règlementation applicable. Les Utilisateurs pourront s’opposer à la divulgation de leurs coordonnées en le signalant à Cake Away. De même, les Utilisateurs disposent d’un droit d’accès et de rectification des données les concernant, conformément à la loi du 6 janvier 1978.
                    
                    """),
                  ),

                  // Image.asset(
                  //   "assets/logos/terms.png",
                  // ),
                ),
              ),
              Expanded(
                flex: 0,
                child: _buildNextBtn(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      color: Colors.black,
      width: double.infinity,
      child: ElevatedButton(
        style: kButtonStyle,
        onPressed: callback,
        child: Text(
          'I Agree',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
