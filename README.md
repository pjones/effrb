# Effective Ruby Source Code

Source code for the book [Effective Ruby][] by [Peter J. Jones] [].

## Introduction

Virtually all of the code from the book is implemented as unit tests
using `MiniTest`.  I used a makefile and some scripts to convert the
book from Markdown to the format used by my publisher, Addison-Wesley.
During this process all of the tests are run and snippets of code are
automatically extracted from the tests and inserted into the final
document.

## Running the Tests

If you just want to run the tests against your currently installed
version of Ruby:

~~~
bundle install && rake test
~~~

On the other hand, if you have [rbenv] [] installed and want to test
against all the versions listed in the `ruby-versions.txt` file:

~~~
./runtests.sh
~~~

That script will install all of the necessary Ruby versions and then
test against each one of them.

## Issues and Pull Requests

There are several reasons you might want to open an issue:

  * You get the tests to pass on a version or implementation of Ruby
    not listed below.  In that case, I'll update this file and
    reference you and the issue.

  * You get the tests to fail.  Please provide as much detail in the
    issue description.  Worst case I'll update this file and reference
    the issue and any workarounds.

  * You don't like one of my examples or disagree with the approach
    taken.  Write a good issue description, include an alternate
    approach, and if I like it I'll reference it in this file.

**Please do not submit pull requests.** If there ever happens to be a
new edition of the book then I don't want to have to track down every
contributor in order to sign a release.  I'm lazy.  Plus, come on,
this is just example code.

## Directory/Chapter Layout

The source code in this repository includes all of the code shown in
the book [Effective Ruby][] along with the snippets of code used to
produce the IRB sessions.  It also includes several source code files
that did not appear in the book.  First, let's take a look at the
directories that correspond to chapters in the book.

  * `ruby`: Chapter 1: Accustoming Yourself to Ruby.

  * `oop`: Chapter 2: Classes, Objects, and Modules.

  * `collections`: Chapter 3: Collections.

  * `exceptions`: Chapter 4: Exceptions.

  * `meta`: Chapter 5: Metaprogramming.

  * `testing`: Chapter 6: Testing.

  * `tools`: Chapter 7: Tools and Libraries.

  * `performance`: Chapter 8: Memory Management and Performance.

The remaining directories contain the following:

  * `assumptions`: General tests created to ensure that statements
    given in the book are accurate.

  * `benchmarks`: Various benchmarks to compare the performance of
    core classes or Ruby programming techniques.

  * `coverage`: Example project for the test code coverage metrics
    given in chapter 6.

  * `data`: CSV files used by the tests along with profiling output
    used in chapter 8.

  * `fuzz`: Example of using FuzzBert from chapter 6.

  * `irb`: All of the scripts used to generate the IRB output in the
    book, organized by chapter.

  * `lib`: Code used in the book for both examples and also by the IRB
    scripts.

## Ruby Version

Unless otherwise noted, all of the code in this repository works with
the following Ruby versions:

  * 1.9.3 (Official Ruby)
  * 2.0.0 (Official Ruby)
  * 2.1.0 (Official Ruby)
  * 2.1.1 (Official Ruby)
  * 2.1.2 (Official Ruby)

Where:

Official Ruby:
  ~ The original and [official][ruby-home] implementation of the Ruby
    interpreter and language by the Ruby Core team (MRI).

Files that only work with a specific version of Ruby will have a
version specifier in their name.  For example:

~~~
patching_2_1_test.rb
~~~

This file will only work with Ruby 2.1 or greater.  The `Rakefile`
ensures that files are omitted from testing if the version of the Ruby
interpreter isn't appropriate.

## Contacting the Author

If you want to contact the author about the source code in this
repository please look at the *Issues and Pull Requests* section
above.  For non-source code related topics, you can reach the author
through his [website][peter j. jones].

The author tweets Ruby tips at [@EffectiveRuby][] and personal junk at
[@contextualdev][].

[effective ruby]: http://www.effectiveruby.com/
[peter j. jones]: http://www.devalot.com/
[ruby-home]: http://www.ruby-lang.org/
[rbenv]: https://github.com/sstephenson/rbenv
[@effectiveruby]: https://twitter.com/EffectiveRuby
[@contextualdev]: https://twitter.com/contextualdev
