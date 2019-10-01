% Ranged Analysis Small, Only States Covering New

binaryNames = {'factor'; 'base64'; 'mkdir'; 'join'};
count = [15, 15, 14, 14];
ranged_count = [22, 18, 22, 8];
x = [1,2,3,4];
w1 = 0.5;
w2 = w1 / 2;

bar(x, count, w1, 'Number of test cases producted', [0.2 0.2 0.5]);

hold on
bar(x, ranged_count, w2, 'Number of test cases produced', [0 0.7 0.7]);
set(gca, 'xtick', [1:4], 'xticklabel', binaryNames);
hold off