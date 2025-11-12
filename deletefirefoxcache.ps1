# Esegui come amministratore
Write-Host "Avvio pulizia cache di Firefox per tutti gli utenti..." -ForegroundColor Cyan

# Cartelle di cache da rimuovere in ogni profilo Firefox
$cacheFolders = @("cache2", "startupCache", "offlineCache", "jumpListCache", "thumbnails")

# Variabile per la dimensione totale
$totalSize = 0

# Ottieni tutti i profili utente locali (esclude utenti di sistema)
$users = Get-ChildItem "C:\Users" -Directory | Where-Object {
    $_.Name -notin @("All Users", "Default", "Default User", "Public")
}

foreach ($user in $users) {
    $profilesPath = "C:\Users\$($user.Name)\AppData\Local\Mozilla\Firefox\Profiles\"
    if (Test-Path $profilesPath) {
        Get-ChildItem $profilesPath -Directory | ForEach-Object {
            foreach ($folder in $cacheFolders) {
                $cachePath = Join-Path $_.FullName $folder
                if (Test-Path $cachePath) {
                    # Calcola la dimensione prima della rimozione
                    $size = (Get-ChildItem -Path $cachePath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                    if ($size -gt 0) {
                        $totalSize += $size
                    }

                    # Elimina la cartella di cache
                    Remove-Item $cachePath -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Host "Cache rimossa: $cachePath" -ForegroundColor DarkGray
                }
            }
        }
    }
}

# Messaggio finale
if ($totalSize -gt 0) {
    $totalMB = [math]::Round($totalSize / 1MB, 2)
    Write-Host "`nPulizia completata. Spazio totale liberato: $totalMB MB" -ForegroundColor Green
} else {
    Write-Host "`nNessuna cache trovata o già vuota." -ForegroundColor Yellow
}
