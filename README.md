# 🐢 🐉 tDF (Turtle Dragonflight)

> [!NOTE]
> ### 🛠️ Informações do Fork & Lista de Modificações (Changelog)
> Este repositório é um fork aprimorado do [Turtle-Dragonflight original (TheLinuxITGuy)](https://github.com/TheLinuxITGuy/Turtle-Dragonflight) com correções de bugs, compatibilidade e novas funcionalidades para o cliente **Turtle WoW 1.12 (Vanilla)**:
>
> 1. **Menu Principal (GameMenu / ESC):**
>    - Reposicionamento do botão **tDF Options** para o final do menu principal (abaixo de *Return to Game*).
>    - Renomeação dos identificadores de frame para evitar sobreposição/conflito com o botão *Advanced Options* de outros addons (ex: ShaguTweaks / pfUI).
>
> 2. **Estabilidade & Prevenção de Erros Lua:**
>    - Adicionada verificação de segurança (`nil check`) em `tDFUI.HookScript` no arquivo `helpers.lua`, prevenindo a falha fatal `attempt to index local 'f' (a nil value)`.
>    - Adicionadas verificações defensivas em `mods/equip-compare.lua` (para compatibilidade com `AtlasLootTooltip2`) e `mods/improved-interface-options.lua`.
>
> 3. **Painel de Opções (Scroll & Interface):**
>    - Corrigido o cálculo de altura do container e limites do `ScrollBar` em `config.lua`, restaurando o funcionamento dos botões de seta para cima/baixo e da barra de rolagem.
>    - Adicionado suporte nativo à rolagem via roda do mouse (*Mouse Wheel*) no painel de configurações.
>    - Isolamento de nomes globais com prefixo `TDF_` para prevenir conflito com ShaguTweaks.
>
> 4. **Sistema de Movimentação de Elementos (`<Shift> + <Ctrl>`):**
>    - Corrigida a falha silenciosa em `move-unitframes-extended.lua` que impedia mover a maioria dos elementos da tela (antes apenas o `PlayerFrame` movia).
>    - Corrigida a ordem de chamada da engine do WoW 1.12 (`SetMovable(true)` antes de `SetUserPlaced(true)`), eliminando os erros `Frame ... is not movable or resizable` (ex: `MultiBarRight`, `PetFrame`).
>    - Adicionado encaminhamento de clique/drag em elementos compostos: agora é possível clicar e arrastar em qualquer parte do Minimap, botões do MicroMenu, barra de bolsas, barra de ações, barra de XP e reputação.
>
> 5. **Suporte Completo a Buffs, Item Buffs e Debuffs:**
>    - Criadas 4 âncoras dedicadas e independentes: **Buffs 1**, **Buffs 2**, **Item Buffs (Weapon Enchants / TempEnchant)** e **Debuffs**.
>    - No modo de edição (`<Shift> + <Ctrl>`), caixas coloridas com legendas aparecem para permitir mover os grupos mesmo sem nenhum buff ativo no personagem.
>    - Hook em `BuffFrame_Update` e `BuffButton_Update` para garantir que novos buffs permaneçam travados na posição configurada pelo usuário.
>    - Removidas âncoras hardcoded conflitantes em `tMinimap.lua`.
>
> 6. **Sistema de Reset de Posições (Individual e Global):**
>    - **Reset por Botão Direito:** No modo de edição (`<Shift> + <Ctrl>`), clique com o **Botão Direito** sobre qualquer elemento para resetá-lo imediatamente à posição de fábrica.
>    - **Comando de Chat `/tdfreset`:** Digite `/tdfreset` para restaurar todas as posições, ou `/tdfreset <nome>` (ex: `/tdfreset player`, `/tdfreset minimap`, `/tdfreset bags`, `/tdfreset xp`, `/tdfreset cast`) para resetar um elemento específico.
>
> 7. **Barras de Cast Dragonflight & Preview no Modo de Edição:**
>    - Ao segurar `<Shift> + <Ctrl>`, as barras de cast do Jogador (`tDFImprovedCastbar`) e do Alvo (`tDFTargetCastbar`) são exibidas com estilo visual completo do Dragonflight, faísca luminosa e timer, permitindo movê-las e alinhá-las sem precisar castar feitiços.
>    - Detecção e supressão automática de barras duplicadas de outros addons (ex: `ShaguTargetCastbar` do ShaguTweaks).
>
> 8. **Movimentação de Barras Extras de Ação:**
>    - Suporte a arrastar e salvar a posição das barras adicionais (`MultiBarBottomLeft`, `MultiBarBottomRight`, `MultiBarRight`, `MultiBarLeft`, `PetActionBarFrame` e `ShapeshiftBarFrame`) com propagação de clique pelos botões.
>
> 9. **Atalhos e Comandos de Reload Rápido:**
>    - Criação de `Bindings.xml` para registrar nativamente o atalho de teclado `Reload UI` no menu de Key Bindings (Atalhos do Teclado) do WoW.
>    - Registro dos comandos de chat `/rl`, `/r` e `/reload`.

![GitHub Release](https://img.shields.io/github/v/release/TheLinuxITGuy/Turtle-Dragonflight?style=for-the-badge&labelColor=%231A365D&color=%23E9FC12)
![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/TheLinuxITGuy/Turtle-Dragonflight/total?style=for-the-badge&labelColor=%231A365D&color=%23E9FC12)
![Static Badge](https://img.shields.io/badge/1.18.0-blue?style=for-the-badge&label=supported%20twow%20ver&labelColor=%231A365D&color=%23E9FC12)


The Dragonflight UI for Turtle WoW. 

## :hourglass_flowing_sand: NOTICE: __I no longer play Turtle WoW. The 1.12.1 is very old and outdated. I now play Project Epoch instead which uses a much better 3.3.5a client for Classic+ WoW. Here's the Dragonflight UI for it: https://github.com/TheLinuxITGuy/Chromie-Dragonflight__ :hourglass_flowing_sand:

## 🛠️ Installation
This is a stand-alone addon made for the Turtle WoW 1.12.1 client. You can get this addon from the official TWOW Launcher. If you want to download directly from GitHub, follow the manual install steps below.

#### Manual tDF Install
1. Unpack the zip file included with this download.
2. Remove the -main from __Turtle-Dragonflight-main__.
3. Copy the __Turtle-Dragonflight__ folder to your AddOns folder.

#### Interface Install
- Copy the contents of the included __~/Turtle-Dragonflight/Interface__ folder into your Turtle WoW Interface folder.
- Folder structure:
  
<pre>
TurtleWoW/
└── Interface/
    ├── Minimap
    └── TargetingFrame
</pre>
   
## 🎥 Video
[![Video](https://img.youtube.com/vi/AD1jRnHu_lo/maxresdefault.jpg)](https://www.youtube.com/watch?v=AD1jRnHu_lo)

## ✨ Features
- Dragonflight Minimap
- Dragonflight ActionBars
- Dragonflight Unitframes
- Dragonflight Castbar & Timer
- Dragonflight Bags
- Dragonflight MicroMenu
- Dragonflight Latency Bar
- Movable Dragonflight XP bar (Green: 150% rested, Blue: Below 150% Rested XP, Purple: Regular XP)
- For Customization Options, press __Escape__ and navigate to __tDF Options__
- Move things with __CTRL + SHIFT__

## 🐞 Known issues
- Stealth/Stance bars work, they are just invisible.
- The zzz doesn't go away until zone change when under a tent.
## 🌟 Grateful to All Contributors
A heartfelt thank you to everyone who has contributed to the development of tDF. Your dedication is truly appreciated, and you’re making this addon better for everyone!
Special thanks to
ShaguTweaks,
Grylls,
Ark,
and ZiiMs

[![Contributors](https://contrib.rocks/image?repo=TheLinuxITGuy/Turtle-Dragonflight)](https://github.com/TheLinuxITGuy/Turtle-Dragonflight/graphs/contributors)

## 💖 Sponsor
https://www.paypal.com/donate/?hosted_button_id=WPTX2BMBARSG2
