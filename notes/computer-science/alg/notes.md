- Floyds cycle finding algorithm

<!-- tag: #link-list #floyds #cycle #loop #pointer -->

Prove:

Set the position of the fast pointer to $f$
Set the position of the slow pointer to $s$
Set the loop length to $c$

So, the distance of the $f$ and $s$ is $| f - s |$, which is half of the
loop length $c/2$. This means that the distance will go to a maximum
value $c / 2$, and then it will go down.

For example, when let we set the distance to d.

Each time $s$ go 1 point, $d + 1$;
Each time $f$ go 2 points, $d - 2$;

So $d$ will always decrease 1, and $d$ is positive integer, it will go
to zero oneday, and that is the time two pointer met.

- log structure file system

<!-- tag: #database #log-structure -->

The fundamental idea of a log-structured file system
is to improve **write** performance

Feature:

* can speed up file writing and crash recovery
* contains indexing information so files can be read back
* use segment to divide the disk space
* use segment cleaner to compress
* outperform unix fs for small write, exceed for large write

Notes:

* Processor, disk and main memory are significant for fs
* Disk performance limits: transfer bandwidth, access time
* Large main memories caches the **read** request, so write
request dominated the disk traffic.
* Large main memories also perform as a buffer for large
numbers of write.

Disk Problems in 1990s:

* To many small operations
* Not concurrently, applications must wait on I/O block.
* Application's speed is limited by the disk performance.

Two important issue that require attention:

* How LFS retrieve information from log
* How LFS manage the free space on disk

LFS read operation is identical in Unix FFS:

* For each file there exists a data structure called an inode,
which contains the file’s attributes (type, owner,
permissions, etc.) plus the disk addresses of the first ten
blocks of the file; for files larger than ten blocks, the
inode also contains the disk addresses of one or more indirect
blocks, each of which contains the addresses of more data or
indirect blocks.
