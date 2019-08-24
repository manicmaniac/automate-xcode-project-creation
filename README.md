automate-xcode-project-creation
===============================

An experiment to create Xcode project fully programatically on Circle CI.

Report
------

Unfortunately, there's no built-in support to create Xcode project programatically.

Since somehow I need to do it, I tried with a couple of approches.

1. Use OSA events

Firstly I tried to manipulate Xcode by sending OSA events to Xcode via AppleScript language.

The code is [here](https://github.com/manicmaniac/automate-xcode-project-creation/commit/70813b5f8be45fae9fc0169f2fe4b69320425ab2#diff-e653de6f89bdffd67b9bec9ab2b498fb).

It worked on my local machine but another problem raised.

- Can't run on CI

By default, MacOS forbids any applications to receive OSA events so I had to enable this feature.

Actually there's a way to enable it programatically, by modifying `/Library/Application Support/com.apple.TCC/TCC.db` manually.

However, MacOS has introduced SIP (System Integrity Protection) since High Sierra.
This prevents users, which includes even superusers, from modifying TCC.db unless it is disabled by rebooting OS in safe mode.

- Too slow and randomly fails

Basically GUI scripting with AppleScript needs a lot of `delay`s to wait anything like opening the next window, alert dialong, file selection dialong and so on.
I have to assume a low-spec machine and expect to be in the worst condition in order to set `delay` times otherwise the script fails randomly.

For the above reasons, this choice didn't make it.

2. Use Xcode private frameworks

Secondly I tried using Xcode's private frameworks named `DVTFoundation` and `IDEFoundation` to achive the goal.

Under the hood Xcode is made by bunch of plugins and one of the plugins defines how to create a new project from a given template.
I investigated private frameworks to grasp how to utilize it and finally created a tiny command line tool named [xcnew](https://github.com/manicmaniac/xcnew).

Although exploring framework binaries was very hard for me, this approach completely works and no problems like the above occurs.
