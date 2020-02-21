#!/bin/bash

awk -F "\t" 'NR > 1 {
region = $13;
state = $11;
prod_name = $17
profit = $21;
regions[region] += profit;
states[region, state] += profit;
products[region, state, prod_name] += profit;

}
END {
# find the region that has the least profit
# min_region: name region that has the least profit
for (region in regions) {
  # set first value of min_region as one of the keys in regions
  if (min_region == "" ) {
    min_region = region;
    continue;
  }
  # if found curr region is lower value, set min_value to region with lower value
	if ( regions[region] < regions[min_region]) {
		min_region = region;
	}
}

print "region least profitable: " min_region "= " regions[min_region];

# remove all data thats from other regions
# remove data from states array
for (key in states) {
  split(key, res, SUBSEP);
  region = res[1]; state = res[2];
  if (region != min_region) {
    delete states[key];
  }
}


# remove data from products array
for (key in products) {
  split(key, res, SUBSEP);
  region = res[1]; state = res[2]; product = res[3];
  if (region != min_region) {
    delete products[key];
  }
}
# end of removing data based on region

# smallest_state state with smallest
# small_state state second smallest
# find 2 smallest state profit value
for(key in states) {
  split(key, res, SUBSEP);
  region = res[1]; state = res[2];
  # set inital value of smallest_state variabel as one of the states
  if ( smallest_state == "") {
    smallest_state = state;
    continue;
  }

  # initialize value of small_state as one of the states
  if ( small_state == "" ) {
    # check if its current is smaller than current smallest
    if ( states[key] < states[region, smallest_state] ) {
      small_state = smallest_state;
      smallest_state = state;
    } else {
      small_state = state;
    }
    continue;
  }

  # if found new smallest value, update smallest
	if ( states[key] < states[region, smallest_state]) {
		small_state = smallest_state; 
		smallest_state = state;
	# If value is in between smallest and small then update small
	} else if ( states[key] < states[region, small_state] && states[key] != states[region, smallest_state] ) {
		small_state = state;
	}
}

# print least profitable state and second least profitable state
print "least profitable state: " smallest_state "= " states[min_region, smallest_state];
print "second least profitable state: " small_state "= " states[min_region, small_state];


# remove all data in products aray thats from other states
for (key in products) {
  split(key, res, SUBSEP);
  region = res[1]; state = res[2]; product = res[3];
  if (state != smallest_state && state != small_state) {
    delete products[key];
  }
}

# sum all products from the smallest_state and small_state
for (key in products) {
  split(key, res, SUBSEP);
  region = res[1]; state = res[2]; product = res[3];
  sum_products[product] += products[key];
}


# sort products from least profit to most profit
PROCINFO["sorted_in"]="@val_num_asc"
print "10 least profitable products";
i = 1;
for(product in sum_products) {
  if (i <= 10) {
    print i ". " product "= " sum_products[product]
    i++
  } else {
    break;
  }
}
}' ~/Downloads/Sample-Superstore.tsv
