# From the Deep

In this problem, you'll write freeform responses to the questions provided in the specification.

## Random Partitioning

First of all, an upside is the even distribution of the data, therefore resulting in an even distribution of workload for all boats / servers. However, since the data isn't distributed in a logical structure, it is both more difficult and recource-consuming to query since all boats have to be searched.

## Partitioning by Hour

This approach fixes the previous issue of querying by organizing and distributing the data following fixed patterns because only one boat has to be searched, favoring the approach of using ranges. On the other hand, we loose the upside of even distribution, probably resulting from different marine activities at different times. 

## Partitioning by Hash Value

Just like with random partitioning, an upside is the even distribution of the data, therefore resulting in an even distribution of workload for all boats / servers. Besides if the exact target time is known you clearly know which boat to search, however coming at the cost of the efficeny for ranges. This is why random partitioning's downside of querying remains, because all boats have to be used to run a query.
