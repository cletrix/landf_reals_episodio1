---
name: CtxHaxeLibs
description: Use esta skill quando o usuário mencionar libs Haxe/OpenFL do projeto, falar em "net", "go", "go2", "timer", "core", "macro" como libs, pedir para criar telas/botões/labels em OpenFL, usar Rest/HTTP em Haxe, usar timers/debounce/throttle em Haxe, ou pedir um novo projeto Haxe/OpenFL. Palavras-chave: haxe, openfl, net.Rest, go.Label, go2.JsonScene, go.Rectangle, go.ImageButton, timer.T, core.Translator, BitmapFont, AudioService, ctx, landf_haxe_libs.
---

# Skill: CtxHaxeLibs — Bibliotecas Haxe/OpenFL do projeto

## Localização das libs

```
/Users/cleyton/Dev/LandF/landf_stage/landf_haxe_libs/ctx/
├── net/      Rede (REST, TCP, WebSocket)
├── go/       UI v1 (componentes OpenFL)
├── go2/      UI v2 — versão moderna com tradução nativa
├── core/     Utilitários (storage, tradução, formatação)
├── timer/    Timers, debounce, throttle
└── macro/    Debug automático por build macro
```

## Como incluir em project.xml

```xml
<source path="/Users/cleyton/Dev/LandF/landf_stage/landf_haxe_libs/ctx" />
```

Isso torna disponíveis todos os pacotes: `net.*`, `go.*`, `go2.*`, `core.*`, `timer.*`, `macro.*`.

---

## net/ — Rede

### Rest (HTTP GET/POST)
```haxe
import net.Rest;

Rest.get(url, (data:Dynamic) -> trace(data), (err:Dynamic) -> trace(err));

Rest.post(url, {campo: "valor"}, (data:Dynamic) -> {
    trace(data.algumCampo);
}, (err:Dynamic) -> trace(err));
```
- POST serializa params como JSON automaticamente
- Em C++: roda em Thread para não bloquear UI
- onError recebe `{error, details}`

### Client (TCP/WebSocket auto-detectado)
```haxe
import net.Client;

var client = new Client("localhost:8080", (msg:String) -> {
    var data = haxe.Json.parse(msg);
});
client.send("kind", "command", "value");
if (client.connected) { ... }
```
- Em HTML5 → usa WS (WebSocket)
- Em C++/Neko → usa TCP (porta 44889)
- Reconnect automático a cada 5s

---

## go/ — UI v1

### Rectangle (shape colorido)
```haxe
import go.Rectangle;

var rect = new Rectangle(0x16213e, 700, 110);  // cor, largura, altura
rect.x = 34;  rect.y = 200;
rect.set_color(0x0f3460);  // mudar cor depois
addChild(rect);
```

### Label (texto com fonte TTF)
```haxe
import go.Label;

var lbl = new Label("Texto", "assets/fonts/arial.ttf", 24, 100, 50, 300, 60);
lbl.fontColor = 0xFF0000;
lbl.textAlign = "CENTER";  // "LEFT", "CENTER", "RIGHT"
lbl.text = "Novo texto";
addChild(lbl);
```

### Image
```haxe
import go.Image;

var img = new Image("assets/images/bg.png");
img.alpha = 0.8;
addChild(img);
```

### ImageButton (2 estados: in/out)
```haxe
import go.ImageButton;

// Carrega: "assets/btn/playin.png" e "assets/btn/playout.png"
var btn = new ImageButton("assets/btn/play", onPlayClick);
function onPlayClick() { trace("clicado"); }
addChild(btn);
```

### ImageButtonAdvanced (N estados numerados)
```haxe
import go.ImageButtonAdvanced;

// Carrega: "assets/btn/lang0.png", "lang1.png", "lang2.png", ...
var btn = new ImageButtonAdvanced("assets/btn/lang", onLang, 4);
btn.changeState(1);   // muda para lang1.png
btn.getState();       // retorna índice atual
btn.disable();
btn.enable();
addChild(btn);
```

### BitmapFont (fonte bitmap atlas)
```haxe
import go.BitmapFont;

// Requer: "assets/fonts/retro.png" + "assets/fonts/retro.txt" (BMFont)
var font = new BitmapFont("assets/fonts/retro");
font.setRawText("SCORE: 1000");
font.pulse(0.3, 15);       // anima (amplify, repetições)
font.positionCenter(384, 200);
font.getTextWidth();
addChild(font);
```

### FPS (monitor de performance)
```haxe
import go.FPS;

var fps = new FPS();
addChild(fps);
// Em C++ também mostra memória
```

---

## go2/ — UI v2 (preferida para projetos novos)

### Label2 (Label com tradução automática)
```haxe
import go2.Label2;

var lbl = new Label2("Iniciar", "assets/fonts/arial.ttf", 24);
lbl.setKeyTranslation("menu.start");  // auto-atualiza ao trocar idioma
lbl.setRawText("Texto fixo");
addChild(lbl);
```

### JsonScene (DSL declarativa — a mais poderosa)
```haxe
import go2.JsonScene;

var json = {
  header: { items: [
    { id: "logo", type: "image", path: "assets/logo", x: 0, y: 0 }
  ]},
  pages: [
    { items: [
      { id: "bg",    type: "image",     path: "assets/bg",        x: 0,   y: 0 },
      { id: "title", type: "label",     text: "Menu", font: "arial.ttf", fontSize: 32,
        color: "0xFFFFFF", textAlign: "CENTER", x: 0, y: 80 },
      { id: "score", type: "bitmapFont",path: "assets/fonts/retro", text: "SCORE", x: 100, y: 200 },
      { id: "play",  type: "button",    path: "assets/btn/play",  callback: "onPlay",
        size: 2, x: 274, y: 600 },
      { id: "rect1", type: "rectangle", color: "0x16213e", width: 600, height: 80, x: 84, y: 400 },
      { id: "anim",  type: "textureAnimation", path: "assets/anim/idle", action: "idle",
        once: false, x: 300, y: 500 }
    ]}
  ]
};

var callbacks:Map<String, Void->Void> = ["onPlay" => () -> trace("play!")];
var scene = new JsonScene(json, callbacks, null);
addChild(scene);

// Manipular depois:
scene.setText("title", "Game Over");
scene.setVisible("play", false);
scene.setAlpha("bg", 0.5);
scene.setScale("score", 1.5);
scene.setPosition("rect1", 100, 500);
scene.setColor("rect1", 0xFF0000);
scene.runAnimation("anim", "run");
scene.runAnimationOnce("anim", "jump", () -> trace("done"));
scene.stopAnimation("anim");
scene.setButtonState("play", 1);
scene.goToPage(1);
var node = scene.getNode("title");  // retorna Sprite
```

**Tipos suportados em JsonScene:** `image`, `label`, `bitmapFont`, `textureAnimation`, `rectangle`, `button`

---

## timer/ — Timers

### T (façade curta — recomendada)
```haxe
import timer.T;
import timer.TimerHandle;

// Uma vez
T.once(1000, () -> trace("1 segundo depois"));

// Loop infinito
var h:TimerHandle = T.every(500, () -> trace("tick"));
T.stop(h);

// N repetições com progresso
var h = T.start(1000, 10, (tick) -> {
    trace('tick $tick de 10 — progresso: ${T.progress(h)}');
}, () -> trace("completo!"));

// Por duração total
T.startDur(100, 3000, (tick) -> trace(tick), null); // ticks por 3s

// Pausa/retoma
T.pause(h);
T.resume(h);
T.finishNow(h);  // encerra e chama onComplete

// Debounce (trailing-edge)
var db = T.debounce(300, () -> trace("pesquisa"));
db.call();  // cada call() reseta o timer

// Throttle (leading-edge)
var th = T.throttle(500, () -> trace("dispara"));
th.call();  // imediato na 1ª vez, ignora chamadas dentro do intervalo
```

---

## core/ — Utilitários

### Translator (multi-idioma)
```haxe
import core.Translator;

// Inicializar (uma vez)
Translator.instance.loadLanguages("i18n/");  // carrega en.json, pt.json, etc.

// Traduzir
var text = Translator.instance.t("menu.start");
var msg  = Translator.instance.format("score.msg", ["score" => "1000"]);

// Trocar idioma
Translator.instance.setLanguage("es");
Translator.instance.nextLanguage();
Translator.instance.getLanguage();  // "pt"
```

Formato do JSON `i18n/pt.json`:
```json
{ "menu.start": "Iniciar", "score.msg": "Pontuação: {score}" }
```

### StorageManager (localStorage/SharedObject)
```haxe
import core.StorageManager;

var save = new StorageManager("player_score");
save.setValueInt(1000);
save.setValueStr("nome");
var score = save.getValue();  // "1000"
```

### Tools (formatação)
```haxe
import core.Tools;

Tools.formatCentsPlainBR(1234567);  // "12.345,67"
Tools.isInteger("42");              // true
Tools.formatDateTime("20240105143022");  // "05/01/2024 14:30:22"
```

---

## macro/ — Debug automático

```haxe
@:build(macro.DebugMacro.injectDebugLog())
class MinhaClasse extends Sprite {
    function minhaFuncao() { ... }  // logada automaticamente

    @:noDebug
    function ignorada() { ... }
}
// Output: [MinhaClasse.hx:10][14:22:03:100] func: minhaFuncao

---

## Tabela rápida de referência

| Necessidade | Import | Classe/Método |
|---|---|---|
| HTTP POST/GET | `net.Rest` | `Rest.post(url, params, cb, err)` |
| Rede TCP/WS | `net.Client` | `new Client(url, onMsg)` |
| Texto (TTF) | `go.Label` / `go2.Label2` | `new Label(text, font, size)` |
| Texto (bitmap) | `go.BitmapFont` | `new BitmapFont(path)` |
| Imagem | `go.Image` | `new Image(path)` |
| Botão simples | `go.ImageButton` | `new ImageButton(path, cb)` |
| Botão N estados | `go.ImageButtonAdvanced` | `new ImageButtonAdvanced(path, cb, n)` |
| Shape colorido | `go.Rectangle` | `new Rectangle(cor, w, h)` |
| Tela declarativa | `go2.JsonScene` | `new JsonScene(json, callbacks)` |
| Timer/loop | `timer.T` | `T.every(ms, cb)` |
| Countdown | `timer.T` | `T.start(ms, n, onTick, onDone)` |
| Debounce | `timer.T` | `T.debounce(ms, cb)` |
| Persistência | `core.StorageManager` | `new StorageManager(nome)` |
| Tradução | `core.Translator` | `Translator.instance.t("key")` |
| Debug | `macro.DebugMacro` | `@:build(macro.DebugMacro.injectDebugLog())` |

## Linkando uma lib ao workspace e ao `project.xml`

Quando for necessário referenciar uma pasta de libs compartilhadas (ex: `landf_haxe_libs`), siga estes passos rápidos:

- Adicione a pasta ao arquivo de workspace (`*.code-workspace`) no array `folders`. Exemplo:

```json
{
  "folders": [
    { "name": "episodio1", "path": "." },
    { "name": "landf_haxe_libs", "path": "/Users/cleyton/Dev/LandF/landf_stage/landf_haxe_libs" }
  ]
}
```

- Insira um `<source>` em `project.xml` do projeto que vai usar a lib. Use um caminho relativo (consistente com a estrutura do projeto) ou absoluto. Exemplo (relativo, seguindo padrão do Bingo):

```xml
<source path="../../landf_haxe_libs/ctx" />
```

- Alternativa: crie um symlink dentro do projeto que aponte para a pasta de libs e referencie o symlink no `project.xml`:

```bash
ln -s /Users/cleyton/Dev/LandF/landf_stage/landf_haxe_libs ep1a/landf_haxe_libs
# então em ep1a/project.xml
<source path="landf_haxe_libs/ctx" />
```

- Observações:
- Prefira caminhos relativos quando o repositório for compartilhado entre desenvolvedores.
- Verifique que a pasta apontada contém `ctx/` com os pacotes esperados (`go`, `net`, `core`, ...).
