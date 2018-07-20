clear all
img = rand(500, 500, 1);
centersList{1} = {rand(9,9)};
computeDistances(img, centersList, 9);

%%
clear all
img = rand(500, 500, 3);
centersList{1} = {rand(9,9), rand(9,9), rand(9,9)};
computeDistances(img, centersList, 9);

%%
clear all
img = rand(500, 500, 1);
centersList{1} = {rand(9,9); rand(9,9); rand(9,9)};
computeDistances(img, centersList, [9, 27, 45]);