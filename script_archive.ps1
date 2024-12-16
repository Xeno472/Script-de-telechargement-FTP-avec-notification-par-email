# Paramètres
$ftpServer = "ftp://adresse_de_votre_serveur_FTP"  # Remplacez par l'adresse de votre serveur FTP
$ftpUsername = "nom_utilisateur_FTP"       # Nom d'utilisateur FTP
$ftpPassword = "mot_de_passe_FTP"          # Mot de passe FTP
$remoteFile = "nom_archive_a_telecharger"    # Nom de l'archive à récupérer
$localPath = "chemin_local_pour_enregistrer_archive"          # Chemin local pour enregistrer l'archive
$ftpUri = "$ftpServer/$remoteFile" # Résultat : ftp://192.168.2.3/home/ftpuser/ftp/files/var.tar.gz

# Paramètres pour l'envoi d'email
$smtpServer = "smtp.nom_de_votre_serveur_SMTP.com"  # Serveur SMTP
$smtpPort = 587                                    # Port SMTP
$emailFrom = "adresse_mail_expediteur"           # Adresse email de l'expéditeur
$emailPassword = "mot_de_passe_adresse_mail_expediteur"       # Mot de passe de l'expéditeur
$emailTo = "adresse_mail_administrateur"                   # Adresse email de l'administrateur
$emailSubject = "Confirmation : Récupération de l'archive var"

# Configuration des logs
$LogPath = "C:\Logs\FtpDownloadLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
New-Item -Path $LogPath -ItemType File -Force | Out-Null
Write-Host "[$(Get-Date)] Script démarré. Les logs sont enregistrés dans $LogPath" -ForegroundColor Yellow

# Fonction pour télécharger le fichier depuis le serveur FTP
Function Download-FTPFile {
    param (
        [string]$ftpUri,
        [string]$destinationPath,
        [string]$username,
        [string]$password
    )

    try {
        Write-Host "[$(Get-Date)] Connexion au serveur FTP..." -ForegroundColor Cyan
        Write-Host "[$(Get-Date)] Tentative de téléchargement de $ftpUri..." -ForegroundColor Yellow

        # Création de la requête FTP
        $ftpRequest = [System.Net.FtpWebRequest]::Create($ftpUri)
        $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
        $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($username, $password)

        # Ajouter un Timeout à la requête
        $ftpRequest.Timeout = 300000
        $ftpRequest.ReadWriteTimeout = 300000

        # Téléchargement du fichier
        Write-Host "[$(Get-Date)] Début du téléchargement..." -ForegroundColor Cyan
        $ftpResponse = $ftpRequest.GetResponse()
        $responseStream = $ftpResponse.GetResponseStream()

        # Écriture du fichier local
        $fileStream = New-Object IO.FileStream ($destinationPath, [IO.FileMode]::Create)
        $buffer = New-Object byte[] 1024
        do {
            $readBytes = $responseStream.Read($buffer, 0, $buffer.Length)
            $fileStream.Write($buffer, 0, $readBytes)
        } while ($readBytes -gt 0)

        $responseStream.Close()
        $fileStream.Close()
        $ftpResponse.Close()

        Write-Host "[$(Get-Date)] Téléchargement terminé avec succès." -ForegroundColor Green
        Add-Content -Path $LogPath -Value "$(Get-Date): Téléchargement réussi depuis $ftpUri"
        return $true
    }
    catch {
        Write-Host "[$(Get-Date)] Erreur lors du téléchargement : $_" -ForegroundColor Red
        Add-Content -Path $LogPath -Value "$(Get-Date): Erreur lors du téléchargement FTP: $_"
        return $false
    }
}

# Fonction pour envoyer un email
Function Send-Email {
    param (
        [string]$smtpServer,
        [int]$smtpPort,
        [string]$from,
        [string]$to,
        [string]$subject,
        [string]$body,
        [string]$password
    )

    try {
        Write-Host "[$(Get-Date)] Connexion au serveur SMTP..." -ForegroundColor Cyan

        $smtpClient = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
        $smtpClient.EnableSsl = $true
        $smtpClient.Credentials = New-Object System.Net.NetworkCredential($from, $password)

        $mailMessage = New-Object Net.Mail.MailMessage($from, $to, $subject, $body)

        Write-Host "[$(Get-Date)] Envoi de l'email en cours..." -ForegroundColor Cyan
        $smtpClient.Send($mailMessage)

        Write-Host "[$(Get-Date)] Email envoyé avec succès." -ForegroundColor Green
        Add-Content -Path $LogPath -Value "$(Get-Date): Email envoyé avec succès à $to"
    }
    catch {
        Write-Host "[$(Get-Date)] Erreur lors de l'envoi de l'email : $_" -ForegroundColor Red
        Add-Content -Path $LogPath -Value "$(Get-Date): Échec de l'envoi de l'email: $_"
    }
}

# Script principal
$ftpUri = "$ftpServer/$remoteFile"
try {
    Write-Host "[$(Get-Date)] Début du téléchargement de l'archive..." -ForegroundColor Cyan
    if (Download-FTPFile -ftpUri $ftpUri -destinationPath $localPath -username $ftpUsername -password $ftpPassword) {
        $emailBody = @"
Bonjour,

L'archive VAR.tar.gz a été récupérée avec succès depuis le serveur FTP.

Détails :
- Serveur : $ftpServer
- Chemin distant : $remoteFile
- Chemin local : $localPath

Cordialement,
Votre script FTP
"@
        Write-Host "[$(Get-Date)] Envoi de l'email de confirmation..." -ForegroundColor Cyan
        Send-Email -smtpServer $smtpServer -smtpPort $smtpPort -from $emailFrom -to $emailTo -subject $emailSubject -body $emailBody -password $emailPassword
    } else {
        throw "Le téléchargement du fichier a échoué."
    }
} catch {
    Write-Host "[$(Get-Date)] Gestion de l'erreur et préparation de l'email d'échec..." -ForegroundColor Red
    $emailBody = @"
Bonjour,

Une erreur s'est produite lors du téléchargement FTP.

Erreur : $_

Consultez les journaux pour plus de détails :
$LogPath

Cordialement,
Votre script FTP
"@
    Write-Host "[$(Get-Date)] Envoi de l'email d'échec..." -ForegroundColor Cyan
    Send-Email -smtpServer $smtpServer -smtpPort $smtpPort -from $emailFrom -to $emailTo -subject "$emailSubject - Échec" -body $emailBody -password $emailPassword
} finally {
    Write-Host "[$(Get-Date)] Script terminé. Consultez les logs pour plus d'informations." -ForegroundColor Cyan
}