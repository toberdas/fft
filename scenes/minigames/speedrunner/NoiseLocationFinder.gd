extends Node


export(NoiseTexture) var noiseTexture
export(float) var resolution
export(float) var verticalCutoffStart
export(float) var verticalCutoffEnd

func check_location(x, y):
	var noiseVal = noiseTexture.noise.get_noise_2d(x * 10.0,y * 10.0)
	if noiseVal > 0.2:
		return true
	else:
		return false
