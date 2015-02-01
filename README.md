Quantum Circuit Generator for LaTeX
======================================

This is a script that takes an ASCII representation of a quantum circuit and
generates commands to draw it in LaTeX's `picture` environment.

To use it, you must first copy the gates.tex file into the same folder as your
document and then, once, do:

    \input{gates.tex}

Once you have done that, the `picture` command generated by the script can be
placed anywhere below that line.

The script takes a text description of the circuit as input. This works as
follows. (1) Each line in the file is one line of the circuit. The first line in
the file is the top qubit. The last line in the file is the bottom qubit. (2)
Each letter on a line specifies the gate in that position for that qubit.

Currently, the only supported gates are I (identity), H, X, Z, and CNOT. The H,
X, and Z gates are specified with the letters that are their name, but CNOT is
a little bit tricky. To do a CNOT, you have to specify it on the *bottom* qubit,
and the vertical line will go upwards to the next qubit above. To put the
control on the bottom, use C, and to put the control on the top, use F. The
corresponding position in the top qubit must contain a B.

Example
=========

Here is circuit.txt:

    HZHBZ
    IIHCZ

Calling `ruby qcircuitgen.rb circuit.txt` outputs:

    \setlength{\unitlength}{.2in}
    \begin{picture}(25.5, 6)(0, 0)
    \put(0.0, 5.0){\usebox{\gatesep}}
    \put(0.0, 2.75){\usebox{\gatesep}}
    \put(1.5, 5.0){\usebox{\hgate}}
    \put(3.0, 5.0){\usebox{\gatesep}}
    \put(1.5, 2.75){\usebox{\gateunder}}
    \put(3.0, 2.75){\usebox{\gatesep}}
    \put(4.5, 5.0){\usebox{\zgate}}
    \put(6.0, 5.0){\usebox{\gatesep}}
    \put(4.5, 2.75){\usebox{\gateunder}}
    \put(6.0, 2.75){\usebox{\gatesep}}
    \put(7.5, 5.0){\usebox{\hgate}}
    \put(9.0, 5.0){\usebox{\gatesep}}
    \put(7.5, 2.75){\usebox{\hgate}}
    \put(9.0, 2.75){\usebox{\gatesep}}
    \put(12.0, 5.0){\usebox{\gatesep}}
    \put(10.5, 2.75){\usebox{\cnotB}}
    \put(12.0, 2.75){\usebox{\gatesep}}
    \put(13.5, 5.0){\usebox{\zgate}}
    \put(15.0, 5.0){\usebox{\gatesep}}
    \put(13.5, 2.75){\usebox{\zgate}}
    \put(15.0, 2.75){\usebox{\gatesep}}
    \end{picture}

Once rendered, this looks like:

![Circuit Image](https://defuse.ca/images/quantum-circuit-example.png)
