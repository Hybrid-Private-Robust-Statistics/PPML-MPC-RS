## Use of MP-SPDZ in our protocol: 
MP-SPDZ operates using the online-offline paradigm. The offline phase is independent of the input but depends on the input size and the number of parties. The online phase operates faster using  the precomputed values from the offline phase. Since the precomputed values cannot be reused across multiple online phases, in our experiments the reported timings include both the online and offline phase. 
Among the different offline protocols that the MP-SPDZ library provides, we choose Overdrive \cite{keller_overdrive_2018} because it offers malicious security and performs slightly better than other schemes in our setting, e.g., MASCOT  \cite{keller_mascot_2016}, which does not support Beaver
\emph{matrix} multiplication triples and therefore incurs higher costs for the matrix-heavy computations required by our protocol. Overdrive uses authenticated secret sharing with SPDZ-style MACs to ensure privacy and correctness of all computations. 

## Overhead
In MP-SPDZ, we implement and measure the overhead from matrix multiplications on secret-shared values (needed in the ADMM model update), the secure sharing of private values among multiple parties, the secure protocol to compute the $q$-th quantile of the joint dataset, and the DP noise sampling.


The main simulation code for our protocol is contained in Programs/Source/trip_*.py.
The simulation code for the comparison with Naive MPC is contained in Programs/Source/bench_trip_mpc_proofs.py.
This is a software to benchmark  secure multi-party computation (MPC)
of input sharing, matrix multiplications and q-rank in the dishonest majority setting,
with malicious/active corruption.

## AWS execution
In aws/aws.txt one can find instructions on how to set up AWS EC instances for our setting.

In aws/mpc one can find the scripts to run our benchmarks.

Below we will describe the main logic behind the scripts

This simulation is a fork from [MP-SPDZ](https://github.com/data61/MP-SPDZ).
For more information check [The official documentation](https://mp-spdz.readthedocs.io/en/latest).


### Installation (Source from GitHub)

You need to have
Git[https://git-scm.com/book/en/v2/Getting-Started-Installing-Git] in
order to clone the repository.

On Linux, this requires a working toolchain and [all
requirements](#requirements). 

On Ubuntu, the following suffices:

```
sudo apt-get install automake build-essential clang cmake git libboost-dev libboost-filesystem-dev libboost-iostreams-dev libboost-thread-dev libgmp-dev libntl-dev libsodium-dev libssl-dev libtool python3
```
### Simulating the WAN setting:
We recomment having access to 10 different machines to simulate the communication in a WAN setting. We assume the servers are called `party0, party1, ..., party9` and that we have `ssh` access to them.
   It is also assumed that the SSH login is possible without password. This
   can be achieved using password-less SSH keys. See [this
   tutorial](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)
   for more information.
If the benchmarks are run locally skip to 'Local Simulation'


2. Execute the following for the underlying setup and sharing mechanism:

```
make setup
make -j8 lowgear-party.x
```

3. Compile the program to obtain the executable for each party:
   ```
   ./compile-parties.sh
   ```
4. Run the program to obtain the results as:
    ```
    ./launch-parties.sh
    ```
   
   

### Local Simulation (not recommended)


#### Requirements

 - GCC 7 or later (tested with up to 14) or LLVM/clang 11 or later
   (tested with up to 20). The default is to use clang because it performs
   better.
 - GMP library, compiled with C++ support (use flag `--enable-cxx`
   when running configure). Tested against 6.2.1 as supplied by
   Ubuntu.
 - libsodium library, tested against 1.0.18
 - OpenSSL, tested against 3.0.2
 - Boost.Asio with SSL support (`libboost-dev` on Ubuntu), tested against 1.81
 - Boost.Thread for BMR (`libboost-thread-dev` on Ubuntu), tested against 1.81
 - x86 or ARM 64-bit CPU (the latter tested with AWS Gravitron and
   Apple Silicon)
 - Python 3.5 or later

#### Execution

    - First compile the virtual machine:
    
    `make -j8 lowgear-party.x`
    
    and a high-level program, for example the tutorial (use `-R 64` for
    SPDZ2k and Semi2k and `-B <precision>` for SemiBin):
    
    `./compile.py -F 64 tutorial`
    
    To run the tutorial with two parties on one machine, run:
    
    `./lowgear-party.x -N 2 -I -p 0 bench_trip`
    
    `./lowgear-party.x -N 2 -I -p 1 bench_trip` (in a separate terminal)


