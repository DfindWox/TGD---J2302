# Projeto J2302

## Convenções de formatação e organização

### Convenções para nomes
(OBS: Convenções baseadas no [guia de estilo de GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).)
 - **Pastas:** Usar `PascalCase`
 - **Arquivos:** Usar `snake_case`
 - **Nodes e classes:** Usar `PascalCase`
 - **Funções e variáveis:** Usar `snake_case`
 - **Sinais:**
    - Nome: usar `snake_case`
    - Forma: preferir usar no passado (ex: `player_dead` ao invés de `player_die`)
 - **Constantes e enums**:
    - Usar `CONSTANT_CASE` para nomes de constantes e de elementos de enums
    - Usar `PascalCase` para nomes de enums. Ex:
		```
		enum Elements {
		    EARTH,
		    WIND,
		    AIR,
		    WATER,
		}
		```
### Estrutura base de pastas
```
res://
├── Actors (para objetos inseridos nas telas do jogo)
├── addons (somente se o projeto usar addons, criada na instalação)
├── Assets
│   ├── Fonts (arquivos base de fontes)
│   ├── Icons (para ícones de aplicativo)
│   ├── Images (imagens maiores, como BGs)
│   ├── Music (música no geral)
│   ├── Resources (recursos gerados na engine)
│   ├── SFX (efeitos sonoros)
│   └── Sprites (imagens pequenas e animações)
├── Scenes (telas do jogo)
├── Scripts
│   ├── Autoloads (scripts e scenes usadas para autoload)
│   └── Classes (scripts que criam classes para serem usadas no editor)
└── UI (scenes salvas especificamente para UI)
```
### Convenções para código
 - Usar tipagem estática
	 - Para variáveis declaradas sem valor inicial, indicar o tipo
		 - Exemplo: `var variavel : float`
	 - Para variáveis com valor inicial, inferir o tipo pelo valor
		 - Exemplo: `var variavel := 1.5`
	 - Para variáveis com valor onde não é possível inferir o tipo, indicar o tipo usando `as`
		 - Exemplo: `@onready var variavel := $Player/Sprite as Sprite`
	 - Nas declarações de funções:
		 - Indicar o tipo de cada argumento
		 - Indicar o tipo de retorno da função, mesmo que seja `void`
		 - Exemplo: `func rotate_sprite(degrees : float) -> void:`
- Usar comentários de documentação para todas as variáveis, sinais, enums e constantes declaradas fora de funções.
	- Para isso, adicionar comentário com hash duplo após cada declaração. Ex:
		`var velocity := Vector2.ZERO ## Velocidade do personagem.`
- Ordem de declaração (adaptado do [guia de estilo de GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)):
	```
		1. @tool
		2. class_name
		3. extends
		4. docstring

		5. sinais
		6. enums
		7. constantes
		8. variáveis de @export
		9. variáveis públicas
		10. variáveis privadas
		11. variáveis de @onready

		12. funções virtuais (começando por _init, depois _ready, depois as outras)
		13. funções públicas
		14. funções privadas
		15. funções de set e get
		16. funções disparadas por sinais
		17. subclasses
	```
	- Manter espaço de uma linha entre cada _seção de declarações_ nas seções de 5 a 11
	- Manter espaço de duas linhas entre cada função declarada
		- Dentro das funções, usar espaço de uma linha para dividir seções lógicas da função se necessário
	- Eliminar seções vazias
- Expor ao editor qualquer variável que precise ser alterada ao usar a Scene instanciada dentro de outra
- Emitir sinais usando o padrão implementado na Godot 4.0
	- Exemplo: `player_dead.emit()` em vez de `emit_signal("player_dead")`
- Declarar funções e variáveis privadas com um `_` antes do nome
