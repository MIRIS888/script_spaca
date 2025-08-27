# Windows Setup Script 🖥️

Automatizovaný PowerShell script pro nastavení Windows podle firemních standardů.

## 📋 Co script dělá

### Automatické konfigurace:
- ✅ **Síťové nastavení** - nastaví síť jako privátní, povolí sdílení souborů
- ✅ **Vzdálený přístup** - aktivuje Remote Desktop s ověřením
- ✅ **Úspora energie** - vypne uspávání při napájení ze sítě
- ✅ **Obnovení systému** - aktivuje System Restore s 5GB prostorem
- ✅ **Plocha a hlavní panel** - zobrazí ikony, skryje vyhledávání/widgety, zarovná vlevo
- ✅ **Průzkumník souborů** - zobrazí přípony souborů
- ✅ **Aktualizace** - spustí Windows Update a winget upgrade
- ✅ **Firewall** - povolí sdílení pro doménové sítě

### Manuální instalace (script zobrazí odkazy):
- 🔧 **TightVNC** Server (64-bit, custom instalace)
- 📦 **7-Zip**
- 📄 **Adobe Reader** (nastaví jako výchozí pro PDF)
- 📧 **Kerio Offline Connector**
- 📁 **Total Commander** (pro všechny uživatele)

## 🚀 Jak použít

### Požadavky:
- Windows 10/11
- **Administrátorská práva** (nutné!)
- PowerShell 5.1 nebo vyšší

### Spuštění:

1. **Stáhněte script:**
   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/MIRIS888/script_spaca/main/Windows-Setup.ps1" -OutFile "Windows-Setup.ps1"
   ```

2. **Spusťte jako administrátor:**
   ```powershell
   # Pravý klik na PowerShell → "Spustit jako správce"
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
   .\Windows-Setup.ps1
   ```

3. **Nebo jedním příkazem:**
   ```powershell
   # Spustí script přímo z GitHubu
   iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/MIRIS888/script_spaca/main/Windows-Setup.ps1'))
   ```

## Manuální instalace

Script obsahuje poznámky pro software, který je třeba nainstalovat ručně:

- **TightVNC** - stáhnout z [tightvnc.com](https://www.tightvnc.com)
  - 64-bit verze, pouze server
  - Nastavit heslo pro vzdálený přístup
  - Vypnout web access port 5800
- **7-Zip** - archivační nástroj
- **Adobe Reader** - nastavit jako výchozí pro PDF
- **Kerio Offline Connector** - emailový klient
- **Total Commander** - správce souborů (pro všechny uživatele)

## Odinstalace bloatwaru

Ručně odinstalovat nepotřebný software:
- Cizí antivirové programy
- Hry a zábavní aplikace  
- Výrobcův bloatware (HP OneAgent, Lenovo Vantage, atd.)

## Bezpečnost

- Script obsahuje pouze defenzivní operace
- Nevyžaduje připojení k internetu (kromě aktualizací)
- Všechny změny jsou reverzibilní přes Windows nastavení
- Používá error handling pro prevenci systémových chyb

## Řešení problémů

Pokud script selže:

1. **Zkontrolujte administrátorská oprávnění**
2. **Spusťte Windows Update** - některé funkce vyžadují aktuální systém  
3. **Zkontrolujte PowerShell Execution Policy**:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
4. **Restartujte počítač** - některá nastavení se projeví až po restartu

## Testováno na

- Windows 10 Pro (21H2, 22H2)
- Windows 11 Pro (21H2, 22H2)
- Firemní domény i workgroup prostředí

## Licence

MIT License - volně k použití a úpravám

## Autor

Vytvořeno pro automatizaci firemního nastavení Windows stanic.

---

⚠️ **Upozornění:** Vždy si před spuštěním zazálohujte důležitá data a vytvořte bod obnovení systému.