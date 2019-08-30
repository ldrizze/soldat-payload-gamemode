# Folders
## classes
Classes descriptions. The file **should** be the **id** of class with extension *.txt*.

## waypoints
Map waypoints. Each waypoint should be in a new line. Waypoint file **MUST** have **start (S)** waypoint type and **end (E)** and least one **checkpoint (C)**.

**WAY TYPES**
 - S: Start Waypoint. Must have just one.
 - W: Waypoint that vehicle will run.
 - C: Checkpoint.
 - E: End Waypoint. Must have just one.

**Waypoint line format**
`WAY_TYPE;X_POSITION;Y_POSITION`

**Example**
*pl_payload_wip.xt*
``
S;-3336;-315  -> Where payload spawn and starts
W;-2836;-350  -> Waypoint to run
C;-2336;-315  -> Checkpoint
W;-1836;-315  -> Waypoint to run
C;-1436;-315  -> Checkpoint
E;-1336;-315  -> End waypoint and end game
``