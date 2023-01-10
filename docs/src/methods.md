## Methods and other functions

### Constructors

ringbuffer = Ring(itemtype, howmany)
ringbuffer = Ring(T, n; initializer=zero(T))

elemtype = <any type you use>
capacity = <max item count (length) of buffer>

ring = Ring(elemType, capacity)
     - buffer slots are *undef* 
     -  Ring(Int32, 1024)

ring = Ring(elemType, capacity, init::elemType)
     -  buffer slots are preset to *init*
     - Ring(Float32, 1024, floatmin(Float32))



```

### States

