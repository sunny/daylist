Daylist
=======

A small checklister for personnal use. Launch it, answer each question and get
the percentage of stuff done.

Example
-------

```bash
$ ruby daylist.rb example.txt
You…
Brushed teeth at least once ?
```

And after answering `y` or `n` and pressing enter after a few questions you
would get:

```bash
$ ruby daylist.rb example.txt
You…
Brushed teeth at least once ? y
Washed dishes at least once ? n
Ate a veggie meal ? n
Results:
 ✔ Brushed teeth at least once
 ✗ Washed dishes at least once
 ✗ Ate a veggie meal
1 passed, 2 failed, 33%
```

Create a list
-------------

Fill a text file with todo items. Use `#` for comments. Example :

    # My weekly list!
    Went to the gym
    Helped an open-source project
    Called Mom

Another example is the big [Cleen Sweep|http://betterme.org/cleansweep.html],
attached as `cleensweep.txt`.
