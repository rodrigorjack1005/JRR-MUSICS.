@echo off
setlocal
echo ==========================================
echo       JRR MUSIC'S - GERADOR DE APK
echo ==========================================
where flutter >nul 2>nul
if errorlevel 1 (
  echo ERRO: Flutter nao encontrado no PATH.
  echo Instale o Flutter e configure a variavel PATH.
  pause
  exit /b 1
)

if not exist android (
  echo Criando estrutura Android...
  flutter create --platforms=android --org com.jrrmusics .
  if errorlevel 1 goto erro
)

echo Baixando dependencias...
flutter pub get
if errorlevel 1 goto erro

echo Gerando APK release...
flutter build apk --release
if errorlevel 1 goto erro

echo.
echo APK criado em:
echo build\app\outputs\flutter-apk\app-release.apk
pause
exit /b 0

:erro
echo.
echo Ocorreu um erro. Confira a instalacao do Flutter e Android SDK.
pause
exit /b 1
