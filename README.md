LifeHistGame
============

Agent-based simulation of competition between plants using different reproductive strategies. 

Written for the Polish [Biologists Night](http://www.nocbiologow.home.pl/index.php) event.

To see it working, download [LifeHistGame.nlogo](https://github.com/martaczc/LifeHistGame/archive/master.zip) file and open it using [NetLogo](https://ccl.northwestern.edu/netlogo/) (available for free).

![Screenshot](screenshot.png)

This model simulates competition for space between simple, sedentary, plant-like organisms. They use different life strategies, in sense of different maturation age and single or multiple reproduction.

[Life history theory](http://en.wikipedia.org/wiki/Life_history_theory) is a part of the evolutionary biology that aims to explain how the duration and schedule of key events in life of organisms (such as development, sexual maturation and senescence) are shaped by the natural selection to maximize the reproduction output of individuals. This theory puts emphasis on the tradeoffs that each organism have to make in the context of:

* resource allocation into growth, reproduction and regeneration, 
* quantity vs quality of offspring,
* predator avoidance vs maximization of food intake,
* etc. 

In this simulation the user can set maturation age and reproduction investment of each plant type. Later maturation let the organism grow longer and hence make it able to invest more in future seed production. On the contrary, earlier maturation makes the plant more likely to survive to the reproduction age. Thanks to shorter generation time, population of such plants are able to grow more rapidly, producing grandchildren and grand-grandchildren before their competitors even start reproducing.

The reproduction investment settings allows user to choose between [semelparous or iteroparous](http://en.wikipedia.org/wiki/Semelparity_and_iteroparity) strategy of each plant type. Semelparity means that an organism reproduce only onece in its life, uses all its resources in the offspring production and dies shortly afterwards. It is observed in many real-world plants (eg. wheat, carrot, agava, bamboo) and some animals (eg. mayfly, some species of squids and salmons). The second strategy, iteroparity, means that only part of the resources is used for offspring production and the remaining part is spend for survival untill the next breeding season.

This model allows user to test performance and competitive abilities of each arbitrally chosen strategy. The limiting factor, for which plants compete, is the free space. The competition is mediated by the limited resources, not interactions between individuals (finite version of the "nest site lottery" [1]).

## CREDITS AND REFERENCES
[1] Argasinski, K., & Broom, M. (2013). **The nest site lottery: How selectively neutral density dependent growth suppression induces frequency dependent selection.** Theoretical Population Biology, 90, 82-90. [doi:10.1016/j.tpb.2013.09.011](http://dx.doi.org/10.1016/j.tpb.2013.09.011), freely available on ArXiv: [arXiv:1303.0564](http://arxiv.org/abs/1303.0564).
