#!/usr/bin/env ruby

# Copyright (c) 2015 Taylor Hornby
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

if ARGV.length != 1
  puts "Usage: ruby qcircuitgen.rb <circuit file>"
  puts "    One qubit per line. Gates Z, X, H, and I (identity)."
  puts "    CNOTs specified on bottom qubit, with line going up."
  puts "    C for control on the bottom. F for control on the top."
  puts "    On the other side of the CNOT, you must put a B (blank)."
  exit(false)
end

qubits = File.readlines(ARGV[0])

# Strip newlines and remove empty lines.
qubits.map! { |l| l.chomp }
qubits.reject! { |l| l.empty? }

if qubits.empty?
  puts "You need at least one qubit line."
  exit(false)
end

# Make sure all lines are the same length.
lengths = qubits.map { |l| l.length }
if lengths.min != lengths.max
  puts "Qubit lines must be the same length (Use I if necessary)."
  exit(false)
end

QUBIT_COUNT = qubits.length
GATE_COUNT = qubits[0].length

puts "\\setlength{\\unitlength}{.2in}"
puts "\\begin{picture}(#{3*GATE_COUNT + 1.5}, #{1.5 + QUBIT_COUNT*2.25})(0, 0)"

def qubitpos(qubit)
  return (1.5 + QUBIT_COUNT*2.25) - 1.5/2 - 2.25*qubit
end

x_pos = 0.0
0.upto(QUBIT_COUNT - 1) do |qubit|
  puts "\\put(#{x_pos}, #{qubitpos(qubit)}){\\usebox{\\gatesep}}"
end
x_pos += 1.5

0.upto(GATE_COUNT - 1) do |gate|
  0.upto(QUBIT_COUNT - 1) do |qubit|
    # Draw the gate
    case qubits[qubit][gate]
    when "H"
      puts "\\put(#{x_pos}, #{qubitpos(qubit)}){\\usebox{\\hgate}}"
    when "Z"
      puts "\\put(#{x_pos}, #{qubitpos(qubit)}){\\usebox{\\zgate}}"
    when "X"
      puts "\\put(#{x_pos}, #{qubitpos(qubit)}){\\usebox{\\xgate}}"
    when "C"
      puts "\\put(#{x_pos}, #{qubitpos(qubit)}){\\usebox{\\cnotB}}"
    when "F"
      puts "\\put(#{x_pos}, #{qubitpos(qubit)}){\\usebox{\\cnotA}}"
    when "B"
      # Ignore, a CNOT is being drawn beneath us. Leave it blank.
    when "I"
      puts "\\put(#{x_pos}, #{qubitpos(qubit)}){\\usebox{\\gateunder}}"
    end

    # Draw the line following the gate
    puts "\\put(#{x_pos + 1.5}, #{qubitpos(qubit)}){\\usebox{\\gatesep}}"
  end
  x_pos += 1.5 + 1.5
end

puts "\\end{picture}"

