<#
.SYNOPSIS
    Configuration avancee des journaux d'evenements Windows avec multi-langue (FR/EN).
.DESCRIPTION
    Sauvegarde la configuration precedente, applique les changements en arriere-plan,
    journalise les actions et verifie l'espace disque.
#>

# --- 1. Dictionnaire International (i18n) ---
$i18n = @{
    FR = @{
        AppTitle        = "Journaux d'Evenements Windows - Admin"
        HeaderTitle     = "Configuration Avancee des Journaux"
        LblDest         = "Dossier de destination :"
        LblLogs         = "Journaux a configurer :"
        LblLoading      = "Chargement..."
        LblCount        = "{0} journaux charges"
        ColActive       = "Actif"
        ColJournal      = "Journal"
        ColPath         = "Emplacement actuel"
        ColSize         = "Taille (Mo)"
        ColMode         = "Mode"
        BtnAll          = "Tout cocher"
        BtnNone         = "Tout decocher"
        BtnApply        = "Appliquer la configuration"
        BtnDefault      = "Valeurs par defaut"
        BtnLang         = "Lang: FR 🇫🇷"
        ToolMode        = "Mode Circular : ecrase les anciens logs`nMode AutoBackup : archive le log plein`nMode OverwriteAsNeeded : ecrase sans archive"
        
        MsgAdminErr     = "Ce script doit etre execute en tant qu'Administrateur."
        MsgAdminTitle   = "Erreur de droits"
        MsgConfirmText  = "Voulez-vous vraiment appliquer ces changements ?`nCela modifiera la configuration des journaux systeme."
        MsgConfirmTitle = "Confirmation"
        MsgNoSelText    = "Aucun journal selectionne. Cochez au moins un element."
        MsgNoSelTitle   = "Attention"
        MsgSvcErrText   = "Le service 'Windows Event Log' est arrete ou introuvable. Impossible d'appliquer les changements."
        MsgSvcErrTitle  = "Erreur Service"
        MsgEmptyPath    = "Chemin de destination vide."
        MsgUncErr       = "Les chemins reseau (UNC) ne sont pas supportes pour le stockage des journaux actifs."
        MsgLocalErr     = "Veuillez specifier un chemin local valide (ex: E:\Logs)."
        MsgNtfsErr      = "Acces refuse au dossier ({0}). Verifiez les droits NTFS.`n`nDetail : {1}"
        MsgDiskErr      = "Espace insuffisant sur le disque destination. Disponible : {0} Go, Requis : {1} Go"
        MsgRbSuccess    = "La configuration a echoue ({0}/{1}).`n`nLe ROLLBACK a ete effectue avec succes.`nVos anciens parametres ont ete restaures."
        MsgRbFail       = "La configuration a echoue ({0}/{1}).`n`nATTENTION : Le ROLLBACK a egalement echoue !`nVerifiez le fichier de backup : {2}"
        MsgPartFail     = "Certains journaux n'ont pas pu etre configures : {0}.`n`nVoulez-vous restaurer leur configuration precedente uniquement ?"
        
        LogInit         = "Initialisation de l'interface..."
        LogAdminOk      = "Droits Administrateur verifies."
        LogAuditStart   = "Demarrage de l'application des configurations"
        LogBackup       = "Sauvegarde creee : {0}"
        LogDiskSpace    = "Espace disque disponible : {0} Go | Requis : {1} Go"
        LogBgStart      = "Demarrage de l'application en arriere-plan..."
        LogSuccess      = "Operation reussie avec succes !"
        LogRbStart      = "Restauration de la configuration precedente..."
        LogRbOk         = "  [OK] {0} restaure"
        LogRbFail       = "  [FAIL] {0} echec (code {1})"
        LogRbEnd        = "Rollback termine : {0} restaures, {1} echecs"
        LogFinished     = "Configuration terminee : {0} OK, {1} echecs"
        LogErrCrit      = "ERREUR CRITIQUE : {0}"
    }
    EN = @{
        AppTitle        = "Windows Event Logs - Admin"
        HeaderTitle     = "Advanced Event Log Configuration"
        LblDest         = "Destination Folder:"
        LblLogs         = "Logs to configure:"
        LblLoading      = "Loading..."
        LblCount        = "{0} logs loaded"
        ColActive       = "Active"
        ColJournal      = "Log"
        ColPath         = "Current Location"
        ColSize         = "Size (MB)"
        ColMode         = "Mode"
        BtnAll          = "Check All"
        BtnNone         = "Uncheck All"
        BtnApply        = "Apply Configuration"
        BtnDefault      = "Default Values"
        BtnLang         = "Lang: EN 🇺🇸"
        ToolMode        = "Circular Mode: overwrites old logs`nAutoBackup Mode: archives full logs`nOverwriteAsNeeded: overwrites without archive"
        
        MsgAdminErr     = "This script must be run as Administrator."
        MsgAdminTitle   = "Permission Error"
        MsgConfirmText  = "Do you really want to apply these changes?`nThis will modify the system logs configuration."
        MsgConfirmTitle = "Confirmation"
        MsgNoSelText    = "No log selected. Please check at least one item."
        MsgNoSelTitle   = "Warning"
        MsgSvcErrText   = "The 'Windows Event Log' service is stopped or missing. Cannot apply changes."
        MsgSvcErrTitle  = "Service Error"
        MsgEmptyPath    = "Destination path is empty."
        MsgUncErr       = "Network paths (UNC) are not supported for active log storage."
        MsgLocalErr     = "Please specify a valid local path (e.g., E:\Logs)."
        MsgNtfsErr      = "Access denied to folder ({0}). Check NTFS permissions.`n`nDetail: {1}"
        MsgDiskErr      = "Insufficient space on destination disk. Available: {0} GB, Required: {1} GB"
        MsgRbSuccess    = "Configuration failed ({0}/{1}).`n`nROLLBACK completed successfully.`nYour previous settings have been restored."
        MsgRbFail       = "Configuration failed ({0}/{1}).`n`nWARNING: ROLLBACK also failed!`nCheck backup file: {2}"
        MsgPartFail     = "Some logs could not be configured: {0}.`n`nDo you want to restore their previous configuration only?"
        
        LogInit         = "Initializing interface..."
        LogAdminOk      = "Administrator rights verified."
        LogAuditStart   = "Starting configuration application"
        LogBackup       = "Backup created: {0}"
        LogDiskSpace    = "Available disk space: {0} GB | Required: {1} GB"
        LogBgStart      = "Starting background application..."
        LogSuccess      = "Operation completed successfully!"
        LogRbStart      = "Restoring previous configuration..."
        LogRbOk         = "  [OK] {0} restored"
        LogRbFail       = "  [FAIL] {0} failed (code {1})"
        LogRbEnd        = "Rollback finished: {0} restored, {1} echecs"
        LogFinished     = "Configuration finished: {0} OK, {1} failed"
        LogErrCrit      = "CRITICAL ERROR: {0}"
    }
}

# Fonction de traduction
function T {
    param($key, $arg1 = $null, $arg2 = $null, $arg3 = $null)
    $text = $i18n[$currentLang][$key]
    if ($null -eq $text) { return $key }
    if ($null -ne $arg3) { return $text -f $arg1, $arg2, $arg3 }
    if ($null -ne $arg2) { return $text -f $arg1, $arg2 }
    if ($null -ne $arg1) { return $text -f $arg1 }
    return $text
}

# --- 2. Verif Admin ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show("Ce script doit etre execute en tant qu'Administrateur / This script must be run as Admin.", 'Admin Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    exit 1
}

# --- 3. Imports ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.ComponentModel

# --- 4. Couleurs UI ---
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

# --- 5. Chemins et Persistance ---
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$configFile = Join-Path $scriptDir 'config_path.txt'
$langFile   = Join-Path $scriptDir 'config_lang.txt'
$auditFile  = Join-Path $scriptDir ('audit_' + (Get-Date -Format 'yyyy-MM-dd_HH-mm') + '.log')
$backupFile = Join-Path $scriptDir ('backup_' + (Get-Date -Format 'yyyy-MM-dd_HH-mm') + '.json')

# Langue par defaut
$currentLang = "FR"
if (Test-Path $langFile) {
    $currentLang = (Get-Content $langFile -Raw).Trim().ToUpper()
    if ($currentLang -ne "FR" -and $currentLang -ne "EN") { $currentLang = "FR" }
}

$savedPath = "E:\EVT"
if (Test-Path $configFile) {
    $savedPath = (Get-Content $configFile -Raw).Trim()
    if ([string]::IsNullOrWhiteSpace($savedPath)) { $savedPath = "E:\EVT" }
}

# --- 6. Formulaire ---
$form = New-Object System.Windows.Forms.Form
$form.Text = T "AppTitle"
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
$lblTitle.Text = T "HeaderTitle"
$lblTitle.Font = New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = $accent
$lblTitle.AutoSize = $true
$lblTitle.Location = New-Object System.Drawing.Point(16, 12)
$panelH.Controls.Add($lblTitle)

# Bouton de langue
$btnLang = New-Object System.Windows.Forms.Button
$btnLang.Text = T "BtnLang"
$btnLang.Size = New-Object System.Drawing.Size(120, 28)
$btnLang.Location = New-Object System.Drawing.Point(670, 10)
$btnLang.BackColor = $surface2
$btnLang.ForeColor = $text
$btnLang.FlatStyle = 'Flat'
$btnLang.FlatAppearance.BorderColor = $accent
$btnLang.Cursor = 'Hand'

# --- 8. Chemin destination ---
$lblP = New-Object System.Windows.Forms.Label
$lblP.Text = T "LblDest"
$lblP.Location = New-Object System.Drawing.Point(20, 60)
$lblP.AutoSize = $true

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
$btnBr.FlatStyle = 'Flat'

# Label grille
$lblGH = New-Object System.Windows.Forms.Label
$lblGH.Text = T "LblLogs"
$lblGH.Location = New-Object System.Drawing.Point(20, 118)
$lblGH.AutoSize = $true
$lblGH.ForeColor = $accent
$lblGH.Font = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Bold)

$lblCount = New-Object System.Windows.Forms.Label
$lblCount.Text = T "LblLoading"
$lblCount.Location = New-Object System.Drawing.Point(650, 118)
$lblCount.AutoSize = $true
$lblCount.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#6c7086')

# --- 9. Grille ---
$dgv = New-Object System.Windows.Forms.DataGridView
$dgv.Location = New-Object System.Drawing.Point(20, 142)
$dgv.Size = New-Object System.Drawing.Size(765, 200)
$dgv.AllowUserToAddRows = $false
$dgv.RowHeadersVisible = $false
$dgv.BackgroundColor = $surface
$dgv.ForeColor = $text
$dgv.GridColor = $border
$dgv.BorderStyle = 'None'
$dgv.AutoSizeColumnsMode = 'Fill'
$dgv.EnableHeadersVisualStyles = $false

# Colonnes
$colActive = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
$colActive.HeaderText = T "ColActive"
$colActive.Name = 'Active'
$colActive.FillWeight = 8

$colName = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colName.HeaderText = T "ColJournal"
$colName.Name = 'Journal'
$colName.ReadOnly = $true
$colName.FillWeight = 20

$colPath = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colPath.HeaderText = T "ColPath"
$colPath.Name = 'CurrentPath'
$colPath.ReadOnly = $true
$colPath.FillWeight = 35

$colSize = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colSize.HeaderText = T "ColSize"
$colSize.Name = 'TailleMo'
$colSize.FillWeight = 15

$colMode = New-Object System.Windows.Forms.DataGridViewComboBoxColumn
$colMode.HeaderText = T "ColMode"
$colMode.Name = 'Mode'
[void]$colMode.Items.AddRange('Circular', 'AutoBackup', 'OverwriteAsNeeded')
$colMode.FillWeight = 22

[void]$dgv.Columns.AddRange($colActive, $colName, $colPath, $colSize, $colMode)
$dgv.ColumnHeadersDefaultCellStyle.BackColor = $headerBg
$dgv.ColumnHeadersDefaultCellStyle.ForeColor = $accent

# --- 10. Boutons selection ---
$flowSel = New-Object System.Windows.Forms.FlowLayoutPanel
$flowSel.Location = New-Object System.Drawing.Point(20, 355)
$flowSel.Size = New-Object System.Drawing.Size(765, 30)

$btnAll = New-Object System.Windows.Forms.Button
$btnAll.Text = T "BtnAll"
$btnAll.AutoSize = $true
$btnAll.BackColor = $surface2
$btnAll.FlatStyle = 'Flat'

$btnNone = New-Object System.Windows.Forms.Button
$btnNone.Text = T "BtnNone"
$btnNone.AutoSize = $true
$btnNone.BackColor = $surface2
$btnNone.FlatStyle = 'Flat'

$flowSel.Controls.AddRange(@($btnAll, $btnNone))

# --- 11. ProgressBar ---
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 395)
$progressBar.Size = New-Object System.Drawing.Size(765, 10)
$progressBar.Visible = $false

# --- 12. Boutons Actions ---
$flowAct = New-Object System.Windows.Forms.FlowLayoutPanel
$flowAct.Location = New-Object System.Drawing.Point(20, 415)
$flowAct.Size = New-Object System.Drawing.Size(765, 36)

$btnApply = New-Object System.Windows.Forms.Button
$btnApply.Text = T "BtnApply"
$btnApply.AutoSize = $true
$btnApply.BackColor = $green
$btnApply.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#11111b')
$btnApply.FlatStyle = 'Flat'
$btnApply.Font = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Bold)

$btnRes = New-Object System.Windows.Forms.Button
$btnRes.Text = T "BtnDefault"
$btnRes.AutoSize = $true
$btnRes.BackColor = $orange
$btnRes.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#11111b')
$btnRes.FlatStyle = 'Flat'
$btnRes.Font = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Bold)

$flowAct.Controls.AddRange(@($btnApply, $btnRes))

# --- 13. Output ---
$txtOutput = New-Object System.Windows.Forms.RichTextBox
$txtOutput.Location = New-Object System.Drawing.Point(20, 462)
$txtOutput.Size = New-Object System.Drawing.Size(765, 160)
$txtOutput.ReadOnly = $true
$txtOutput.BackColor = $surface
$txtOutput.ForeColor = $text
$txtOutput.Font = New-Object System.Drawing.Font('Consolas', 9)
$txtOutput.BorderStyle = 'None'

# --- 14. Fonctions UI ---
function Update-UI-Language {
    $form.Text = T "AppTitle"
    $lblTitle.Text = T "HeaderTitle"
    $lblP.Text = T "LblDest"
    $lblGH.Text = T "LblLogs"
    $btnAll.Text = T "BtnAll"
    $btnNone.Text = T "BtnNone"
    $btnApply.Text = T "BtnApply"
    $btnRes.Text = T "BtnDefault"
    $btnLang.Text = T "BtnLang"
    
    $dgv.Columns['Active'].HeaderText = T "ColActive"
    $dgv.Columns['Journal'].HeaderText = T "ColJournal"
    $dgv.Columns['CurrentPath'].HeaderText = T "ColPath"
    $dgv.Columns['TailleMo'].HeaderText = T "ColSize"
    $dgv.Columns['Mode'].HeaderText = T "ColMode"
    
    $lblCount.Text = T "LblCount" $targetLogs.Count
}

$btnLang.Add_Click({
    $currentLang = if ($currentLang -eq "FR") { "EN" } else { "FR" }
    $currentLang | Out-File $langFile -Encoding UTF8
    Update-UI-Language
})

# --- 15. Fonctions Logique ---
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
    param($backupPath, $onlyLogs = $null)
    
    if (-not (Test-Path $backupPath)) {
        Write-Log (T "LogRbFail" $backupPath "N/A") $redc
        return $false
    }
    
    try {
        $backup = Get-Content $backupPath -Raw | ConvertFrom-Json
        $restored = 0
        $failed = 0
        
        Write-Log (T "LogRbStart") $orange
        
        foreach ($entry in $backup) {
            $logName = $entry.Journal
            if ($null -ne $onlyLogs -and $onlyLogs -notcontains $logName) { continue }

            # Mapping wevtutil
            $mode = $entry.Mode
            switch ($mode) {
                'Circular' { $rt = 'false'; $ab = 'false' }
                'AutoBackup' { $rt = 'true'; $ab = 'true' }
                'OverwriteAsNeeded' { $rt = 'false'; $ab = 'false' }
            }
            
            $bytes = [int]$entry.Taille * 1MB
            $currentPath = $entry.CurrentPath
            if ([string]::IsNullOrEmpty($currentPath)) { $currentPath = $env:SystemDrive + '\EVT\' + $logName + '.evtx' }
            
            $cmdArgs = @('sl', $logName, "/lf:`"$currentPath`"", "/ms:$bytes", "/rt:$rt")
            if ($ab) { $cmdArgs += '/ab:true' }
            
            $proc = Start-Process wevtutil -ArgumentList $cmdArgs -Wait -PassThru
            if ($proc.ExitCode -eq 0) {
                $restored++
                Write-Log (T "LogRbOk" $logName) $green
            } else {
                $failed++
                Write-Log (T "LogRbFail" $logName $proc.ExitCode) $redc
            }
        }
        
        Write-Log (T "LogRbEnd" $restored $failed) $orange
        return ($failed -eq 0)
    } catch {
        Write-Log (T "LogErrCrit" $_.Exception.Message) $redc
        return $false
    }
}

# --- 16. BackgroundWorker ---
$bgWorker = New-Object System.ComponentModel.BackgroundWorker
$bgWorker.WorkerReportsProgress = $true

$bgWorker.Add_DoWork({
    param($worker, $e)
    $data = $e.Argument
    $path = $data.Path
    $settings = $data.Settings
    $results = @()

    if (-not (Test-Path $path)) { New-Item -ItemType Directory -Path $path -Force | Out-Null }

    $acl = Get-Acl $path
    $ruleSystem = New-Object System.Security.AccessControl.FileSystemAccessRule('SYSTEM', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
    $acl.SetAccessRule($ruleSystem)
    try {
        $ruleEvt = New-Object System.Security.AccessControl.FileSystemAccessRule('NT SERVICE\EventLog', 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
        $acl.AddAccessRule($ruleEvt)
    } catch {}
    Set-Acl $path $acl

    foreach ($s in $settings) {
        $logName = $s.Name
        switch ($s.Mode) {
            'Circular' { $rt = 'false'; $ab = 'false' }
            'AutoBackup' { $rt = 'true'; $ab = 'true' }
            'OverwriteAsNeeded' { $rt = 'false'; $ab = 'false' }
        }
        $cmdArgs = @('sl', $logName, "/lf:`"$(Join-Path $path ($logName + '.evtx'))`"", "/ms:$([int]$s.Size * 1MB)", "/rt:$rt")
        if ($ab) { $cmdArgs += '/ab:true' }

        $errPath = Join-Path $env:TEMP ("wevt_err_$logName.txt")
        $proc = Start-Process wevtutil -ArgumentList $cmdArgs -Wait -PassThru -RedirectStandardError $errPath
        $errMsg = if (Test-Path $errPath) { (Get-Content $errPath -Raw).Trim(); Remove-Item $errPath -Force } else { "" }

        $res = [PSCustomObject]@{ Name = $logName; Size = $s.Size; Mode = $s.Mode; ExitCode = $proc.ExitCode; Error = $errMsg }
        $results += $res
        $worker.ReportProgress([math]::Floor(($results.Count / $settings.Count) * 100), $res)
    }
    $e.Result = $results
})

$bgWorker.Add_ProgressChanged({
    param($worker, $e)
    $progressBar.Value = $e.ProgressPercentage
    $res = $e.UserState
    if ($res.ExitCode -eq 0) {
        Write-Log ($res.Name + " | " + $res.Size + " MB | " + $res.Mode) $green
    } else {
        Write-Log ($res.Name + " | FAIL (" + $res.ExitCode + ") : " + $res.Error) $redc
    }
})

$bgWorker.Add_RunWorkerCompleted({
    param($worker, $e)
    $progressBar.Visible = $false
    $btnApply.Enabled = $true
    $btnRes.Enabled = $true

    if ($e.Error) { Write-Log (T "LogErrCrit" $e.Error.Message) $redc }
    else {
        $results = $e.Result
        $successful = ($results | Where-Object { $_.ExitCode -eq 0 }).Count
        $failed = $results.Count - $successful
        
        Write-Log "-----------------------------------------------"
        Write-Log (T "LogFinished" $successful $failed) (if ($failed -eq 0) { $green } else { $orange })
        Write-Audit (T "LogFinished" $successful $failed)

        $txtPath.Text | Out-File $configFile -Encoding UTF8

        if ($failed -gt 0) {
            $rate = ($failed / $results.Count) * 100
            if ($rate -ge 50) {
                Write-Log (T "LogRbStart") $redc
                $rb = Restore-Backup $backupFile
                if ($rb) { [System.Windows.Forms.MessageBox]::Show((T "MsgRbSuccess" $failed $results.Count), 'Rollback', 0, 48) | Out-Null }
                else { [System.Windows.Forms.MessageBox]::Show((T "MsgRbFail" $failed $results.Count $backupFile), 'Error', 0, 16) | Out-Null }
            } else {
                $fLogs = ($results | Where-Object { $_.ExitCode -ne 0 }).Name -join ', '
                if ([System.Windows.Forms.MessageBox]::Show((T "MsgPartFail" $fLogs), '?', 4, 32) -eq 'Yes') { Restore-Backup $backupFile ($results | Where-Object { $_.ExitCode -ne 0 }).Name }
            }
        } else { Write-Log (T "LogSuccess") $green }
    }
})

# --- 17. Event Clic Appliquer ---
$btnApply.Add_Click({
    if ([System.Windows.Forms.MessageBox]::Show((T "MsgConfirmText"), (T "MsgConfirmTitle"), 4, 32) -ne 'Yes') { return }

    $settings = @(foreach ($r in $dgv.Rows) { if ($r.Cells['Active'].Value) { [PSCustomObject]@{ Name=$r.Cells['Journal'].Value; Size=$r.Cells['TailleMo'].Value; Mode=$r.Cells['Mode'].Value } } })
    if ($settings.Count -eq 0) { [System.Windows.Forms.MessageBox]::Show((T "MsgNoSelText"), (T "MsgNoSelTitle"), 0, 48) | Out-Null; return }

    $svc = Get-Service EventLog -ErrorAction SilentlyContinue
    if ($null -eq $svc -or $svc.Status -ne 'Running') { [System.Windows.Forms.MessageBox]::Show((T "MsgSvcErrText"), (T "MsgSvcErrTitle"), 0, 16) | Out-Null; return }

    $path = $txtPath.Text.Trim()
    if (-not $path) { [System.Windows.Forms.MessageBox]::Show((T "MsgEmptyPath"), 'Error', 0, 16) | Out-Null; return }
    if ($path.StartsWith('\\')) { [System.Windows.Forms.MessageBox]::Show((T "MsgUncErr"), 'Error', 0, 16) | Out-Null; return }
    if ($path -notmatch '^[a-zA-Z]:\\') { [System.Windows.Forms.MessageBox]::Show((T "MsgLocalErr"), 'Error', 0, 16) | Out-Null; return }

    try {
        if (-not (Test-Path $path)) { New-Item -ItemType Directory -Path $path -Force | Out-Null }
        $tf = Join-Path $path ("perm_test_" + (Get-Random) + ".tmp")
        [System.IO.File]::WriteAllText($tf, "test"); Remove-Item $tf -Force
    } catch {
        [System.Windows.Forms.MessageBox]::Show((T "MsgNtfsErr" $path $_.Exception.Message), 'NTFS Error', 0, 16) | Out-Null; return
    }

    $totalMB = ($settings.Size | Measure-Object -Sum).Sum
    try {
        $drv = Get-PSDrive (Split-Path $path -Qualifier).TrimEnd(':')
        if ($drv.Free -lt ($totalMB * 1MB)) { [System.Windows.Forms.MessageBox]::Show((T "MsgDiskErr" [math]::Round($drv.Free/1GB,2) [math]::Round($totalMB/1024,2)), 'Disk Error', 0, 16) | Out-Null; return }
        Write-Log (T "LogDiskSpace" [math]::Round($drv.Free/1GB,2) [math]::Round($totalMB/1024,2))
    } catch {}

    $dgv.Rows | Select-Object @{n='Journal';e={$_.Cells['Journal'].Value}}, @{n='CurrentPath';e={$_.Cells['CurrentPath'].Value}}, @{n='Taille';e={$_.Cells['TailleMo'].Value}}, @{n='Mode';e={$_.Cells['Mode'].Value}} | ConvertTo-Json | Out-File $backupFile -Encoding UTF8
    Write-Log (T "LogBackup" $backupFile)
    
    $txtOutput.Clear(); $progressBar.Visible=$true; $progressBar.Value=0; $btnApply.Enabled=$false; $btnRes.Enabled=$false
    Write-Log (T "LogBgStart")
    $bgWorker.RunWorkerAsync(@{ Path = $path; Settings = $settings })
})

$btnAll.Add_Click({ foreach ($r in $dgv.Rows) { $r.Cells['Active'].Value = $true } })
$btnNone.Add_Click({ foreach ($r in $dgv.Rows) { $r.Cells['Active'].Value = $false } })
$btnRes.Add_Click({ foreach ($r in $dgv.Rows) { 
    $rowLog = $r.Cells['Journal'].Value
    $r.Cells['TailleMo'].Value = if ($rowLog -eq 'Security') { 128 } elseif ($rowLog -match 'Setup|Forwarded') { 32 } else { 20 }
    $r.Cells['Mode'].Value = 'Circular'
} })

# --- 18. Lancement ---
$form.Controls.AddRange(@($panelH, $lblP, $txtPath, $btnBr, $lblGH, $lblCount, $dgv, $flowSel, $progressBar, $flowAct, $txtOutput))
$panelH.Controls.Add($btnLang)
Update-UI-Language
[System.Windows.Forms.Application]::EnableVisualStyles()
$form.ShowDialog() | Out-Null
