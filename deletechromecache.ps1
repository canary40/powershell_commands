# Esegui come amministratore
Write-Host "Avvio pulizia cache di Google Chrome per tutti gli utenti..." -ForegroundColor Cyan

# Variabile per tenere traccia della dimensione totale
$totalSize = 0

# Cartelle tipiche di cache di Chrome
$chromeCacheFolders = @(
    "Cache",
    "Code Cache",
    "GPUCache",
    "ShaderCache",
    "Service Worker\CacheStorage",
    "Service Worker\Database",
    "Service Worker\ScriptCache"
)

# Ottieni tutti i profili utente locali (esclude utenti di sistema)
$users = Get-ChildItem "C:\Users" -Directory | Where-Object {
    $_.Name -notin @("All Users", "Default", "Default User", "Public")
}

foreach ($user in $users) {
    $chromeBasePath = "C:\Users\$($user.Name)\AppData\Local\Google\Chrome\User Data\"
    if (Test-Path $chromeBasePath) {
        # Ogni profilo di Chrome ha una cartella (Default, Profile 1, ecc.)
        Get-ChildItem $chromeBasePath -Directory | ForEach-Object {
            $profilePath = $_.FullName
            foreach ($folder in $chromeCacheFolders) {
                $cachePath = Join-Path $profilePath $folder
                if (Test-Path $cachePath) {
                    # Calcola dimensione prima della rimozione
                    $size = (Get-ChildItem -Path $cachePath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                    if ($size -gt 0) {
                        $totalSize += $size
                    }

                    # Elimina la cache
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
