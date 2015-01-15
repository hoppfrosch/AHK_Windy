#include <Windy\Mousy>

obj := new Mousy()
obj.speed := 10
saveSpeed := obj.speed
OutputDebug % "Start - " saveSpeed
obj.speed := 1
OutputDebug % "Speed 1 - " obj.speed
Sleep, 10000
obj.speed := 20
OutputDebug % "Speed 2 - " obj.speed
Sleep, 10000
obj.speed := saveSpeed
OutputDebug % "Ende - " obj.speed

ExitApp