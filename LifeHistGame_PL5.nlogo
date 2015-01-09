;; TODO:
; → opis
; OK zmniany wyglądu ze wzrostem/owocowaniem
; OK desynchronizacja semelparycznych
; OK wygląd szachownicy
; OK wykres nasion?
; OK klarowniejszy interfejs
; OK go n-steps

globals [seeds choosen_seeds empty_patches start_energy index energy_amount break seed_index sum_seeds all_seeds all_plants expected_seeds czas_symulacji wait_time]

breed [plantsType1 plant1]
breed [plantsType2 plant2]
breed [plantsType3 plant3]
breed [plantsType4 plant4]
breed [plantsType5 plant5]
breed [walls wall]

turtles-own [energy dojrzewanie maturation_energy reproduce age stage mature] ;; maturation, semelparycznosc


to setup
  clear-all
  set czas_symulacji 100
  set wait_time 0.25
  draw-edges gray
  set break false
  ask patches [ ;; szachownica
    set pcolor white
  ]
  set start_energy 5
  update-empty-patches
  set seeds (n-values 5 [roslin_na_start])
  set all_seeds (n-values 5 [0])
  set all_plants (n-values 5 [0])
  set-default-shape turtles "seed"
  plant-all-seeds
  asynchronize  
  
  reset-ticks
end

to asynchronize 
  ask turtles [
  set age (random dojrzewanie) ;; set random age of plants (from range [0, dojrzewanie))
  set stage age
  set energy (count_energy age) ;; and set energy according to it
  ifelse (age = 0) 
  [set shape "seed"]
  [set shape (word "plant_age" stage)] 
  ]
end

to go
  set seeds n-values 5 [0]
  ask turtles [
    plant-cycle
  ]
  update-empty-patches
  plant-all-seeds
  tick-advance 1
  update-plots
end

to go-n
  repeat czas_symulacji [
    wait wait_time
    go
    if (count turtles = 0) [stop]
  ] 
end

to draw-edges [color_name] 
  ask patches [
    sprout-walls 1 [
      set shape "default"
      set color color_name
      set heading 0
      ht
      setxy (pxcor - 0.5) (pycor - 0.5)
      pen-down
      repeat 4 [
        fd 1
        set heading (heading + 90)
      ]
      die
    ]
  ]
end

to plant-seeds [number breed_type] ;; TODO: choose seeds to plant if seeds > empty_patches
  ask (n-of number empty_patches) [
    sprout 1 [
      set shape "seed"
      set mature false
      set breed breed_type
      set energy start_energy
      set age 0
      set stage 0
      if breed_type = plantsType1 [
        set all_plants (replace-item 0 all_plants ((item 0 all_plants) + 1))
        set color magenta
        set pcolor 129
        set dojrzewanie dojrzewanie1
        set maturation_energy (count_energy (dojrzewanie1 - 1))
        ifelse semelparycznosc1 
        [set reproduce task reproduce_once] 
        [set reproduce task reproduce_multiple]
      ]
      if breed_type = plantsType2 [
        set all_plants (replace-item 1 all_plants ((item 1 all_plants) + 1))
        set color blue
        set pcolor 99
        set dojrzewanie dojrzewanie2
        set maturation_energy (count_energy (dojrzewanie2 - 1))
        ifelse semelparycznosc2 
        [set reproduce task reproduce_once] 
        [set reproduce task reproduce_multiple]
      ]
      if breed_type = plantsType3 [
        set all_plants (replace-item 2 all_plants ((item 2 all_plants) + 1))
        set color green
        set pcolor 69
        set dojrzewanie dojrzewanie3
        set maturation_energy (count_energy (dojrzewanie3 - 1))
        ifelse semelparycznosc3 
        [set reproduce task reproduce_once] 
        [set reproduce task reproduce_multiple]
      ]  
      if breed_type = plantsType4 [
        set all_plants (replace-item 3 all_plants ((item 3 all_plants) + 1))
        set color orange
        set pcolor 29
        set dojrzewanie dojrzewanie4
        set maturation_energy (count_energy (dojrzewanie4 - 1))
        ifelse semelparycznosc4 
        [set reproduce task reproduce_once] 
        [set reproduce task reproduce_multiple]
      ]   
        if breed_type = plantsType5 [
        set all_plants (replace-item 4 all_plants ((item 4 all_plants) + 1))
        set color brown
        set pcolor 39
        set dojrzewanie dojrzewanie5
        set maturation_energy (count_energy (dojrzewanie5 - 1))
        ifelse semelparycznosc5
        [set reproduce task reproduce_once] 
        [set reproduce task reproduce_multiple]
      ]   
    ]
  ]
  update-empty-patches
end

to plant-all-seeds
  ifelse (sum seeds > count empty_patches) and (sum seeds > 0)[
    choose-seeds-random 
  ]
  [set choosen_seeds seeds]
  (foreach (choosen_seeds) (list (plantsType1) (plantsType2) (plantsType3) (plantsType4) (plantsType5)) [
    plant-seeds ?1 ?2 ])
end

to choose-seeds-random ;; randomly choose seeds to plant (for choosing each seed: probability proportional to number of seeds of each type)
  set choosen_seeds n-values 5 [0]
  repeat (count empty_patches) [
    set seed_index random (sum seeds)
    set choosen_seeds (add-chosen-seed seed_index)
  ]
end

to choose-seeds-deterministic ;; alternative for choose-seeds-random. Number of choosen seeds exactly proportional to the number of seeds of each type. Possibly leaving free spaces (underestimation).
  set choosen_seeds map [floor ((?1 / sum seeds) * (count empty_patches))] seeds
end

to-report add-chosen-seed [number] ;; check type of chosen seed and add it to chosen_seeds (and remove it from seeds)
  set index 0
  set sum_seeds (item 0 seeds)
  repeat 5 [
    ifelse (number < sum_seeds)
    [
      set seeds (replace-item index seeds ((item index seeds) - 1))
      set choosen_seeds (replace-item index choosen_seeds ((item index choosen_seeds) + 1))
      report choosen_seeds
      ]
    [
      set index (index + 1)
      set sum_seeds (sum_seeds + item index seeds)   
    ]
  ]
end

to update-empty-patches
  set empty_patches (patches with [not any? turtles-here])
end

to-report grow [energy_val] ;; use in turtle context - exp growth
  report 2 * energy_val
end

to plant-cycle ;; use in turtle context - exp growth
  ifelse random-float 1 < smiertelnosc_na_rok[
    set pcolor white
    die ;; first check survival
  ]
  [
    set age (age + 1)
    set energy grow energy ;; growth before reproduction
    if not mature [set stage stage + 1]
    ifelse energy > maturation_energy [ 
      set mature true
      set shape (word "plant_age" stage "_flower")
      run reproduce
    ]
    [
      set shape (word "plant_age" stage)
     ]
  ]
  
end

to add_seeds [number breed_type]
  set index (read-from-string (last (word breed_type)) - 1)
  set seeds (replace-item index seeds (item index seeds + number))
  set all_seeds (replace-item index all_seeds (item index all_seeds + number))
end

to reproduce_once ;; in turtle context: semelparycznosc
  add_seeds (floor energy) breed ;; all energy used for producion of seeds
  ;;show (word "breed=" breed " semel" " stage=" stage " seeds=" (floor energy) " energy=" energy " maturation_energy=" maturation_energy)
  set pcolor white
  die
end

to reproduce_multiple ;; in turtle context: iteroparity
  add_seeds (floor (energy - maturation_energy)) breed
  ;;show (word "breed=" breed " itero" " stage=" stage " seeds=" (floor (energy - maturation_energy)) " energy=" energy " maturation_energy=" maturation_energy)
  set energy maturation_energy
end

to-report count_energy [time] ;; in turtle context: count energy amount after [time] timesteps.
  set energy_amount start_energy
  repeat time [
    set energy_amount (grow energy_amount)
  ]
  report energy_amount
end

to-report count-liftime-reproduction [number]
  ifelse ((item number all_plants) != 0)
  [report (item number all_seeds) / (item number all_plants)]
  [report 0]
end

to-report count-expected-seeds [maturation semelparous]
  ifelse semelparous [
    report precision (start_energy * (2 * (1 - smiertelnosc_na_rok)) ^ maturation) 1 
  ]
  [
    report precision ((1 / (2 * smiertelnosc_na_rok)) * start_energy * (2 * (1 - smiertelnosc_na_rok)) ^ maturation) 1
  ]
end

to-report expected-seeds
  ifelse pokaz_ile_nasion? [
    ;;report (map count-expected-seeds (list dojrzewanie1 dojrzewanie2 dojrzewanie3 dojrzewanie4) (list semelparycznosc1 semelparycznosc2 semelparycznosc3 semelparycznosc4))
    report (word " typ1=" count-expected-seeds dojrzewanie1 semelparycznosc1 
      "  typ2=" count-expected-seeds dojrzewanie2 semelparycznosc2 
      "  typ3=" count-expected-seeds dojrzewanie3 semelparycznosc3 
      "  typ4=" count-expected-seeds dojrzewanie4 semelparycznosc4
      "  typ5=" count-expected-seeds dojrzewanie5 semelparycznosc5 )
  ]
  [
    report "ukryte!"
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
353
15
1113
546
-1
-1
25.0
1
10
1
1
1
0
1
1
1
0
29
0
19
1
1
1
ticks
30.0

BUTTON
37
21
117
54
ustaw!
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
32
68
119
128
roslin_na_start
20
1
0
Number

SLIDER
7
155
161
188
dojrzewanie1
dojrzewanie1
1
5
1
1
1
NIL
HORIZONTAL

SLIDER
9
256
167
289
dojrzewanie3
dojrzewanie3
1
5
3
1
1
NIL
HORIZONTAL

SLIDER
182
155
339
188
dojrzewanie2
dojrzewanie2
1
5
2
1
1
NIL
HORIZONTAL

SLIDER
186
256
348
289
dojrzewanie4
dojrzewanie4
1
5
4
1
1
NIL
HORIZONTAL

SWITCH
6
193
171
226
semelparycznosc1
semelparycznosc1
1
1
-1000

SWITCH
7
295
171
328
semelparycznosc3
semelparycznosc3
1
1
-1000

SWITCH
179
193
343
226
semelparycznosc2
semelparycznosc2
1
1
-1000

SWITCH
183
296
351
329
semelparycznosc4
semelparycznosc4
1
1
-1000

SLIDER
127
80
336
113
smiertelnosc_na_rok
smiertelnosc_na_rok
0
1
0.5
0.05
1
NIL
HORIZONTAL

BUTTON
128
21
194
54
rok
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1125
17
1325
189
rosliny
czas
liczba roslin
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"1" 1.0 0 -5825686 true "" "plotxy ticks count plantsType1"
"2" 1.0 0 -13345367 true "" "plotxy ticks count plantsType2"
"3" 1.0 0 -10899396 true "" "plotxy ticks count plantsType3"
"4" 1.0 0 -955883 true "" "plotxy ticks count plantsType4"
"5" 1.0 0 -6459832 true "" "plotxy ticks count plantsType4"

PLOT
1124
196
1324
368
nasiona
czas
liczba nasion
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"1" 1.0 0 -5825686 true "" "plotxy ticks (item 0 seeds)"
"2" 1.0 0 -13345367 true "" "plotxy ticks (item 1 seeds)"
"3" 1.0 0 -10899396 true "" "plotxy ticks (item 2 seeds)"
"4" 1.0 0 -955883 true "" "plotxy ticks (item 3 seeds)"
"5" 1.0 0 -6459832 true "" "plotxy ticks (item 3 seeds)"

BUTTON
209
22
294
55
100_lat
go-n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
46
134
196
152
purpurowe
14
125.0
1

TEXTBOX
48
239
198
257
zielone
14
55.0
1

TEXTBOX
225
134
375
152
niebieskie
14
105.0
1

TEXTBOX
221
238
371
256
pomaranczowe
14
25.0
1

TEXTBOX
44
532
325
550
CC Marta Czarnocka-Cieciura, 2015
12
0.0
1

PLOT
1125
376
1325
545
nasion na rosline
typ roslin
srednio nasion
0.0
5.0
0.0
10.0
true
false
"" "clear-plot\nforeach [1 2 3 4 5] [\n  set-current-plot-pen word \"pen\" ?\n  plotxy (? - 1) 0\n  plotxy (? - 1) (count-liftime-reproduction (? - 1))\n  plotxy (?) (count-liftime-reproduction (? - 1))\n  plotxy ? 0\n]"
PENS
"pen1" 1.0 0 -5825686 true "" ""
"pen2" 1.0 0 -13345367 true "" ""
"pen3" 1.0 0 -10899396 true "" ""
"pen4" 1.0 0 -955883 true "" ""
"pen5" 1.0 0 -6459832 true "" ""

SWITCH
14
448
176
481
pokaz_ile_nasion?
pokaz_ile_nasion?
1
1
-1000

MONITOR
14
486
328
531
przewidywania - nasion na rosline:
expected-seeds
1
1
11

TEXTBOX
143
336
293
354
brazowe
14
35.0
1

SLIDER
83
354
255
387
dojrzewanie5
dojrzewanie5
1
5
5
1
1
NIL
HORIZONTAL

SWITCH
78
391
266
424
semelparycznosc5
semelparycznosc5
1
1
-1000

@#$#@#$#@
## WHAT IS IT?
This model simulates competition for space between simple, sedentary, plant-like organisms. They use different life strategies, in sense of different maturation age and single or multiple reproduction.

[Life history theory](http://en.wikipedia.org/wiki/Life_history_theory) is a part of the evolutionary biology that aims to explain how the duration and schedule of key events in life of organisms (such as development, sexual maturation and senescence) are shaped by the natural selection to maximize the reproduction output of individuals. This theory puts emphasis on the tradeoffs that each organism have to make in the context of:

* resource allocation into growth, reproduction and regeneration, 
* quantity vs quality of offspring,
* predator avoidance vs maximization of food intake,
* etc. 

In this simulation the user can set maturation age and reproduction investment of each plant type. Later maturation let the organism grow longer and hence make it able to invest more in future seed production. On the contrary, earlier maturation makes the plant more likely to survive to the reproduction age. Thanks to shorter generation time, population of such plants are able to grow more rapidly, producing grandchildren and grand-grandchildren before their competitors even start reproducing.

The reproduction investment settings allows user to choose between [semelparous or iteroparous](http://en.wikipedia.org/wiki/Semelparity_and_iteroparity) strategy of each plant type. Semelparity means that an organism reproduce only onece in its life, uses all its resources in the offspring production and dies shortly afterwards. It is observed in many real-world plants (eg. wheat, carrot, agava, bamboo) and some animals (eg. mayfly, some species of squids and salmons). The second strategy, iteroparity, means that only part of the resources is used for offspring production and the remaining part is spend for survival untill the next breeding season.

This model allows user to test performance and competitive abilities of each arbitrally chosen strategy. The limiting factor, for which plants compete, is the free space. The competition is mediated by the limited resources, not interactions between individuals (finite version of the "nest site lottery" [1]).

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES
[1] Argasinski, K., & Broom, M. (2013). **The nest site lottery: How selectively neutral density dependent growth suppression induces frequency dependent selection.** Theoretical Population Biology, 90, 82-90. [doi:10.1016/j.tpb.2013.09.011](http://dx.doi.org/10.1016/j.tpb.2013.09.011), freely available on ArXiv: [arXiv:1303.0564](http://arxiv.org/abs/1303.0564).
(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

plant_age1
false
0
Rectangle -7500403 true true 135 270 165 300
Polygon -7500403 true true 135 285 90 240 45 225 75 270 135 300
Polygon -7500403 true true 165 285 210 240 255 225 225 270 165 300
Polygon -7500403 true true 135 285 135 270 150 240 165 270

plant_age1_flower
false
0
Rectangle -7500403 true true 135 270 165 300
Polygon -7500403 true true 135 285 90 240 45 225 75 270 135 300
Polygon -7500403 true true 165 285 210 240 255 225 225 270 165 300
Polygon -7500403 true true 120 255 105 225 105 195 120 225 135 195 150 225 165 195 180 225 195 195 195 225 180 255 165 270 135 270 120 255

plant_age2
false
0
Rectangle -7500403 true true 135 225 165 300
Polygon -7500403 true true 135 285 90 240 45 225 75 270 135 300
Polygon -7500403 true true 165 285 210 240 255 225 225 270 165 300
Polygon -7500403 true true 135 225 150 195 165 225
Polygon -7500403 true true 165 240 210 195 255 180 225 225 165 255
Polygon -7500403 true true 135 240 90 195 45 180 75 225 135 255

plant_age2_flower
false
0
Rectangle -7500403 true true 135 225 165 300
Polygon -7500403 true true 135 285 90 240 45 225 75 270 135 300
Polygon -7500403 true true 165 285 210 240 255 225 225 270 165 300
Polygon -7500403 true true 165 240 210 195 255 180 225 225 165 255
Polygon -7500403 true true 135 240 90 195 45 180 75 225 135 255
Polygon -7500403 true true 135 225 120 210 105 180 105 150 120 180 135 150 150 180 165 150 180 180 195 150 195 180 180 210 165 225 135 225

plant_age3
false
0
Rectangle -7500403 true true 135 180 165 300
Polygon -7500403 true true 135 285 90 240 45 225 75 270 135 300
Polygon -7500403 true true 165 285 210 240 255 225 225 270 165 300
Polygon -7500403 true true 135 180 150 150 165 180
Polygon -7500403 true true 165 240 210 195 255 180 225 225 165 255
Polygon -7500403 true true 135 240 90 195 45 180 75 225 135 255
Polygon -7500403 true true 165 195 210 150 255 135 225 180 165 210
Polygon -7500403 true true 135 195 90 150 45 135 75 180 135 210

plant_age3_flower
false
0
Rectangle -7500403 true true 135 180 165 300
Polygon -7500403 true true 135 285 90 240 45 225 75 270 135 300
Polygon -7500403 true true 165 285 210 240 255 225 225 270 165 300
Polygon -7500403 true true 165 240 210 195 255 180 225 225 165 255
Polygon -7500403 true true 135 240 90 195 45 180 75 225 135 255
Polygon -7500403 true true 165 195 210 150 255 135 225 180 165 210
Polygon -7500403 true true 135 195 90 150 45 135 75 180 135 210
Polygon -7500403 true true 135 180 120 165 105 135 105 105 120 135 135 105 150 135 165 105 180 135 195 105 195 135 180 165 165 180

plant_age4
false
0
Rectangle -7500403 true true 135 135 165 300
Polygon -7500403 true true 135 285 90 240 45 225 75 270 135 300
Polygon -7500403 true true 165 285 210 240 255 225 225 270 165 300
Polygon -7500403 true true 135 135 150 105 165 135
Polygon -7500403 true true 165 240 210 195 255 180 225 225 165 255
Polygon -7500403 true true 135 240 90 195 45 180 75 225 135 255
Polygon -7500403 true true 165 195 210 150 255 135 225 180 165 210
Polygon -7500403 true true 165 150 210 105 255 90 225 135 165 165
Polygon -7500403 true true 135 195 90 150 45 135 75 180 135 210
Polygon -7500403 true true 135 150 90 105 45 90 75 135 135 165

plant_age4_flower
false
0
Rectangle -7500403 true true 135 135 165 300
Polygon -7500403 true true 135 285 90 240 45 225 75 270 135 300
Polygon -7500403 true true 165 285 210 240 255 225 225 270 165 300
Polygon -7500403 true true 165 240 210 195 255 180 225 225 165 255
Polygon -7500403 true true 135 240 90 195 45 180 75 225 135 255
Polygon -7500403 true true 165 195 210 150 255 135 225 180 165 210
Polygon -7500403 true true 165 150 210 105 255 90 225 135 165 165
Polygon -7500403 true true 135 195 90 150 45 135 75 180 135 210
Polygon -7500403 true true 135 150 90 105 45 90 75 135 135 165
Polygon -7500403 true true 135 135 120 120 105 90 105 60 120 90 135 60 150 90 165 60 180 90 195 60 195 90 180 120 165 135

plant_age5
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 285 90 240 45 225 75 270 135 300
Polygon -7500403 true true 165 285 210 240 255 225 225 270 165 300
Polygon -7500403 true true 135 90 150 60 165 90
Polygon -7500403 true true 165 240 210 195 255 180 225 225 165 255
Polygon -7500403 true true 135 240 90 195 45 180 75 225 135 255
Polygon -7500403 true true 165 195 210 150 255 135 225 180 165 210
Polygon -7500403 true true 165 150 210 105 255 90 225 135 165 165
Polygon -7500403 true true 135 195 90 150 45 135 75 180 135 210
Polygon -7500403 true true 135 150 90 105 45 90 75 135 135 165
Polygon -7500403 true true 165 105 210 60 255 45 225 90 165 120
Polygon -7500403 true true 135 105 90 60 45 45 75 90 135 120

plant_age5_flower
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 285 90 240 45 225 75 270 135 300
Polygon -7500403 true true 165 285 210 240 255 225 225 270 165 300
Polygon -7500403 true true 165 240 210 195 255 180 225 225 165 255
Polygon -7500403 true true 135 240 90 195 45 180 75 225 135 255
Polygon -7500403 true true 165 195 210 150 255 135 225 180 165 210
Polygon -7500403 true true 165 150 210 105 255 90 225 135 165 165
Polygon -7500403 true true 135 195 90 150 45 135 75 180 135 210
Polygon -7500403 true true 135 150 90 105 45 90 75 135 135 165
Polygon -7500403 true true 165 105 210 60 255 45 225 90 165 120
Polygon -7500403 true true 135 105 90 60 45 45 75 90 135 120
Polygon -7500403 true true 135 90 120 75 105 45 105 15 120 45 135 15 150 45 165 15 180 45 195 15 195 45 180 75 165 90

seed
false
0
Circle -7500403 true true 116 221 67

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.5
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
