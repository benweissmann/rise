= EasyRubygame

http://benweissmann.github.com/EasyRubygame

Copyright (C) 2010 Ben Weissmann <benweissmann@gmail.com>

Licensed under the LGPL; see below for details

== Contact

Any questions, comments, or ideas can be directed to Ben Weissmann,
<benweissmann@gmail.com>

== Use

src/ contains the default directory structure for EasyRubygame projects,
including the framework itself. Copy this directory for each project,
and modify the contents of the "src" folder. Then, run "runner.rb"

== Demo

Run "test.sh" to run the demo, a game of pong. Use the arrow keys to control
the paddles.

== Developing

src/lib/ contains the main part of the framework.

test/ contains a testbed. Running test.sh copies the current contents of
src/ into test/, then runs the test application. Note that becuase the
framework includes a default src/main.rb, the test application stores
its main.rb in test/new_main.rb. Make any changes there.

== Contributing

Grab the latest using git. Instructions at
http://github.com/benweissmann/EasyRubygame. Submit paches to the contact
address listed above, or fork the repository and submit a pull request. Thanks
for contributing!

== Credits

=== Developers
- Ben Weissmann
- Mason Glidden

=== Projects
- Rubygame (http://rubygame.org/)
- Ruby (http://www.ruby-lang.org/en/)
- SDL (http://www.libsdl.org/)
- Ruby/SDL (http://www.kmc.gr.jp/~ohai/rubysdl.en.html)
- RDoc (http://ruby-doc.org/core/)

== License

EasyRubygame is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation, either version 3 of
the License, or (at your option) any later version.

EasyRubygame is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with EasyRubygame, in a file called COPYING.LESSER.
in addition, your should have received a copy of the GNU General
Public License, in a file called COPYING. If you did not
receive a copy of either of these documents, see
<http://www.gnu.org/licenses/>.
