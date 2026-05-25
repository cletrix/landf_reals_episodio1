---
name: haxe-openfl-resolution
description: >
  Conhecimento completo sobre estratégia de resolução 720p com assets 2x em projetos Haxe/OpenFL
  para iGaming e VLT. Use este skill sempre que o Cleyton mencionar resolução, scaling, DPR
  (Device Pixel Ratio), StageScaleMode, assets retina, spritesheet, TexturePacker, ou qualquer
  questão relacionada a como o jogo se adapta a diferentes tamanhos de tela em projetos
  Haxe/OpenFL como o landf_game_bingo. Também relevante quando discutir performance mobile,
  bundle size, ou comparação entre 720p e 1080p em contexto de game provider.
---

# Haxe/OpenFL — Estratégia de Resolução 720p + Assets 2x

## Princípio central

**Design lógico em 720p. Assets exportados em 2x. Scaling via Stage.**

Todo o código de layout, posicionamento e lógica trabalha em coordenadas **1280×720** (espaço lógico). O OpenFL mapeia esse espaço para a tela real via `StageScaleMode`. Assets em 2x garantem nitidez em telas Retina sem renderizar nativamente em 1080p.

Isso é o mesmo padrão `@2x` do iOS e o mesmo que providers como Pragmatic Play usam no Gates of Olympus.

---

## 1. Configuração do project.xml

```xml
<!-- Espaço lógico fixo em 720p -->
<window width="1280" height="720" background="#000000" />

<!-- Assets 1x (base) -->
<assets path="assets/images" rename="images" />

<!-- Assets 2x para telas retina (opcional, carregamento condicional via código) -->
<!-- <assets path="assets/images@2x" rename="images@2x" /> -->
```

---

## 2. StageScaleMode — opções e quando usar cada uma

### SHOW_ALL (letterbox — comportamento padrão Gates of Olympus mobile)
```haxe
stage.scaleMode = StageScaleMode.SHOW_ALL;
stage.align = StageAlign.TOP_LEFT;
```
- Mantém aspect ratio 16:9
- Adiciona barras pretas se a tela não for 16:9
- Mais simples, zero distorção
- **Recomendado para VLT** onde a tela é controlada

### NO_SCALE + scaling manual (controle total)
```haxe
stage.scaleMode = StageScaleMode.NO_SCALE;

// Em qualquer ponto onde o stage muda de tamanho:
function applyScale():Void {
    var scaleX = stage.stageWidth / 1280;
    var scaleY = stage.stageHeight / 720;
    var scale = Math.min(scaleX, scaleY); // mantém proporção

    root.scaleX = root.scaleY = scale;
    root.x = (stage.stageWidth  - 1280 * scale) / 2; // centraliza X
    root.y = (stage.stageHeight - 720  * scale) / 2; // centraliza Y
}

stage.addEventListener(Event.RESIZE, function(_) applyScale());
applyScale();
```
- **Recomendado para iGaming web/mobile** — dá controle sobre onde ficam as barras
- Permite alinhar ao topo (barras só embaixo), útil em portrait mobile

### EXACT_FIT (stretch — evitar)
```haxe
stage.scaleMode = StageScaleMode.EXACT_FIT;
```
- Distorce a imagem para preencher a tela
- Não usar em jogos — elementos ficam "achatados"

---

## 3. Carregando assets 2x com detecção de DPR

```haxe
// Detecta Device Pixel Ratio no target HTML5
private function getDevicePixelRatio():Float {
    #if js
    return js.Browser.window.devicePixelRatio;
    #else
    return 1.0;
    #end
}

private function loadSymbol(name:String):Bitmap {
    var dpr = getDevicePixelRatio();
    var useHiRes = dpr >= 2.0;

    var path = useHiRes ? 'images@2x/$name.png' : 'images/$name.png';
    var bmp = new Bitmap(Assets.getBitmapData(path));

    // Compensa o tamanho dobrado para ocupar espaço lógico correto
    if (useHiRes) {
        bmp.scaleX = 0.5;
        bmp.scaleY = 0.5;
    }

    return bmp;
}
```

---

## 4. Spritesheet com TexturePacker — configuração recomendada

| Parâmetro | Valor | Motivo |
|---|---|---|
| Scale 1x | 1.0 | Assets para devices mid-range |
| Scale 2x | 2.0 | Assets para Retina/AMOLED |
| Algorithm | MaxRects | Melhor aproveitamento de espaço |
| Max size | 2048×2048 | Limite seguro WebGL mobile |
| Format | PNG | Compatibilidade universal |
| Android | ETC2 | Compressão GPU nativa |
| iOS | ASTC | Compressão GPU nativa |
| Trim | Yes | Remove transparência desnecessária |
| Extrude | 1-2px | Evita bleeding entre sprites |

### Carregando spritesheet no OpenFL
```haxe
// Usando openfl-tilelayer ou Tilemap para batch rendering
var tilesheet = new Tilemap(2048, 2048, Assets.getBitmapData("images/atlas.png"));

// Ou com SpriteSheet manual
var atlas = Assets.getBitmapData("images/atlas.png");
var symbolRect = new Rectangle(0, 0, 200, 200); // posição no atlas
var symbolBmp = new Bitmap(new BitmapData(200, 200, true, 0));
symbolBmp.bitmapData.copyPixels(atlas, symbolRect, new Point(0, 0));
```

---

## 5. Tamanhos de referência para landf_game_bingo

Trabalhar sempre em coordenadas lógicas 720p. Exportar PNGs em 2x.

| Elemento | Tamanho lógico (código) | PNG exportado (2x) |
|---|---|---|
| Stage base | 1280 × 720 | — |
| Background | 1280 × 720 | 2560 × 1440 |
| Cartela 5×5 | ~400 × 400 | 800 × 800 |
| Célula da cartela | ~70 × 70 | 140 × 140 |
| Bola animada | 60 × 60 | 120 × 120 |
| Botão UI | 120 × 50 | 240 × 100 |
| Header/footer UI | 1280 × 80 | 2560 × 160 |

**Bundle estimado total:** 3–8 MB comprimido (adequado para BR mobile 4G)

---

## 6. Listener de RESIZE para portrait/landscape (mobile)

```haxe
stage.addEventListener(Event.RESIZE, onResize);

private function onResize(e:Event):Void {
    var isPortrait = stage.stageHeight > stage.stageWidth;

    if (isPortrait) {
        // Reposiciona UI para portrait
        // O jogo mantém layout landscape centralizado com barras acima/abaixo
        applyScale();
        repositionUIPortrait();
    } else {
        applyScale();
        repositionUILandscape();
    }
}
```

---

## 7. Impacto de performance — por que não 1080p nativo

| Métrica | 720p (1280×720) | 1080p (1920×1080) |
|---|---|---|
| Pixels totais | ~921k | ~2.07M |
| Fillrate GPU relativo | 1× | ~2.25× |
| Memória de textura | base | ~4× (dobro de cada dimensão) |
| Bundle size | base | +60–120% |
| FPS em mid-range BR | estável | quedas em animações pesadas |

**Conclusão:** para o perfil de device do jogador brasileiro médio (mid-range Android, 4G variável), 720p lógico + assets 2x é o ponto ótimo entre qualidade visual e performance.

---

## 8. Bundle — o que é e por que < 10 MB

**Bundle** é o peso total dos arquivos que o jogador precisa baixar antes de jogar — spritesheets, áudio, JS compilado e fontes.

### Composição típica de um slot/bingo HTML5

| Item | Peso típico |
|---|---|
| Spritesheets PNG (símbolos, UI) | 2–4 MB |
| Backgrounds | 0.5–1 MB |
| Áudio (SFX + música) | 1–3 MB |
| JS compilado (Haxe → JS) | 0.5–1.5 MB |
| Fontes | 0.1–0.3 MB |
| **Total** | **~4–10 MB** |

### Por que < 10 MB importa no Brasil

O jogador brasileiro médio está em **4G variável**. O tempo de carregamento impacta diretamente a taxa de abandono antes do primeiro spin:

| Bundle | 4G bom (20 Mbps) | 4G fraco (5 Mbps) | 3G (1 Mbps) |
|---|---|---|---|
| 5 MB | ~2s | ~8s | ~40s |
| 10 MB | ~4s | ~16s | ~80s |
| 20 MB | ~8s | ~32s | ~160s |

Referência: Fortune Tiger (PG Soft) pesa ~18,5 MB — considerado pesado. Gates of Olympus fica em ~8–12 MB.

### Haxe/OpenFL e o peso do JS

O JS compilado pelo Haxe tende a ser **mais pesado** que PixiJS puro (800 KB–2 MB) por causa do runtime. Compensar com **gzip/brotli** no servidor, que corta ~60–70% do tamanho. A maior alavanca de peso é sempre **áudio e textura** — não o código.

---

## 9. Checklist antes de publicar

- [ ] `project.xml` com `width="1280" height="720"`
- [ ] `StageScaleMode` definido explicitamente
- [ ] Todos os assets exportados em 2x (dobro das dimensões lógicas)
- [ ] Spritesheet máximo 2048×2048
- [ ] Detecção de DPR para carregamento condicional (se bundle separado)
- [ ] Listener de RESIZE registrado
- [ ] Testado em DevTools com iPhone 14 Pro Max (430×932) e desktop 1920×1080
- [ ] Bundle total < 10 MB
