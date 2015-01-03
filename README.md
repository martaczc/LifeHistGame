LifeHistGame
============

Life history simulation for Biologists Night

This model simulates competition for spece between for simple, sedentary, plant-like organisms, using different life strategies, in sense of different maturation age and single or multiple reproduction.

Life history theory is a part of the evolutionary biology that aims to explain how the duration and schedule of key events in life of organisms (such as development, sexual maturation and senescence) are shaped by natural selection to maximize the reproduction output of individual. This theory also points out the tradeoffs that each organism have to made in context of resource allocation into growth, reproduction and regeneration, quantity or quality of offspring, predator avoidance versus maximization of food intake etc. 

The user can set  maturation age and reproduction investment of each plant type. Later maturation let the organism grow longer and hence make it able to invest more in seed production in the future. In the contrary, earlier maturation makes the plant more likely to survive to the reproduction age and because of shorter generation time, population of such plants are able to grow more rapidly, producing grandchildren and grand-grandchildren before their competitors even start reproduction.

The reproduction investment settings allows user to choose between semelparous or iteroparous strategy of each plant type. Semelparity is observed in many real-world plants (eg. wheat, carrot, agava, bamboo) and some animals (eg. mayfly, some species of squids and salmons), and means that organism reproduce only onece in its life, uses all resources in offspring production and die shortly afterwards. The second strategy, iteroparity, means that only part of the resources is used for offspring production and the remaining part is spend for survival untill next breeding season.

This model allows user to test performance of each arbitrally choosed strategy and its competitive abilities. The limiting factor is the free space and the winner in contest for each available spot (left after death of the resident plant) depends only on whole amount of seeds of each type in the population. Hence the competition is mediated by the limited resources, not interactions between individuals (finite version of "nest site lottery" [1])

## CREDITS AND REFERENCES
[1] Argasinski, K., & Broom, M. (2013). The nest site lottery: How selectively neutral density dependent growth suppression induces frequency dependent selection. Theoretical population biology, 90, 82-90. ([doi:10.1016/j.tpb.2013.09.011](http://dx.doi.org/10.1016/j.tpb.2013.09.011), see on ArXiv: http://arxiv.org/abs/1303.0564)
