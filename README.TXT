= RISE: Ruby Interactive Sprite Environment

http://benweissmann.github.com/rise

Copyright (C) 2010 Ben Weissmann <benweissmann@gmail.com>

Licensed under the LGPL; see below for details

== Contact

Any questions, comments, or ideas can be directed to Ben Weissmann,
benweissmann@gmail.com

== Use

src/ contains the default directory structure for RISE projects,
including the framework itself. Copy this directory for each project,
and modify the contents of the "src" folder. Then, run "runner.rb"

== Demo

Run "rake demo" to select from a list of demos. Use "rake demo[n]" to
run demo n (numbers are shown when running "rake demo")

== Developing

src/lib/ contains the main part of the framework.

test/ contains a testbed. Running test.sh copies the current contents 
of src/ into test/, then runs the test application. Note that becuase 
the framework includes a default src/main.rb, the test application 
stores its main.rb in test/new_main.rb. Make any changes there.

== Contributing

Grab the latest using git. Instructions at
http://github.com/benweissmann/rise. Submit paches to the contact
address listed above, or fork the repository and submit a pull 
request. Thanks for contributing!

== Credits

=== Core Developers
- Ben Weissmann
- Mason Glidden

=== Demo Developers
All demos are maintained and edited by the core developers; however,
some demos were created in collaboration with other developers, as
listed below.

- Adventure Game: Nate Lamkin, Will Stoddard, Jesse McQuillan
- Breakout: Niki Edmunds, SeungHee Han
- Project Eron: Andrew Kelliher, J.R. Lee
- Rock 'em, Sock 'em Robots: Bruce Duggan, Max Samels
- Synth Hero: Andrew Dempsey, Ben-Ben Fleuraguste


=== Projects
The following projects and libraries are used by RISE.

- Rubygame (http://rubygame.org/)
- Ruby (http://www.ruby-lang.org/en/)
- SDL (http://www.libsdl.org/)
- Ruby/SDL (http://www.kmc.gr.jp/~ohai/rubysdl.en.html)
- RDoc (http://ruby-doc.org/core/)

== License

RISE is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation, either version 3 of
the License, or (at your option) any later version.

RISE is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with RISE, in a file called COPYING.LESSER.
in addition, your should have received a copy of the GNU General
Public License, in a file called COPYING. If you did not
receive a copy of either of these documents, see
http://www.gnu.org/licenses/.
