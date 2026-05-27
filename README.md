# WinLog-Optimizer

**WinLog-Optimizer** est un script PowerShell avancé conçu pour configurer et optimiser facilement l'emplacement, la taille et les modes de rétention des journaux d'événements Windows.

Il propose une interface utilisateur graphique moderne (GUI) en WinForms ainsi qu'un mode ligne de commande (CLI) pour une automatisation complète.

---

## Fonctionnalités / Features

- **Double Mode** : Interface Graphique (GUI) interactive ou Mode Ligne de Commande (CLI).
- **Multi-langue** : Support complet du Français (FR) et de l'Anglais (EN).
- **Sécurité & Rollback** :
  - Sauvegarde automatique de la configuration existante avant modification.
  - Rollback automatique en cas d'erreur ou d'échec d'application sur un journal.
- **Vérifications préalables** :
  - Vérification des droits administrateur requis.
  - Vérification de l'espace disque disponible avant déplacement.
  - Validation NTFS en écriture sur le dossier cible.
- **Gestion intelligente** :
  - Nettoyage automatique des anciens fichiers de sauvegarde et d'audit de plus de 30 jours au démarrage.
  - Scan de tous les journaux d'événements actifs sur le serveur.
  - Filtre de recherche en temps réel sur la liste des journaux.

---

## Utilisation / Usage

> [!IMPORTANT]
> Le script doit être exécuté avec des privilèges d'administrateur.

### 1. Mode Interface Graphique (GUI)

Pour lancer l'interface graphique interactive, exécutez simplement le script sans paramètres :

```powershell
.\WinLog-Optimizer.ps1
```

### 2. Mode Ligne de Commande (CLI)

Utilisez le paramètre `-NoGui` pour exécuter le script en ligne de commande.

#### Paramètres disponibles :
- `-NoGui` : Active le mode ligne de commande (pas d'interface graphique).
- `-Path` : Dossier de destination des fichiers `.evtx` (ex: `"D:\Logs"`).
- `-Size` : Taille maximale autorisée en Mo pour chaque journal (ex: `512`).
- `-Mode` : Mode de rétention (`Circular`, `AutoBackup`, `OverwriteAsNeeded`).
- `-Logs` : Journaux à modifier. Accepte un tableau de noms, `"Active"` (journaux de taille > 0), ou `"All"`.
- `-Language` : Choix de la langue (`FR` ou `EN`).
- `-Force` : Désactive les invites de confirmation et crée le dossier cible s'il n'existe pas.

#### Exemples CLI :

*Configuration par défaut (Application, System, Security, Setup à 200 Mo en Circular dans E:\EVT) :*
```powershell
.\WinLog-Optimizer.ps1 -NoGui -Force
```

*Configuration de tous les journaux actifs à 512 Mo en AutoBackup dans un dossier spécifique :*
```powershell
.\WinLog-Optimizer.ps1 -Path "D:\Logs" -Size 512 -Mode AutoBackup -Logs Active -NoGui -Force
```

*Configuration ciblée de Security et Application uniquement :*
```powershell
.\WinLog-Optimizer.ps1 -Logs "Security","Application" -Size 256 -NoGui -Force
```

---

## Prérequis / Prerequisites

- **OS** : Windows Server ou Windows Client.
- **Privilèges** : Administrateur local.
- **PowerShell** : PowerShell 5.1 ou version ultérieure.
