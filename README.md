# DatZB005 — 9.1. praktiskais darbs

Adams Duckens, ITIA 1.

Windows `.bat` kalkulators atbilstoši `9_1_pr_darbs.pdf`.

- `10.bat` pieprasa divus veselus skaitļus, parāda izvēlni, pārbauda ievadi,
  izsauc `rekinat.bat` un piedāvā atkārtot darbu. Beidzot darbu, gaida taustiņu
  un pēc tam divas sekundes, izmantojot `timeout`.
- `rekinat.bat` veic `+`, `-`, `*`, `/` vai `2` (pirmā skaitļa kvadrāts), izvada
  rezultātu un pievieno to `log.txt` blakus skriptam. Divciparu rezultātam
  atsevišķi izvada abus ciparus; negatīvam rezultātam izmanto ciparus bez zīmes.
- `test.bat` palaiž abus skriptus pagaidu mapē ar atstarpēm nosaukumā.
  Pārbauda visas operācijas, robežas 9/10/99/100, negatīvus rezultātus,
  sākuma nulles, nederīgu ievadi, dalīšanu ar nulli, precīzu žurnāla saturu,
  izvēlnes atkārtotu ievadi, atkārtošanu un divu sekunžu aizturi pirms iziešanas.
  Aiztures pārbaudei izmanto Windows iebūvēto PowerShell taimeri.
  Atgriež `0`, ja viss izdevies,
  citādi `1`, un kļūmes gadījumā saglabā pagaidu failus diagnostikai.

Palaist Windows Command Prompt:

```bat
10.bat
rekinat.bat 3 4 "*"
test.bat
```

Aprēķinos izmantots Windows `set /a`: 32 bitu veseli skaitļi,
dalīšana atmet daļskaitļa daļu. Decimāldaļas nav atbalstītas;
aritmētiska pārpilde pakļaujas `set /a` uzvedībai.
Konsolei novirzītas ievades gadījumā `timeout` vietā divu sekunžu gaidīšanu
nodrošina `ping` uz `127.0.0.1`.

GitHub Actions izpilda `test.bat` ar `cmd` uz `windows-latest` pēc katra push,
pull request vai manuālas palaišanas. Wine netiek izmantots.

Komandu dokumentācija: [set /a](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/set_)
un [timeout](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/timeout).
