# Aplicativo para substituição sensorial
## Setup do Ambiente de Desenvolvimento
1. [Baixar Android Studio](https://developer.android.com/studio/index.html)
2. Descompactar Android Studio no diretório desejado
3. Iniciar Android Studio pela primeira vez
  * ```./<diretorio_escolhido>/android-studio/bin/studio.sh```
4. A instalação do Sdk básico é feita durante a primeira inicialização
5. Criar Icone na Área de Trabalho

## Importar Projeto
1. Abrir Android Studio
2. Importar projeto
3. Especificar caminho para o Sdk, o caminho padrão da instalação é ~/Android/Sdk
4. Instalar Sdks faltantes 
5. Instalar Sdk Tools 
6. Resolver problemas de dependências e Build Tools, basta clicar nas opções de instalação automática

[Link Útil](https://developer.android.com/studio/install.html)

## Instalar Aplicativo
1. Conectar smartphone ao computador
2. Fazer o Build do aplicativo
3. Escolher Smartphone para instalar o aplicativo

## Emulador
É possível testar o aplicativo em um emulador oferecido pelo Android Studio, basta seguir [esta](https://developer.android.com/studio/run/managing-avds.html) documentação para criar um emulador, para que a câmera funcione basta habilitá-la nas configurações do emulador.

## Testes
  Para testar o envio e recebimentos de dados use o comando ```ncat -kl <port>```

  Assim um servidor tcp é iniciado na linha de comando
  
  Obs: Por padrão a maioria das distros Linux vem com as portas bloqueadas, é necessário desbloquear a porta desejada, isso vai depender da distro usada, em caso de distros Debian recomenda-se o programa ufw, para qualquer outra distro o programa iptables é recomendado.

## Trabalhos Futuros
Trabalhos Futuros
+ Tratamento de erros de conexão
  * Atualmente os erros de conexão já são tratados no código, porém o usuário não recebe um feedback quando a maioria deles ocorre
+ Possibilitar a configuração de timeout
  * Através de um menu de configuração permitir que o usuário possa especificar o tempo de timeout para envio e recebimento de mensagens TCP
+ Criar dinamicamente os sensores disponíveis no aparelho
  * Atualmente os sensores são criados hardcoded, portanto um aparelho que não tenha uma bússola por exemplo não poderia receber o aplicativo, seria interessante que o aplicativo verificasse a disponibilidade de sensores e instanciasse somente os sensores disponíveis
+ Possibilitar habilitar e desabilitar sensores
  * Permitir que o usuário possa habilitar e desabilitar os sensores disponíveis, desta forma apenas os sensores habilitados seriam mostrados na tela principal
+ Mostrar sensores desabilitados
  * Um complemento para a funcionalidade acima para que o usuário possa reabilitar os sensores desabilitados
+ Possibilitar configuração manual de captura de áudio e vídeo
  * Atualmente os parâmetros de captura de áudio e vídeo estão fixos, seria interessante tornar estes configuráveis, para tal o aplicativo deve primeiramente saber quais são os parâmetros disponíveis em cada aparelho
+ Possibilitar configuração automática de captura de áudio e vídeo
  * Implementar um protocolo em que o colete e o aparelho possam conversar e determinar automaticamente a melhor configuração para captura de áudio e vídeo
+ Melhorar algoritmo de envio de informações para o colete
  * Atualmente o algoritmo de envio é bem simples, a cada 100ms um sensor que esteja ativo é lido e o valor enviado para o colete, porém isso não é interessante para vários sensores, por exemplo a bussola poderia ser lida somente quando uma variação de x graus for identificada
+ Pesquisar a possibilidade de envio de media (áudio e vídeo) via udp
  * Da parte do aplicativo estabelecer uma conexão UDP para mídia é viável, porém precisa ser pesquisado pela equipe responsável pelo colete, se é possível com o módulo wifi atual, configurar duas conexões simultâneas, uma para TCP e outra para UDP
+ Arrumar envio de mensagem para os motores
  * Foi identificada uma diferença no envio implementado no aplicativo, e nos parâmetros usados nos motores, é necessário adiciona mais um byte que identifique a função desejada, conversar bom o Roberto para maiores informações
