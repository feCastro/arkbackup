@echo off

set arkDir=C:\Program Files (x86)\Steam\steamapps\common\ARK Survival Ascended\ShooterGame\Saved\
set backupFolder=E:\Ark Backups\bkp
set logFile=%backupFolder%\bkplog.txt

rem Solicita o tempo limite ao usuário
set /p timeout="Digite o intervalo de backup (em segundos - default 2,5min=150): "
rem Verifica se o usuário deixou em branco; se sim, usa o valor padrão de 150 segundos
if "%timeout%"=="" set timeout=150

rem Inicia o jogo via Steam
start "" "steam://rungameid/2399830"
@REM start "" "steam://rungameid/2399830//-nobattleye"

rem Enquanto o jogo estiver rodando, executa o backup
echo Aguardando o jogo rodar para realizar o backup...

rem Pausa por 40 segundos para garantir que o Steam tenha tempo de iniciar o jogo
timeout /t 40 >nul

:loop
rem Verifica se o processo do jogo está em execução
tasklist /FI "IMAGENAME eq ArkAscended.exe" 2>NUL | find /I "ArkAscended.exe" > NUL
if errorlevel 1 (
  echo O jogo foi fechado. O script de backup será encerrado.
  goto end
)

rem Realiza o backup a cada intervalo de tempo
echo Iniciando Backup a cada %timeout% segundos >> "%logFile%"
echo ----------------------------------------- >> "%logFile%"
echo.
echo Ultimo Backup: %date% %time%
echo Aperte Ctrl+C para finalizar
echo -----------------------------------------
echo.

rem Captura a data atual no formato yyyy-mm-dd
for /f "tokens=1,2,3 delims=/ " %%a in ("%date%") do (
  set year=%%c
  set month=%%a
  set day=%%b
)

rem Formata a data no formato yyyy-mm-dd
set currentDate=%year%-%month%-%day%

rem Captura a hora atual no formato HH:MM:SS
for /f "tokens=1,2,3 delims=:," %%a in ("%time%") do (
  set hour=%%a
  set min=%%b
  set sec=%%c
)

rem Formata a hora no formato HH-MM-SS
set datetime=%currentDate%-%hour%.%min%.%sec%

rem Remove espaços indesejados na variável datetime
set datetime=%datetime: =%

rem Cria o diretório e realiza o backup
xcopy "%arkDir%" "%backupFolder%\%datetime%" /E /I /Y >> "%logFile%" 2>&1
echo.  >> "%logFile%"

rem Executa o timeout definido (intervalo de backup) entre cada verificação
timeout /t %timeout% >nul

@REM taskkill /IM ArkAscended_BE.exe /F


goto loop

:end
echo Backup finalizado.
