# THE KVIKKALKUL PROGRAMMING LANGUAGE

Note: this message contains top secret information of the Swedish Navy. Possession of this information in Sweden can (and will in most cases) lead to Capital Punishment. DO NOT DISTRIBUTE THIS INFORMATION TO SWEDEN!!!

## INTRODUCTION

When I worked for the Swedish Navy in 1957 as a programmer, my task was to write programs for the SABINA computer, one of the first transistorised computers in the world, manufactured by SAAB for use on Swedish submarines.

The computer was located on a test facility in Karlskrona, the Swedish Navy base. All programming was done in a funky language called 'kvikkalkul', a language that makes Assembler (or even INTERCAL) look friendly.

The mere existence of SABINA and the programming language 'kvikkalkul' was and still is top secret. Other top secrets of that age leaked into publicity long ago, but this one is still preserved. Until now.

Apart from real-time submarine applications such as guided torpedo control, I did an accounting package in kvikkalkul as well.

## THE CHARACTER SET

Kvikkalkul was typed on Baudot encoded teletype machines. Programs were stored on paper tape. As you might know, Baudot is a five bit code. The machine can be in two modes, the 'letters' mode and the 'figures' mode. In 'letters' mode you have the 26 letter symbols, in 'figures' mode you have the ten digits and some punctuation marks. The codes to switch to the 'letters' or 'figures' mode, the space, the linefeed and carriage return codes are available in both modes. Kvikkalkul used symbols from the 'figures' mode exclusively, therefore it had no letters. If you typed letters in your program they were interpreted as the corresponding 'figures' mode symbols. Kvikkalkul had no comments or text literals either; there were no letters in the language. Period.

The available symbols were: CR/LF, Space, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, period(.), comma(,), quote("), colon(:), dash(-), slash(/) and the left and right parentheses ( and ).

Each statement was on a separate line.

## THE NUMBER SYSTEM

The only data type in kvikkalkul was the signed fixed point fractional number. The reason for this was that the precision of numbers could be extended without breaking existing programs. Kvikkalkul was designed for such things as real time control, so this seemed sensible. The downside was that you had no integers or whatever other data type. Even arrays were indexed with fractional numbers.

The minimum precision you could rely on was 15 bits. This is a sign bit and 14 significant fractional bits. The representation was one's complement. The data word with all bits set (minus zero) denoted overflow. There were 16383 positive numbers, 0 and 16383 negative numbers. The minimum number was a bit higher than -1 and the maximum number was a bit lower than 1. You didn't have numbers greater than 1, even not 1 itself.

Every operation that would produce a result outside the range (-1,1) would return the special overflow value with all bits set.

Numbers were entered as decimal fractions, starting with a comma (the Swedish representation for decimal point). e.g. ,125 denotes 1/8.

Kvikkalkul had the following operators:

### Assignment/pointer

* (- Assignment
* -) Points to
* (( Previous
* )) Next

### Arithmetic

* -/- Plus
* -- Minus
* )( Times
* -:- Divide
* \- Unary Minus

### Relational

* :: Equal
* :/: Not Equal
* ( Less
* ) Greater
* (: Less or Equal
* ): Greater or Equal

Assignment statements consisted of an object, the assignment operator and an expression. The expression consisted of one operand or two operands separated by an arithmetic operator. An operand was either a number or an object with an optional unary minus operator. Below are two assignment statements

* .9 (- ,5
* .8 (- .9 )( -,33333333

The first assigns 1/2 to register 9, the second one multiplies register 9 by 1/3 and assigns that to register 8.

## THE PROGRAM OBJECTS

The kvikkalkul objects are registers, data pointers, program pointers and channels. They are denoted by a special symbol followed by a digit.

There are 10 objects of each type, numbered from 0 to 9. In fact there were 16 of each, but the other six were secret and for internal use by the library routines only.

### 1 REGISTERS

A register can store one number. Registers are denoted by a period(.) followed by a digit. Registers my be used in assignment statements and as operands in conditional jump statements.

### 2 DATA POINTERS

A data pointer points to a data area in memory. Data pointers are denoted by a slash (/) followed by a digit. Data pointers may be used as registers in assignment statements and conditional jump statements. The contents of the memory location the data area points to are used in that case. Before you can use a data pointer that way, you have to make it point to a memory location and you have to reserve memory for it.

The statement:

```
333/ 44
```

declares a storage area for 44 numbers with the label 333.

```
/0 -) 333
```

makes data pointer 0 point to the first number in that area.

```
/0 (- ,12
```

stores the number ,127 into that location.

```
/0 ))
```


makes data pointer 0 point to the next location in that area.

```
/0 ((
```

makes it point to the previous location.

Making the pointer point to a random location in the data area, it a bit tricky. First you have to determine the smallest power of two that is not less than the size of the data area. For area 333, that is 64. To point to location n (counting from zero) you have to use a number that's n/64, e.g. location 16 is the number ,25 The following statement makes the pointer point to the desired location.

```
/0 -) 333 ,25
```

The second operand may also be a register or a data pointer.

### 3 PROGRAM POINTERS

A program pointer points to a location in the program. Program pointers are denoted by a colon (:) followed by a digit. Program pointers cannot be used as ordinary operands in assignment statements and such.

You can declare labels in your program and you can make program pointers point to them. Then you can jump to those pointers.

The statement

```
4400:
```

declares a program label 4400:

```
:2 -) 4400
```

makes program pointer 2 point to label 4400.

```
-) :2
```

jumps to program pointer 2, in this case it's the label 4400.

Program pointer 0 is the default subroutine return address. Look at the following program.

```
.0 (- ,375
:0 -) 6000
:1 -) 100
-) :1
6000:
```

First a value is assigned to register 0. Then program pointer 0 is made to point to label 6000. Then program pointer 1 is made to point to label 100. Next that pointer is jumped to. At label 100 there is the standard subroutine to print the contents of register 0 to the teletype. After that's done the subroutine jumps to program pointer 0, and that's label 6000.

There is also a conditional jump, which consists of two operands separated by a relational operator followed by an ordinary jump statement.

```
.0 ( ,0 -) :4
```

means jump to program pointer 4 if register 0 is less than zero.

There are also program pointer storage areas. You declare them as data storage areas but with /: instead of /

```
666/: 32
```

reserves a program pointer storage area for 32 pointers.

You can set a data pointer to this area. If you do this it is illegal to use that data pointer for data, but now it is legal to assign program pointers to the data pointer and back.

```
:3 -) 7777
/4 (- :3
```

stores the label 7777 (through program pointer 3) into the location the data pointer 4 points to.

```
:5 (- /4
```

sets program pointer 5 to the contents of the memory location the data pointer points to, in this case label 7777

### 4 CONSTANTS

Constants are just constants. These are quantities that are hard to type otherwise. A constant is denoted by a quote(") followed by a digit. They may be used as ordinary arithmetic operands, but not on the left hand side of an assignment.

* "0 is the minimum number ( -,9999999999999999)
* "1 is the smallest distance between two numbers ( 2^-14)
* "2 is the special overflow value.
* "3 is 1/pi
* "4 is ln 2
* "5 is 1/32
* "6 is 1/sqrt(2)
* "7 is sqrt(3)/2
* "8 is log 2 (base 10)
* "9 is the maximum number ( ,9999999999999999)

### 5 CHANNELS

Channels are the input/output devices of the computer. Channels are denoted by surrounding a digit with parentheses. Channels may be used as operands in arithmetic expressions and conditional jump statements. In this case the channel is read. They may also be used as the left hand side of an assignment expression. In this case a value is written to the channel.

* (0) is the teletype channel. The value sent to it/ received from it is the binary value of the Baudot code divided by 32. If the channel is read and no character is available, a negative value is returned.

* (1) is the paper tape channel. Same remarks as for (0).
* (2) is the real time clock. It can only be read. Runs from "0 to "9 in one hour, then returns to "0 again.
* (3) was the random number generator. It could only be read. This was implemented using germanium noise diodes and it was very unreliable. If it ran hot, it returned all 1 bits (overflow value) almost all the time. Its use was highly discouraged.
* (4) to (7) are connected to radar, torpedoes or whatever stuff the computer is supposed to control.
The statement

```
(0) (- ,03125
```

sends Baudot code 1 to the teletype.

### PROGRAM AND DATA LABELS

Data areas and program pointer storage areas are denoted by numeric labels in the range 0--32767. The labels above 30000 are reserved for internal use only and may not be used. A program pointer storage area and a data area may not have the same label.

Program labels are numbers in the range 0--32767. Numbers below 1000 are reserved for standard subroutines. Numbers above 30000 are reserved for internal use only and may not be used.

Note that kvikkalkul does not have integers or scaled fractions. But some of the library routines treat their arguments as if they were scaled fractions in the range (-256,256) or integers in the range (16383,16383).

Some of the library routines I still remember are.

* 11 Multiply integers .0 is .0 times .1
* 12 Divide integers. .0 is .0 div .1
* 21 convert fraction to scaled fraction.
* 22 convert fractional part of scaled fraction to fraction.
* 31 Multiply scaled fractions.
* 32 Divide scaled fractions.
* 48 Wait until character ready on teletype, read to .0
* 49 same for paper tape.
* 100 Writes the contents of .0 to the teletype in decimal fraction format.
* 101 same for paper tape.
* 150 Reads a decimal fractional number from the teletype to .0
* 151 same for paper tape.
* 200 send CRLF to teletype
* 201 same for paper tape
* 250 wait until CRLF received from teletype
* 251 same for paper tape.
* 300/301 350/351 Number read/write routines for integers in the range -16383 .. * 16383.
* 302/303 352/353 Same for Scaled fractions (-256,256)
* 400 square root. (argument and result in .0)
* 450 Sine (where -1..1 as argument was interpreted as -180..180 degrees)
* 460 Cosine.
* 470 Arctan (argument is scaled fraction, result is scaled to (-1,+1)
* 480 Log (1+x) (base 2)
* 490 2^x-1
* 530 Read a line from the teletype into memory pointed to by /0, one character per number 0..1 in steps of ,03125
* 531 Same for paper tape.
* 540 Write a line to paper tape from memory pointed to by /0, one character per number.
* 541 Same for paper tape.
* 550/551 560/561 Line read/write routines that packed three characters per number, first was 5 most significant bits. These were stored more efficiently but a HELL to process, as negatives, positives and even overflow was a valid character triplet.
* 900 Read hour number to .0 Must be called at least twice an hour, because it relies on the positive/negative transition of (2) to increment the internal hour number.
* 666 emergency stop.
* 888 Dump internal program state to paper tape and stop. Many programs needed to do a lot of processing to initialize tables. If text strings were needed, they were read from teletype and/or paper tape and not written in the program itself. So each nontrivial program had an initialization phase in which it read data and computed numbers for tables. Then the program called 888. The resulting dump could be used by the kvikkalkul compiler to generate a program with all tables already initialized.

## KVIKKALKUL TODAY

I left the Swedish Navy in 1958 and now I live in a country whose name I rather not tell. I fear that I will be extradited to Sweden if the Swedish authorities see this message. What I described was the state of kvikkalkul in 1958. What I tell in this section is based on rumours, on tiny pieces of information I got from colleagues and on intelligent guesswork.

Kvikkalkul is still in use today, at least that was the case in 1991. There is an Ada to kvikkalkul translator and most new programs are written in Ada and then translated to kvikkalkul. The kvikkalkul version was the definitive program that was reviewed, approved, tested and maintained. There was also a Simula to kvikkalkul translator in the 70s and some programs were written with it.

Some changes have been made to the language.

The guaranteed precision of numbers was increased over the years and is now at least 32 bits. Valid label numbers are now in the range 0..4000000000 with some haphazard reserved areas for library routines and internally used labels. Most library routines that are widely used today lie in the range 60001-65535. I have no details of them.

The language itself remained remarkably constant. It's still a language without letters and the smiley notation for operators in still in use, though for source text the angle brackets may be used instead of parentheses and + and = are valid substitutes for the -/- and :: operators. Now new construct have been added and the only data type in the language is still the fixed point fractional number. Channel number 3 for the random generator has been deleted and numbers 8 and 9 were added.

Channel 9 is the OS supervisory channel. By sending messages to it, you can assign arbitrary files to the channels 0, 1, and 3 through 7. You can specify the character conversion type of the channels. It is possible to connect channel 0 to an ASCII terminal and convert all incoming characters to (more or less) Baudot equivalents and convert all outgoing Baudot characters back to ASCII. In fact this is the default for channels 0 and 1. All typical OS services can be accessed through channel 9.

Channel 8 is the floating point processor. You can send numbers and opcodes to it and retrieve the computed results. The numbers that you send to it are 32-bit fractionals that bear no relationship to the FP numbers as the FP processor sees them. There are library routines for printing and reading them. The 640000 type standard FP library calls were made obsolete by channel 8. They still work.

An ex-colleague of mine tried my accounting package from 1958 on a modern kvikkalkul compiler in 1991. It still works flawlessly, except that the year cannot be set beyond 1973. He had to retype the program by hand as there was no suitable 5-bit Baudot paper tape reader for the system.
