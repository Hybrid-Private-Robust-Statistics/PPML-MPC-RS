The main simulation code for our protocol is contained in Programs/Source/trip_*.py.
The simulation code for the comparison with Naive MPC is contained in Programs/Source/bench_trip_mpc_proofs.py.
This is a software to benchmark  secure multi-party computation (MPC)
of input sharing, matrix multiplications and q-rank in the dishonest majority setting,
with malicious/active corruption.

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


### SPDZ

The SPDZ protocol uses preprocessing, that is, in a first (sometimes
called offline) phase correlated randomness is generated independent
of the actual inputs of the computation. Only the second ("online")
phase combines this randomness with the actual inputs in order to
produce the desired results. The preprocessed data can only be used
once, thus more computation requires more preprocessing. MASCOT and
Overdrive are the names for two alternative preprocessing phases to go
with the SPDZ online phase.

All programs required in this section can be compiled with the target `online`:

`make -j 8 online`

#### To setup for benchmarking the online phase

This requires the INSECURE flag to be set before compilation as explained above. For a secure offline phase, see the section on SPDZ-2 below.

Run the command below. **If you haven't added `MY_CFLAGS = -DINSECURE` to `CONFIG.mine` before compiling, it will fail.**

`Scripts/setup-online.sh`

This sets up parameters for the online phase for 2 parties with a 128-bit prime field and 128-bit binary field, and creates fake offline data (multiplication triples etc.) for these parameters.

Parameters can be customised by running

`Scripts/setup-online.sh <nparties> <nbitsp> [<nbits2>]`


#### To compile a program

To compile for example the program in `./Programs/Source/tutorial.mpc`, run:

`./compile.py tutorial`

This creates the bytecode and schedule files in Programs/Bytecode/ and Programs/Schedules/

#### To run a program

To run the above program with two parties on one machine, run:

`./mascot-party.x -F -N 2 0 tutorial`

`./mascot-party.x -F -N 2 1 tutorial` (in a separate terminal)

Or, you can use a script to do the above automatically:

`Scripts/mascot.sh -F tutorial`

MASCOT is one of the protocols that use SPDZ for the online phase, and
`-F` causes the programs to read preprocessing material from files.

To run a program on two different machines, firstly the preprocessing
data must be copied across to the second machine (or shared using
sshfs), and secondly, `mascot-party.x` needs to be passed the machine
where the first party is running. E.g., if this machine is named
`diffie` on the local network:

`./mascot-party.x -F -N 2 -h diffie 0 test_all`

`./mascot-party.x -F -N 2 -h diffie 1 test_all`

The software uses TCP ports around 5000 by default, use the `-pn`
argument to change that.

### SPDZ2k

Creating fake offline data for SPDZ2k requires to call
`Fake-Offline.x` directly instead of via `setup-online.sh`:

`./Fake-Offline.x <nparties> -Z <bit length k for SPDZ2k> -S <security parameter>`

You will need to run `spdz2k-party.x -F` in order to use the data from storage.

### Other protocols

Preprocessing data for the default parameters of most other protocols
can be produced as follows:

`./Fake-Offline.x <nparties> -e <edaBit length,...>`

The `-e` command-line parameters accepts a list of integers separated
by commas.

You can then run the protocol with argument `-F`. Note that when
running on several hosts, you will need to distribute the data in
`Player-Data`. The preprocessing files contain `-P<party number>`
indicating which party will access it.

### BMR

This part has been developed to benchmark ORAM for the [Eurocrypt 2018
paper](https://eprint.iacr.org/2017/981) by Marcel Keller and Avishay
Yanay. It only allows to benchmark the data-dependent phase. The
data-independent and function-independent phases are emulated
insecurely. This is implementation is independent of the default
design, so most of the previous documentation does not apply. In
particular, you cannot use `compile-run.py`.

By default, the implementations is optimized for two parties. You can
change this by defining `N_PARTIES` accordingly in `BMR/config.h`. If
you entirely delete the definition, it will be able to run for any
number of parties albeit slower.

Compile the virtual machine enabling insecure functionality:
```
echo MY_CFLAGS += -DINSECURE >> CONFIG.mine
make -j 8 bmr
```

After compiling the mpc file:

- Run everything locally: `Scripts/bmr-program-run.sh <program>
<number of parties>`.
- Run on different hosts: `Scripts/bmr-program-run-remote.sh <program>
<host1> <host2> [...]`

#### Oblivious RAM

You can benchmark the ORAM implementation as follows:

1) Edit `Program/Source/gc_oram.mpc` to change size and to choose
Circuit ORAM or linear scan without ORAM.
2) Run `./compile.py -G -D gc_oram`. The `-D` argument instructs the
compiler to remove dead code. This is useful for more complex programs
such as this one.
3) Run `gc_oram` in the virtual machines as explained above, for
example: `Scripts/bmr-program-run.sh gc_oram 2`.

This only works with the partially insecure BMR implementation, so you
cannot use any other protocol with it including Yao or any full BMR
implementation. See [the
documentation](https://mp-spdz.readthedocs.io/en/latest/Compiler.html#module-Compiler.oram)
on how to use ORAM in all other protocols.

## Preprocessing as required

For select protocols, you can run all required preprocessing but not
the actual computation. First, compile the binary:

`make <protocol>-offline.x`

At the time of writing the supported protocols are `mascot`,
`cowgear`, `mal-shamir`, `semi`, `semi2k`, and `hemi`.

If you have not done so already, then compile your high-level program:

`./compile.py <program>`

Finally, run the parties as follows:

`./<protocol>-offline.x -p 0 & ./<protocol>-offline.x -p 1 & ...`

The options for the network setup are the same as for the complete
computation above.

If you run the preprocessing on different hosts, make sure to use the
same player number in the preprocessing and the online phase.

## Benchmarking offline phases

#### Benchmarking the MASCOT or SPDZ2k offline phase

These implementations are not suitable to generate the preprocessed
data for the online phase because they can only generate either
multiplication triples or bits.

MASCOT can be run as follows:

`host1:$ ./ot-offline.x -p 0 -c`

`host2:$ ./ot-offline.x -p 1 -c`

For SPDZ2k, use `-Z <k>` to set the computation domain to Z_{2^k}, and
`-S` to set the security parameter. The latter defaults to k. At the
time of writing, the following combinations are available: 32/32,
64/64, 64/48, and 66/48.

Running `./ot-offline.x` without parameters give the full menu of
options such as how many items to generate in how many threads and
loops.

#### Benchmarking Overdrive offline phases

We have implemented several protocols to measure the maximal throughput for the [Overdrive paper](https://eprint.iacr.org/2017/1230). As for MASCOT, these implementations are not suited to generate data for the online phase because they only generate one type at a time.

Binary | Protocol
------ | --------
`simple-offline.x` | SPDZ-1 and High Gear (with command-line argument `-g`)
`pairwise-offline.x` | Low Gear
`cnc-offline.x` | SPDZ-2 with malicious security (covert security with command-line argument `-c`)

These programs can be run similarly to `spdz2-offline.x`, for example:

`host1:$ ./simple-offline.x -p 0 -h host1`

`host2:$ ./simple-offline.x -p 1 -h host1`

Running any program without arguments describes all command-line arguments.

##### Memory usage

Lattice-based ciphertexts are relatively large (in the order of megabytes), and the zero-knowledge proofs we use require storing some hundred of them. You must therefore expect to use at least some hundred megabytes of memory per thread. The memory usage is linear in `MAX_MOD_SZ` (determining the maximum integer size for computations in steps of 64 bits), so you can try to reduce it (see the compilation section for how set it). For some choices of parameters, 4 is enough while others require up to 8. The programs above indicate the minimum `MAX_MOD_SZ` required, and they fail during the parameter generation if it is too low.
