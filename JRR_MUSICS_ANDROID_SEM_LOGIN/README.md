# JRR MUSIC'S — versão Android sem login

Esta versão abre sem autenticação. As escolhas do onboarding ficam salvas no próprio aparelho.

## Requisitos
- Windows 10/11
- Flutter SDK instalado e adicionado ao PATH
- Android Studio com Android SDK e ferramentas de build
- Conexão com internet para baixar dependências e reproduzir as faixas demonstrativas

## Gerar APK no Windows
1. Extraia o ZIP.
2. Abra a pasta extraída.
3. Dê dois cliques em `scripts/gerar_apk_windows.bat`.
4. Aguarde o processo terminar.
5. O APK estará em `build/app/outputs/flutter-apk/app-release.apk`.

Também pode executar manualmente no terminal, dentro da pasta:
```bash
flutter create --platforms=android --org com.jrrmusics .
flutter pub get
flutter build apk --release
```

## O que esta versão inclui
- Sem login, cadastro ou Firebase obrigatório.
- Onboarding de gêneros e artistas.
- Preferências locais.
- Tela inicial e catálogo demonstrativo.
- Player, controles, progresso e fila.
- Serviço de cache de áudio preparado.

## Limitações importantes
- As músicas e imagens do catálogo são URLs demonstrativas de terceiros; precisam ser substituídas por conteúdo com autorização de distribuição.
- A reprodução das faixas de demonstração exige internet. O serviço de cache está preparado, mas ainda não há tela de downloads nem catálogo offline integrado.
- As letras de demonstração são ilustrativas; letras reais e sincronização exigem fonte licenciada e timestamps reais.
- Esta base não implementa ainda reprodução em segundo plano/controles na tela bloqueada.
- O APK só é produzido depois de executar o script em um computador com Flutter e Android SDK instalados.

## Gerar o APK pela internet (sem instalar Flutter no computador)

Este projeto já inclui uma automação do GitHub Actions para compilar o APK.

1. Extraia o arquivo ZIP no computador.
2. Entre em [github.com](https://github.com) e crie uma conta gratuita, se ainda não tiver.
3. Crie um repositório novo (por exemplo, `jrr-musics`). Deixe-o vazio.
4. No repositório, escolha **Add file > Upload files** e envie todos os arquivos e pastas extraídos. Importante: envie também a pasta oculta `.github`.
5. Clique em **Commit changes** para enviar os arquivos.
6. Abra a aba **Actions** do repositório.
7. Se aparecer uma confirmação para habilitar Actions, confirme. Depois abra **Gerar APK Android** e clique em **Run workflow** (se o processo não iniciar automaticamente).
8. Aguarde o processo ficar verde como concluído. Abra a execução e, na parte **Artifacts**, baixe `JRR-MUSICS-APK`.
9. Extraia o ZIP baixado. Dentro estará `app-release.apk`, que pode ser transferido para o celular Android e instalado.

O GitHub compila o aplicativo; o MConverter não é necessário. O APK só existirá depois que a compilação terminar com sucesso. Na primeira instalação, o Android poderá pedir autorização para instalar aplicativos dessa origem.
