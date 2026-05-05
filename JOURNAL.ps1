<#
.SYNOPSIS
    Configuration avancee des journaux d'evenements Windows avec securite et audit.
.DESCRIPTION
    Sauvegarde la configuration precedente, applique les changements en arriere-plan,
    journalise les actions et verifie l'espace disque avant l'application.
#>

# --- 1. Verif Admin ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show('Ce script doit etre execute en tant qu Administrateur.',
        'Erreur de droits',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error)
    exit 1
}

# --- 2. Imports ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.ComponentModel

# --- 3. Couleurs UI ---
$bg       = [System.Drawing.ColorTranslator]::FromHtml('#1e1e2e')
$surface  = [System.Drawing.ColorTranslator]::FromHtml('#2a2a3e')
$surface2 = [System.Drawing.ColorTranslator]::FromHtml('#33334d')
$text     = [System.Drawing.ColorTranslator]::FromHtml('#cdd6f4')
$accent   = [System.Drawing.ColorTranslator]::FromHtml('#89b4fa')
$green    = [System.Drawing.ColorTranslator]::FromHtml('#a6e3a1')
$redc     = [System.Drawing.ColorTranslator]::FromHtml('#f38ba8')
$orange   = [System.Drawing.ColorTranslator]::FromHtml('#fab387')
$border   = [System.Drawing.ColorTranslator]::FromHtml('#45475a')
$headerBg = [System.Drawing.ColorTranslator]::FromHtml('#3b3b5c')

# --- 4. Chemins ---
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$configFile = Join-Path $scriptDir 'config_path.txt'
$auditFile   = Join-Path $scriptDir ('audit_' + (Get-Date -Format 'yyyy-MM-dd_HH-mm') + '.log')
$backupFile  = Join-Path $scriptDir ('backup_' + (Get-Date -Format 'yyyy-MM-dd_HH-mm') + '.json')

# --- 5. Persistance chemin ---
$savedPath = "E:\EVT"
if (Test-Path $configFile) {
    $savedPath = (Get-Content $configFile -Raw).Trim()
    if ([string]::IsNullOrWhiteSpace($savedPath)) { $savedPath = "E:\EVT" }
}

# --- 6. Formulaire ---
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Journaux d Evenements Windows - Admin'
$form.Size = New-Object System.Drawing.Size(820, 690)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.BackColor = $bg
$form.ForeColor = $text
$form.Font = New-Object System.Drawing.Font('Segoe UI', 9)

# --- 7. Header ---
$panelH = New-Object System.Windows.Forms.Panel
$panelH.Dock = 'Top'
$panelH.Height = 48
$panelH.BackColor = $surface

$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = 'Configuration Avancee des Journaux d Evenements'
$lblTitle.Font = New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = $accent
$lblTitle.AutoSize = $true
$lblTitle.Location = New-Object System.Drawing.Point(16, 12)
$panelH.Controls.Add($lblTitle)

# --- 8. Chemin destination ---
$lblP = New-Object System.Windows.Forms.Label
$lblP.Text = 'Dossier de destination :'
$lblP.Location = New-Object System.Drawing.Point(20, 60)
$lblP.AutoSize = $true
$lblP.ForeColor = $text

$txtPath = New-Object System.Windows.Forms.TextBox
$txtPath.Text = $savedPath
$txtPath.Location = New-Object System.Drawing.Point(20, 82)
$txtPath.Size = New-Object System.Drawing.Size(510, 24)
$txtPath.BackColor = $surface2
$txtPath.ForeColor = $text
$txtPath.BorderStyle = 'FixedSingle'
$txtPath.Font = New-Object System.Drawing.Font('Consolas', 9)

$btnBr = New-Object System.Windows.Forms.Button
$btnBr.Text = '...'
$btnBr.Location = New-Object System.Drawing.Point(540, 80)
$btnBr.Size = New-Object System.Drawing.Size(36, 24)
$btnBr.BackColor = $surface2
$btnBr.ForeColor = $text
$btnBr.FlatStyle = 'Flat'
$btnBr.FlatAppearance.BorderColor = $border

$folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$btnBr.Add_Click({
    if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtPath.Text = $folderDialog.SelectedPath
    }
})

# Label grille
$lblGH = New-Object System.Windows.Forms.Label
$lblGH.Text = 'Journaux a configurer :'
$lblGH.Location = New-Object System.Drawing.Point(20, 118)
$lblGH.AutoSize = $true
$lblGH.ForeColor = $accent
$lblGH.Font = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Bold)

$lblCount = New-Object System.Windows.Forms.Label
$lblCount.Text = 'Chargement...'
$lblCount.Location = New-Object System.Drawing.Point(690, 118)
$lblCount.AutoSize = $true
$lblCount.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#6c7086')

# --- 9. Grille ---
$dgv = New-Object System.Windows.Forms.DataGridView
$dgv.Location = New-Object System.Drawing.Point(20, 142)
$dgv.Size = New-Object System.Drawing.Size(765, 200)
$dgv.AllowUserToAddRows = $false
$dgv.AllowUserToDeleteRows = $false
$dgv.AllowUserToResizeRows = $false
$dgv.ReadOnly = $false
$dgv.RowHeadersVisible = $false
$dgv.SelectionMode = 'FullRowSelect'
$dgv.BackgroundColor = $surface
$dgv.ForeColor = $text
$dgv.GridColor = $border
$dgv.BorderStyle = 'None'
$dgv.CellBorderStyle = 'SingleHorizontal'
$dgv.RowTemplate.Height = 28
$dgv.Font = New-Object System.Drawing.Font('Segoe UI', 9)
$dgv.AlternatingRowsDefaultCellStyle.BackColor = [System.Drawing.ColorTranslator]::FromHtml('#252538')
$dgv.RowsDefaultCellStyle.BackColor = $surface
$dgv.RowsDefaultCellStyle.ForeColor = $text
$dgv.ColumnHeadersDefaultCellStyle.BackColor = $headerBg
$dgv.ColumnHeadersDefaultCellStyle.ForeColor = $accent
$dgv.ColumnHeadersDefaultCellStyle.Font = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Bold)
$dgv.ColumnHeadersHeight = 32
$dgv.ColumnHeadersHeightSizeMode = 'DisableResizing'
$dgv.EnableHeadersVisualStyles = $false
$dgv.AutoSizeColumnsMode = 'Fill'

# Colonnes
$colActive = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
$colActive.HeaderText = 'Actif'
$colActive.Name = 'Active'
$colActive.FillWeight = 5

$colName = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colName.HeaderText = 'Journal'
$colName.Name = 'Journal'
$colName.ReadOnly = $true
$colName.FillWeight = 20

$colPath = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colPath.HeaderText = 'Emplacement actuel'
$colPath.Name = 'CurrentPath'
$colPath.ReadOnly = $true
$colPath.FillWeight = 35

$colSize = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colSize.HeaderText = 'Taille (Mo)'
$colSize.Name = 'TailleMo'
$colSize.FillWeight = 15

$colMode = New-Object System.Windows.Forms.DataGridViewComboBoxColumn
$colMode.HeaderText = 'Mode'
$colMode.Name = 'Mode'
[void]$colMode.Items.AddRange('Circular', 'AutoBackup', 'OverwriteAsNeeded')
$colMode.FillWeight = 18

[void]$dgv.Columns.Add($colActive)
[void]$dgv.Columns.Add($colName)
[void]$dgv.Columns.Add($colPath)
[void]$dgv.Columns.Add($colSize)
[void]$dgv.Columns.Add($colMode)

# Validation en temps reel
$dgv.Add_CellValueChanged({
    param($sender, $e)
    if ($e.RowIndex -lt 0 -or $dgv.Rows[$e.RowIndex].IsNewRow) { return }
    if ($e.ColumnIndex -eq $dgv.Columns['TailleMo'].Index) {
        $val = $dgv.Rows[$e.RowIndex].Cells['TailleMo'].Value
        if ($val -match '^\d+$' -and [int]$val -gt 0) {
            $dgv.Rows[$e.RowIndex].Cells['TailleMo'].Style.BackColor = [System.Drawing.Color]::Transparent
        } else {
            $dgv.Rows[$e.RowIndex].Cells['TailleMo'].Style.BackColor = $orange
        }
    }
})

# Tooltips detailles
$toolTip = New-Object System.Windows.Forms.ToolTip
$toolTip.SetToolTip($dgv, "Mode Circular : ecrase les anciens logs`nMode AutoBackup : archive le log plein`nMode OverwriteAsNeeded : ecrase sans archive")

# Chargement des donnees actuelles
$targetLogs = @('Application', 'System', 'Security', 'Setup', 'ForwardedEvents')
foreach ($logName in $targetLogs) {
    try {
        $logObj = Get-WinEvent -ListLog $logName -ErrorAction Stop
        $sizeMB = [math]::Ceiling($logObj.MaximumSizeInBytes / 1MB)
        [void]$dgv.Rows.Add($true, $logName, $logObj.LogFilePath, $sizeMB, $logObj.LogMode.ToString())
    } catch {
        [void]$dgv.Rows.Add($true, $logName, 'N/A', 20, 'Circular')
    }
}
$lblCount.Text = "$($targetLogs.Count) journaux charges"

# --- 10. Boutons selection ---
$flowSel = New-Object System.Windows.Forms.FlowLayoutPanel
$flowSel.Location = New-Object System.Drawing.Point(20, 355)
$flowSel.Size = New-Object System.Drawing.Size(765, 30)
$flowSel.FlowDirection = 'LeftToRight'
$flowSel.BackColor = $bg

$btnAll = New-Object System.Windows.Forms.Button
$btnAll.Text = 'Tout cocher'
$btnAll.AutoSize = $true
$btnAll.Padding = New-Object System.Windows.Forms.Padding(10, 4, 10, 4)
$btnAll.BackColor = $surface2
$btnAll.ForeColor = $text
$btnAll.FlatStyle = 'Flat'
$btnAll.FlatAppearance.BorderColor = $border
$btnAll.Add_Click({ foreach ($r in $dgv.Rows) { $r.Cells['Active'].Value = $true } })

$btnNone = New-Object System.Windows.Forms.Button
$btnNone.Text = 'Tout decocher'
$btnNone.AutoSize = $true
$btnNone.Padding = New-Object System.Windows.Forms.Padding(10, 4, 10, 4)
$btnNone.BackColor = $surface2
$btnNone.ForeColor = $text
$btnNone.FlatStyle = 'Flat'
$btnNone.FlatAppearance.BorderColor = $border
$btnNone.Add_Click({ foreach ($r in $dgv.Rows) { $r.Cells['Active'].Value = $false } })

$flowSel.Controls.Add($btnAll)
$flowSel.Controls.Add($btnNone)

# --- 11. ProgressBar ---
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 395)
$progressBar.Size = New-Object System.Drawing.Size(765, 10)
$progressBar.Visible = $false
$progressBar.ForeColor = $green
$progressBar.BackColor = $surface2

# --- 12. Boutons Actions ---
$flowAct = New-Object System.Windows.Forms.FlowLayoutPanel
$flowAct.Location = New-Object System.Drawing.Point(20, 415)
$flowAct.Size = New-Object System.Drawing.Size(765, 36)
$flowAct.FlowDirection = 'LeftToRight'
$flowAct.BackColor = $bg

$btnApply = New-Object System.Windows.Forms.Button
$btnApply.Text = 'Appliquer la configuration'
$btnApply.AutoSize = $true
$btnApply.Padding = New-Object System.Windows.Forms.Padding(16, 6, 16, 6)
$btnApply.BackColor = $green
$btnApply.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#11111b')
$btnApply.FlatStyle = 'Flat'
$btnApply.Font = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Bold)
$btnApply.Cursor = 'Hand'

$btnRes = New-Object System.Windows.Forms.Button
$btnRes.Text = 'Valeurs par defaut'
$btnRes.AutoSize = $true
$btnRes.Padding = New-Object System.Windows.Forms.Padding(12, 6, 12, 6)
$btnRes.BackColor = $orange
$btnRes.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#11111b')
$btnRes.FlatStyle = 'Flat'
$btnRes.Font = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Bold)
$btnRes.Cursor = 'Hand'
$btnRes.Add_Click({
    foreach ($row in $dgv.Rows) {
        switch ($row.Cells['Journal'].Value) {
            'Security'   { $row.Cells['TailleMo'].Value = 128 }
            'Setup'      { $row.Cells['TailleMo'].Value = 32 }
            'ForwardedEvents' { $row.Cells['TailleMo'].Value = 32 }
            default      { $row.Cells['TailleMo'].Value = 20 }
        }
        $row.Cells['Mode'].Value = 'Circular'
    }
})

$flowAct.Controls.Add($btnApply)
$flowAct.Controls.Add($btnRes)

# --- 13. Output ---
$txtOutput = New-Object System.Windows.Forms.RichTextBox
$txtOutput.Location = New-Object System.Drawing.Point(20, 462)
$txtOutput.Size = New-Object System.Drawing.Size(765, 160)
$txtOutput.ReadOnly = $true
$txtOutput.BackColor = $surface
$txtOutput.ForeColor = $text
$txtOutput.Font = New-Object System.Drawing.Font('Consolas', 9)
$txtOutput.BorderStyle = 'None'

# --- 14. Ajout form ---
$form.Controls.Add($panelH)
$form.Controls.Add($lblP)
$form.Controls.Add($txtPath)
$form.Controls.Add($btnBr)
$form.Controls.Add($lblGH)
$form.Controls.Add($lblCount)
$form.Controls.Add($dgv)
$form.Controls.Add($flowSel)
$form.Controls.Add($progressBar)
$form.Controls.Add($flowAct)
$form.Controls.Add($txtOutput)

# --- 15. Fonctions utilitaires ---
function Write-Log {
    param($msg, $col = $text)
    $txtOutput.SelectionStart = $txtOutput.TextLength
    $txtOutput.SelectionColor = $col
    $txtOutput.AppendText("$msg`r`n")
    $txtOutput.ScrollToCaret()
}

function Write-Audit {
    param($msg)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line = "$timestamp | $msg"
    Add-Content -Path $auditFile -Value $line -Encoding UTF8
}

function Restore-Backup {
    param($backupPath)
    
    if (-not (Test-Path $backupPath)) {
        Write-Log "Aucun fichier de sauvegarde trouvé." $redc
        return $false
    }
    
    try {
        $backup = Get-Content $backupPath -Raw | ConvertFrom-Json
        $restored = 0
        $failed = 0
        
        Write-Log "Restauration de la configuration précédente..." $orange
        
        foreach ($entry in $backup) {
            $logName = $entry.Journal
            $size = $entry.Taille
            $mode = $entry.Mode
            
            # Mapping wevtutil pour rollback
            switch ($mode) {
                'Circular' { $rt = 'false'; $ab = $false }
                'AutoBackup' { $rt = 'true'; $ab = $true }
                'OverwriteAsNeeded' { $rt = 'false'; $ab = $false }
            }
            
            $bytes = [int]$size * 1MB
            $currentPath = $entry.CurrentPath
            if ([string]::IsNullOrEmpty($currentPath)) {
                $currentPath = $env:SystemDrive + '\EVT\' + $logName + '.evtx'
            }
            
            $cmdArgs = @('sl', $logName, "/lf:`"$currentPath`"", "/ms:$bytes", "/rt:$rt")
            if ($ab) { $cmdArgs += '/ab:true' }
            
            $proc = Start-Process wevtutil -ArgumentList $cmdArgs -Wait -PassThru
            if ($proc.ExitCode -eq 0) {
                $restored++
                Write-Log "  ✓ $logName restauré" $green
            } else {
                $failed++
                Write-Log "  ✗ $logName échec (code $($proc.ExitCode))" $redc
            }
        }
        
        Write-Log "Rollback terminé : $restored restaurés, $failed échecs" $(if ($failed -eq 0) { $green } else { $orange })
        Write-Audit "Rollback effectué : $restored restaurés, $failed échecs"
        return ($failed -eq 0)
    }
    catch {
        Write-Log "ERREUR lors du rollback : $($_.Exception.Message)" $redc
        Write-Audit "ERREUR rollback : $($_.Exception.Message)"
        return $false
    }
}

# --- 16. BackgroundWorker (async) ---
$bgWorker = New-Object System.ComponentModel.BackgroundWorker
$bgWorker.WorkerReportsProgress       = $true
$bgWorker.WorkerSupportsCancellation = $true

# Preparer les donnees a traiter
$bgWorker.Add_DoWork({
    param($sender, $e)
    $data     = $e.Argument
    $path     = $data.Path
    $settings = $data.Settings
    $total    = $settings.Count
    $results  = @()

    # 1. Creation du dossier si besoin
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }

    # 2. Droits SYSTEM et EventLog
    $acl   = Get-Acl $path
    $rule  = New-Object System.Security.AccessControl.FileSystemAccessRule('SYSTEM', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
    $acl.SetAccessRule($rule)
    try {
        $ruleEvt = New-Object System.Security.AccessControl.FileSystemAccessRule('NT SERVICE\EventLog', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
        $acl.AddAccessRule($ruleEvt)
    } catch {}
    Set-Acl $path $acl

    # 3. Application des changements
    foreach ($setting in $settings) {
        $logName = $setting.Name
        $size    = $setting.Size
        $mode    = $setting.Mode

        # Mapping wevtutil
        switch ($mode) {
            'Circular'          { $rt = 'false'; $ab = $false }
            'AutoBackup'        { $rt = 'true';  $ab = $true }
            'OverwriteAsNeeded' { $rt = 'false'; $ab = $false }
        }
        $bytes      = [int]$size * 1MB
        $evtxPath   = Join-Path $path "$logName.evtx"

        $cmdArgs = @('sl', $logName)
        $cmdArgs += "/lf:`"$evtxPath`""
        $cmdArgs += "/ms:$bytes"
        $cmdArgs += "/rt:$rt"
        if ($ab) { $cmdArgs += '/ab:true' }

        # Execution via Start-Process pour capturer la sortie
        $proc = Start-Process wevtutil -ArgumentList $cmdArgs -Wait -PassThru -RedirectStandardError (Join-Path $env:TEMP "wevt_err_$logName.txt")
        $exitCode = $proc.ExitCode

        $results += [PSCustomObject]@{
            Name   = $logName
            Size   = $size
            Mode   = $mode
            Status = if ($exitCode -eq 0) { 'OK' } else { "ERREUR $exitCode" }
            ExitCode = $exitCode
        }

        $progress = [math]::Floor(($results.Count / $total) * 100)
        $sender.ReportProgress($progress, "$logName | $size Mo | $mode")

        $errFile = Join-Path $env:TEMP "wevt_err_$logName.txt"
        if (Test-Path $errFile) { Remove-Item $errFile -Force -ErrorAction SilentlyContinue }
    }

    $e.Result = $results
})

$bgWorker.Add_ProgressChanged({
    param($sender, $e)
    $progressBar.Value = $e.ProgressPercentage
    Write-Log $e.UserState.ToString() $green
})

$bgWorker.Add_RunWorkerCompleted({
    param($sender, $e)
    $progressBar.Visible = $false
    $btnApply.Enabled     = $true
    $btnRes.Enabled      = $true

    if ($e.Error) {
        Write-Log "ERREUR CRITIQUE : $($e.Error.Message)" $redc
        [System.Windows.Forms.MessageBox]::Show("Une erreur est survenue : $($e.Error.Message)", 'Erreur', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    } elseif ($e.Cancelled) {
        Write-Log "Operation annulee." $orange
    } else {
        $results = $e.Result
        Write-Log "-----------------------------------------------"
        $successful = ($results | Where-Object { $_.Status -eq 'OK' }).Count
        $failed = ($results | Where-Object { $_.Status -ne 'OK' }).Count
        $total = $results.Count
        
        Write-Log "Configuration terminee : $successful OK, $failed echecs" $(if ($failed -eq 0) { $green } else { $orange })
        Write-Audit "Configuration appliquée avec $($successful) succes et $($failed) echecs."

        # Sauvegarder le chemin
        $txtPath.Text | Out-File $configFile -Encoding UTF8

        # ROLLBACK AUTOMATIQUE si échec partiel ou total
        if ($failed -gt 0) {
            $failureRate = [math]::Round(($failed / $total) * 100)
            Write-Log "Taux d'échec : $failureRate%" $orange
            
            # Si plus de 50% d'échecs, rollback automatique
            if ($failureRate -ge 50) {
                Write-Log "!!! Échec critique (>50%) - Déclenchement du ROLLBACK automatique..." $redc
                Write-Audit "ROLLBACK AUTOMATIQUE déclenché (taux échec: $failureRate%)"
                
                $rollbackSuccess = Restore-Backup $backupFile
                
                if ($rollbackSuccess) {
                    [System.Windows.Forms.MessageBox]::Show(
                        "La configuration a échoué ($failed/$total).`n`nLe ROLLBACK a été effectué avec succès.`nVos anciens paramètres ont été restaurés.",
                        'Rollback effectué',
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Warning
                    ) | Out-Null
                } else {
                    [System.Windows.Forms.MessageBox]::Show(
                        "La configuration a échoué ($failed/$total).`n`nATTENTION : Le ROLLBACK a également échoué !`nVérifiez le fichier de backup : $backupFile",
                        'Erreur critique',
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Error
                    ) | Out-Null
                }
            } else {
                # Moins de 50% d'échecs - simple avertissement
                [System.Windows.Forms.MessageBox]::Show(
                    "Certains journaux n'ont pas ete configures ($failed/$total).`n`nConsultez l'output pour les details.",
                    'Avertissement',
                    [System.Windows.Forms.MessageBoxButtons]::OK,
                    [System.Windows.Forms.MessageBoxIcon]::Warning
                ) | Out-Null
            }
        } else {
            # Succès total
            Write-Log "Operation reussie avec succes !" $green
            Write-Audit "Operation réussie - 100% de succès"
        }
    }
})

# --- 17. Evenement Appliquer ---
$btnApply.Add_Click({
    # Confirmation
    $confirm = [System.Windows.Forms.MessageBox]::Show(
        "Voulez-vous vraiment appliquer ces changements ?`nCela modifiera la configuration des journaux systeme.",
        'Confirmation',
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question)
    if ($confirm -eq 'No') { return }

    # Recuperer les donnees de la grille
    $settings = @(
        foreach ($row in $dgv.Rows) {
            if ($row.Cells['Active'].Value -eq $true) {
                [PSCustomObject]@{
                    Name = $row.Cells['Journal'].Value
                    Size = $row.Cells['TailleMo'].Value
                    Mode = $row.Cells['Mode'].Value
                }
            }
        }
    )

    if ($settings.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show('Aucun journal selectionne. Cochez au moins un element.', 'Attention', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
        return
    }

    $path = $txtPath.Text.Trim()
    if (-not $path) {
        [System.Windows.Forms.MessageBox]::Show('Chemin de destination vide.', 'Erreur', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
        return
    }

    # Verification de l'espace disque
    $totalSizeMB = ($settings.Size | Measure-Object -Sum).Sum
    try {
        $driveLetter = (Split-Path $path -Qualifier).TrimEnd(':')
        if ([string]::IsNullOrEmpty($driveLetter)) { $driveLetter = $env:SystemDrive.TrimEnd(':') }
        $psDrive = Get-PSDrive -Name $driveLetter -ErrorAction Stop
        $availableGB = [math]::Round($psDrive.Free / 1GB, 2)
        $requiredGB  = [math]::Round(($totalSizeMB * 1MB) / 1GB, 2)
        Write-Log "Espace disque disponible : $availableGB Go | Requis : $requiredGB Go"
        if ($psDrive.Free -lt ($totalSizeMB * 1MB)) {
            [System.Windows.Forms.MessageBox]::Show("Espace insuffisant sur le disque destination. Disponible : $availableGB Go, Requis : $requiredGB Go", 'Erreur', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
            return
        }
    } catch {
        Write-Log "Impossible de verifier l'espace disque. Poursuite..." $orange
    }

    # Sauvegarde de la configuration actuelle (simple)
    $backupData = @()
    foreach ($row in $dgv.Rows) {
        $backupData += [PSCustomObject]@{
            Journal = $row.Cells['Journal'].Value
            CurrentPath = $row.Cells['CurrentPath'].Value
            Taille = $row.Cells['TailleMo'].Value
            Mode   = $row.Cells['Mode'].Value
        }
    }
    $backupData | ConvertTo-Json -Depth 3 | Out-File $backupFile -Encoding UTF8
    Write-Log "Sauvegarde creee : $backupFile"
    Write-Audit "Sauvegarde de la configuration precedente dans $backupFile"

    # Lancer le travail en arriere-plan
    $txtOutput.Clear()
    $progressBar.Visible = $true
    $progressBar.Value    = 0
    $btnApply.Enabled     = $false
    $btnRes.Enabled      = $false
    Write-Log "Demarrage de l'application en arriere-plan..."
    Write-Audit "Demarrage de l'application des configurations pour les journaux : $($settings.Name -join ', ')"

    $bgWorker.RunWorkerAsync(@{ Path = $path; Settings = $settings })
})

# --- 18. Lancement ---
[System.Windows.Forms.Application]::EnableVisualStyles()
$form.ShowDialog() | Out-Null