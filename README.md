# Script de téléchargement FTP avec notification par email

Ce script PowerShell permet de télécharger un fichier depuis un serveur FTP et d'envoyer une notification par email en cas de succès ou d'échec. Les opérations sont également consignées dans un fichier journal pour une meilleure traçabilité.

## Fonctionnalités

- **Téléchargement FTP** : Connecte au serveur FTP et récupère le fichier spécifié.
- **Notification par email** : Envoie un email de confirmation ou d'échec à un destinataire spécifié.
- **Journalisation** : Crée un fichier journal pour chaque exécution contenant les détails du script.

## Prérequis

1. **PowerShell** : Vérifiez que PowerShell est installé sur votre système.
2. **Serveur FTP** : Assurez-vous que le serveur FTP est accessible et que vous disposez d'un compte avec les droits nécessaires.
3. **SMTP** : Configurez un serveur SMTP pour l'envoi des emails.

## Paramètres du script

### Paramètres FTP

| Paramètre      | Description                                   | Exemple                                      |
|----------------|-----------------------------------------------|----------------------------------------------|
| `$ftpServer`   | URL du serveur FTP                           | `ftp://192.168.2.3`                          |
| `$ftpUsername` | Nom d'utilisateur FTP                        | `ftpuser`                                    |
| `$ftpPassword` | Mot de passe FTP                             | `monMotDePasseFTP`                           |
| `$remoteFile`  | Chemin et nom du fichier sur le serveur FTP  | `home/ftpuser/ftp/files/var.tar.gz`          |
| `$localPath`   | Emplacement pour enregistrer le fichier local| `C:\Archives\var.tar.gz`                              |

### Paramètres SMTP

| Paramètre      | Description                                   | Exemple                                      |
|----------------|-----------------------------------------------|----------------------------------------------|
| `$smtpServer`  | Adresse du serveur SMTP                      | `smtp.gmail.com`                             |
| `$smtpPort`    | Port du serveur SMTP                         | `587`                                        |
| `$emailFrom`   | Adresse email de l'expéditeur                | `expediteur@example.com`                     |
| `$emailPassword` | Mot de passe pour l'adresse de l'expéditeur| `monMotDePasseSMTP`                          |
| `$emailTo`     | Adresse email du destinataire                | `destinataire@example.com`                   |
| `$emailSubject`| Sujet de l'email                             | `Confirmation : Téléchargement de l'archive`|

### Configuration des journaux

| Paramètre      | Description                                   | Exemple                                      |
|----------------|-----------------------------------------------|----------------------------------------------|
| `$LogPath`     | Chemin où les journaux seront enregistrés     | `C:\Logs\FtpDownloadLog_YYYYMMDD_HHMMSS.log`|

## Instructions d'utilisation

1. **Configurer le script** : Remplacez les valeurs des paramètres dans le script par vos informations (serveur FTP, SMTP, chemins des fichiers).
2. **Exécuter le script** : Lancez le script depuis PowerShell.
3. **Vérifier les journaux** : Consultez le fichier journal généré pour suivre l'exécution.

## Exemple d'utilisation

### En cas de succès

Le script téléchargera le fichier depuis le serveur FTP et enverra un email de confirmation :

**Sortie PowerShell** :

[2024-12-16 12:00:00] Script démarré. Les logs sont enregistrés dans C:\Logs\FtpDownloadLog_20241216_120000.log 
[2024-12-16 12:00:01] Connexion au serveur FTP... 
[2024-12-16 12:00:02] Téléchargement terminé avec succès. 
[2024-12-16 12:00:03] Envoi de l'email de confirmation... 
[2024-12-16 12:00:04] Email envoyé avec succès. 
[2024-12-16 12:00:05] Script terminé. Consultez les logs pour plus d'informations.

**Extrait du journal** :

2024-12-16 12:00:02: Téléchargement réussi depuis ftp://192.168.2.3/home/ftpuser/ftp/files/var.tar.gz 
2024-12-16 12:00:04: Email envoyé avec succès à destinataire@example.com

### En cas d'échec

Si le téléchargement échoue ou si l'email ne peut pas être envoyé, une erreur sera consignée.

**Sortie PowerShell** :

[2024-12-16 12:00:00] Script démarré. Les logs sont enregistrés dans C:\Logs\FtpDownloadLog_20241216_120000.log 
[2024-12-16 12:00:01] Connexion au serveur FTP... 
[2024-12-16 12:00:02] Erreur lors du téléchargement : Exception : Fichier introuvable. 
[2024-12-16 12:00:03] Envoi de l'email d'échec... 
[2024-12-16 12:00:04] Email envoyé avec succès. 
[2024-12-16 12:00:05] Script terminé. Consultez les logs pour plus d'informations.

**Extrait du journal** :

2024-12-16 12:00:02: Erreur lors du téléchargement FTP : Exception : Fichier introuvable. 
2024-12-16 12:00:04: Email envoyé avec succès à destinataire@example.com

## Améliorations possibles

- **Support des serveurs FTP sécurisés (FTPS/SFTP)**.
- **Ajout de tests unitaires pour vérifier la connectivité avant le téléchargement.**
- **Paramètres en ligne de commande pour une utilisation plus flexible.**

## Contributions

Les contributions sont les bienvenues. Si vous trouvez un bug ou souhaitez proposer une amélioration, ouvrez une issue ou une pull request sur ce dépôt.
