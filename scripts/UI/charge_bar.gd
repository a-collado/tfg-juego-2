class_name ChargeBar
extends Control


@onready var texture_progress_bar_0 = $"Progress Bar Lvl 0"
@onready var texture_progress_bar_1 = $"Progress Bar Lvl 1"
@onready var texture_progress_bar_2 = $"Progress Bar Lvl 2"

## Valores de carga: 0, 1, 2, 3
## 0 siginifica que no esta cargado
var charge_level: int = 0
var charging := false

func _ready():
	texture_progress_bar_0.value = 0;
	texture_progress_bar_1.value = 0;
	texture_progress_bar_2.value = 0;

func _physics_process(_delta):
	if charging:
		texture_progress_bar_0.value += 0.01
		if texture_progress_bar_0.value >= texture_progress_bar_0.max_value:
			charge_level = 1
			texture_progress_bar_1.value += 0.01
			if texture_progress_bar_1.value >= texture_progress_bar_1.max_value:
				charge_level = 2
				texture_progress_bar_2.value += 0.01
				if texture_progress_bar_2.value >= texture_progress_bar_2.max_value:
					charge_level = 3

func charge(value: bool):
	charging = value;

func reset():
	texture_progress_bar_0.value = 0
	texture_progress_bar_1.value = 0
	texture_progress_bar_2.value = 0
