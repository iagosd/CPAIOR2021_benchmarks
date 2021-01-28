int: nCF = 25;
int: nDP = 236;

% Variables definition
% Component index selection
var 1..nCF: CF_idx;
var 1..nDP: DP_idx;

% Shaft size
int: shaft_w = 1500; % TODO replace with values to test
int: shaft_d = 1500; % TODO replace with values to test

% Car variables
var int: x_car;
var int: y_car;
var int: w_car;
var int: d_car;
var int: carS;
var int: Q;

% Car frame variables
var int: x_cf;
var int: y_cf;

% Car frame parameters
array[1..nCF] of int: w_cf;
array[1..nCF] of int: d_cf;
array[1..nCF] of int: maxOh;
array[1..nCF] of int: pStaf;
array[1..nCF] of int: cr_d_cf;
array[1..nCF] of int: clamps_d;
array[1..nCF] of int: clamps_w;
array[1..nCF] of int: clamps_s;
array[1..nCF] of int: brack_w1;
array[1..nCF] of int: brack_w2;
array[1..nCF] of int: brack_d;

% Car door variables
var int: x_cd;
var int: y_cd;

% Car door parameters
array[1..nDP] of int: opening;
array[1..nDP] of int: step_cd;
array[1..nDP] of int: step_dist;
array[1..nDP] of int: axL_cd;
array[1..nDP] of int: axR_cd;
array[1..nDP] of int: type_door;

% Landing door variables
var int: x_ld;
var int: y_ld;

% Landing door parameters
array[1..nDP] of int: step_ld;
array[1..nDP] of int: std_al;
array[1..nDP] of int: axL_ld;
array[1..nDP] of int: axR_ld;
array[1..nDP] of int: frameW;
array[1..nDP] of int: delta_door_pack;

% Constraint definition
% Car constraints
constraint x_car = w_cf[CF_idx] + 30;
constraint y_car = 60;
constraint w_car = shaft_w - 90 - w_cf[CF_idx];
constraint d_car = shaft_d - 90 - step_cd[DP_idx] - step_ld[DP_idx] - step_dist[DP_idx] + std_al[DP_idx];
constraint carS = w_car * d_car;
constraint Q = if carS < 370000 then 100 else 
              (if carS < 580000 then 180 else
              (if carS < 700000 then 225 else
              (if carS < 900000 then 300 else
              (if carS < 1100000 then 375 else
              (if carS < 1160000 then 400 else
              (if carS < 1300000 then 450 else
              (if carS < 1450000 then 525 else
              (if carS < 1600000 then 600 else
              (if carS < 1660000 then 630 else
              (if carS < 1750000 then 675 else
              (if carS < 1900000 then 750 else
              (if carS < 2000000 then 800 else
              (if carS < 2050000 then 825 else
              (if carS < 2200000 then 900 else
              (if carS < 2340000 then 975 else
              (if carS < 2400000 then 1000 else
              (if carS < 2500000 then 1050 else
              (if carS < 2650000 then 1125 else 
              (if carS < 2800000 then 1200 else 
              (if carS < 2900000 then 1250 else 
              (if carS < 2950000 then 1275 else 
              (if carS < 3100000 then 1350 else 
              (if carS < 3250000 then 1425 else 
              (if carS < 3400000 then 1500 else 
              (if carS < 3560000 then 1600 else 
              (if carS < 4190000 then 2000 else 
              2500 endif) endif) endif) endif) 
              endif) endif) endif) endif) endif) 
              endif) endif) endif) endif) endif) 
              endif) endif) endif) endif) endif) 
              endif) endif) endif) endif) endif) 
              endif) endif) endif;

% Car frame position
constraint x_cf = 0;
constraint y_cf >= pStaf[CF_idx];
constraint y_cf + d_cf[CF_idx] + pStaf[CF_idx] <= shaft_d;

% Car frame overhang
constraint y_cf + cr_d_cf[CF_idx] - y_car >= 1;
constraint y_cf + cr_d_cf[CF_idx] - y_car <= maxOh[CF_idx];
constraint y_car + d_car + cr_d_cf[CF_idx] - y_cf - d_cf[CF_idx] >= 1;
constraint y_car + d_car + cr_d_cf[CF_idx] - y_cf - d_cf[CF_idx] <= maxOh[CF_idx];

% Doors position - margin 30mm (x axis)
constraint x_ld = x_cd + axL_cd[DP_idx] - axL_ld[DP_idx];
constraint x_cd >= 30;
constraint x_ld >= 30;
constraint x_cd + axL_cd[DP_idx] + axR_cd[DP_idx] <= shaft_w - 30;
constraint x_ld + axL_ld[DP_idx] + axR_ld[DP_idx] <= shaft_w - 30;
constraint x_cd + axL_cd[DP_idx] - (opening[DP_idx] div 2) >= x_car;
constraint x_cd + axL_cd[DP_idx] + (opening[DP_idx] div 2) <= x_car + w_car;
constraint x_ld + axL_ld[DP_idx] - (opening[DP_idx] div 2) - frameW[DP_idx] + delta_door_pack[DP_idx] >= 30;
constraint x_ld + axL_ld[DP_idx] + (opening[DP_idx] div 2) + frameW[DP_idx] - delta_door_pack[DP_idx] <= shaft_w;

% Doors position (y axis)
constraint y_cd = shaft_d - step_cd[DP_idx] - step_ld[DP_idx] - step_dist[DP_idx] + std_al[DP_idx];
constraint y_ld = y_cd + step_cd[DP_idx] + step_dist[DP_idx];

% No-overlap constraints
constraint x_cd - 30 >= brack_w1[CF_idx] \/ y_cd - 30 >= y_cf + brack_d[CF_idx] - pStaf[CF_idx];
constraint x_cd - 30 >= brack_w2[CF_idx] \/ y_cd - 30 >= y_cf + d_cf[CF_idx];
constraint x_cd - 30 >= clamps_w[CF_idx] \/ y_cd - 30 >= y_cf + clamps_d[CF_idx] + clamps_s[CF_idx];

var int: cf_cost;
var int: dp_cost;
constraint int_abs(y_cf + d_cf[CF_idx] div 2 - y_car - d_car div 2, cf_cost);
constraint int_abs(x_car + w_car div 2 - x_cd - axL_cd[DP_idx], dp_cost);

solve minimize (type_door[DP_idx] * (w_car + x_car - x_cd - axL_cd[DP_idx] - opening[DP_idx] div 2) +
 (1 - type_door[DP_idx]) * dp_cost +
 cf_cost);