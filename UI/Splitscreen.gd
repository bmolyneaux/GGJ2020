extends Control

func _ready():
	$GridContainer/ViewportContainer/Viewport/CameraPivot.character = $GridContainer/ViewportContainer/Viewport/World/Repairer
	$GridContainer/ViewportContainer2/Viewport/CameraPivot.character = $GridContainer/ViewportContainer/Viewport/World/Repairer
	$GridContainer/ViewportContainer3/Viewport/CameraPivot.character = $GridContainer/ViewportContainer/Viewport/World/Repairer
	$GridContainer/ViewportContainer4/Viewport/CameraPivot.character = $GridContainer/ViewportContainer/Viewport/World/Repairer
