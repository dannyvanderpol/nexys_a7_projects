# VHDL basics

## Types of code

Two types of code:
* behavioral
* structural

### Behavioral
Describe behavior (functionality).

```
entity <entity-name> is
    port(
        input_1: in  std_logic;
        input_2: in  std_logic;
        output : out std_logic
    );
end <entity-name>;

architecture <arch-name> of <entity-name> is
begin
    output <= input_1 or input_2;
end <arch-name>;
```

### Structural
Describe structure (connections).

```
entity <entity-name> is
begin
    port(
        i_1: in  std_logic;
        i_2: in  std_logic;
        o  : out std_logic
    );
end <entity-name>

architecture <arch-name> of <entity-name> is
    component or_entity
        port(
          input_1: in  std_logic;
          input_2: in  std_logic;
          output : out std_logic
        );
    end component;
begin
    or_1: or_entity
        port map(
            output => o,
            input_1 => i_1,
            input_2 => i_2
        );
end <arch-name>;
```

## Basic guidelines

* Use active high signals.
* When clocking, use only one clock and one edge of the clock.
* Any clocked process should include an asynchronous reset signal.
* In statemachines, always define behavior of all states and outputs.
* In conditional statements, always define all cases.
* Avoid nested conditional statements.
* Create exclusive conditional cases, rather than overlapping cases.
