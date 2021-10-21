---
title:
- Types and Type Systems
subtitle:
- surprise! there's calculus in C++
author:
- Jack Leightcap
date:
- October 21, 2021
institute:
- Northeastern University Wireless Club
theme:
- Copenhagen
---

# Types: Intro

## C++
```C++
unsigned long length(std::String s) {
    // ...
}
```

## Python

```python
def length(s):
    # ...
```

# Types: Intro (cont.)

what's even the point of types?

## C++: Type Checking

```C++
unsigned long l = length(2 + 3);
// fails at compile-time
// you can't even run this program
```

## Python: Duck Typing

```python
l = length(2 + 3)
# does this fail? maybe.
```

# Types: Type Systems

even built-in types can't save us.
some more nuance,

```C++
uint32_t read_adc(void) {
	// returns the ADC reading in millivolts.
	return reading;
}

uint32_t volts = read_adc();
volts_to_expensive_delicate_device(volts);
```

this type checks, but does not convey the meaning we intended.
**types didn't save us here**.


# Type Systems: Adding Types

```C++
typedef struct {
	uint32_t mv;
} Millivolt;

// no longer compiles.
uint32_t v = read_adc(void);

// instead,
Millivolt v = { .mv = read_adc(void) };
// this is called a 'wrapper type'
```

# Type Systems: Syntax

## Wrapper Type
```C++
typedef struct {
	uint32_t mv;
} Millivolt;
```

becomes

```haskell
newtype Millivolt = Millivolt Int
```

## Structures
collection of things.

```C++
struct Record {
	std::string name;
	int value;
};
```

becomes

```haskell
data Record = Record { name :: String, value :: Int }
```

# Type Systems: Syntax (cont.)

## Tagged Unions
exactly one of these possible things.

```C++
enum RecordType { A, B, C };
struct RecordA { int a; };
struct RecordB { int b; };
struct RecordC { int c; };
struct Record {
	enum RecordType type;
	union {
		struct RecordA a;
		struct RecordB b;
		struct RecordC c;
	} value;
};
```

becomes

```haskell
data Record = RecordA Int | RecordB Int | RecordC Int
```

# Algebra of Types


Definition								Size			Name
----------								----			----
`data Unit = Unit`						1
`data Bool = True | False`				2
`data Maybe a = Just a | None`			$1 + a$
`data Either a b = Left a | Right b`	$a + b$			*Sum Type*
`data (a, b) = (a, b)`					$a \times b$	*Product Type*

- Product Type → "$a$ and $b$"
- Sum Type → "$a$ or $b$"


# Algebra of Types: Linked List

what size is a `LinkedList`?

## Haskell
```Haskell
data LinkedList a = Nil | Cons a (LinkedList a)
```

## C++
```C++
template <typename a>
struct LinkedList<a> {
    a first;
	LinkedList<a> * rest;
}
```

# Algebra of Types: Linked List (cont.)

```Haskell
data LinkedList a = Nil | Cons a (LinkedList a)
```

\begin{equation}
	\begin{split}
	L &= 1 + aL \\
	  &= 1 + a(a + aL) \\
	  &= 1 + a^2 + a^2 (1 + aL) \\
	  &= 1 + a + a^2 + a^3 + \ldots
	\end{split}
\end{equation}

a `LinkedList` is:

- `1`
- $a$
- $a \times a$
- $a \times a \times a$
- ...


remember Taylor Series?

# Algebra of Types: Linked List (cont.)

\begin{equation}
	\begin{split}
	L        &= 1 + aL \\
	L(1 - a) &= 1 \\
	L		 &= \boxed{\dfrac{1}{1 - a}} \\
	\end{split}
\end{equation}

instead of considering this as *derived*, you can *define* a `LinkedList` as this function.

# Algebra of Types: Data Structures

```Haskell
data BTree a = Leaf a | Branch (BTree a) (BTree a)
```

\begin{equation}
	\begin{split}
	T &= a + T^2 \\
	  &= a + (a + T^2)^2 \\
	  &= a + (a + (a + T^2)^2)^2 \\
	  &= \ldots \\
	  &= a + a^2 + 2a^3 + 5a^4 + 14a^5 + \ldots
	\end{split}
\end{equation}

(those are the *Catalan numbers*).
how the did we even get here?

# Algebra of Types: Computability

## Curry-Howard Isomorphism
computer programs *are* mathematical proofs

Logic side 						Programming side
---------- 						----------------
universal quantification 		generalised product type
existential quantification 		generalised sum type
implication 					function type
conjunction 					product type
disjunction 					sum type
true formula 					unit type
false formula 					bottom type

# Algebra of Types: Bonus -- `zipper`

a *zipper* is a data structure that 'focuses' on one element.

a linked list,
```
: -> : -> : -> : -> []
|    |    |    |
1    2    3    4
```

'focusing' that list on $3$:

```
[] <- : <- : <- FOCUS -> : -> []
      |    |      |      |
	  1    2      3      4
```

# Algebra of Types: Bonus -- Derivatives

what is the corresponding function for this zipper of a linked list?

\begin{equation}
	\begin{split}
	L_z &= \frac{1}{(1 - a)^2} \\
		&= \frac{\partial L}{\partial a}
	\end{split}
\end{equation}

this is true in general; if you want the zipper of a data structure, take its derivative.
