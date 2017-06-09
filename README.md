# TODO.txt -- A PowerShell Port

## Release State
This has been a lot of cobbling. I haven't really decided how to approach this port in a coherent manner nor have I had a lot of time to devote to refactoring the original shell script to posh. 

Please consider this an alpha release. 

## Installation
The easiest way is to clone this repository and copy or move it to your PowerShell modules directory. Then call `Import-Module Todo`. 

## Usage
This port should function very similiarly to TODO.sh. I have tried to copy and emulate a lot of the functionality. One distinct difference is the use of Cmdlet bindings and streaming processing. In bash, when calling todo to function on mulitple items, you would call it like so 

```sh
todo [command] item1 item2 item3
```

In this port, using PowerShell, you would do the same thing by
```sh
item1, item2, item3 | todo [command]
```

An example would be
```sh
3, 5, 6 | todo -Delete
```
Which would delete those items in todo.txt (by default, though you can change that with `-Path`). 

I could have emulated the bash behavior perfectly, but I wanted to leverage the power of Cmdlet parameters. 

## Cross Compatibility
So far, Todo seems to function well with todo.sh. They can share todo.txt, done.txt, and report.txt files. For the most part, they can share the same config file. I have tried to write Todo to play well on unix systems, and this requires careful manipulation of environmental variables. But these features aren't fully tested. 

## Why? 
I have a Windows box at work and a Mac at home. Using Todo.sh is a pleasure, and I wanted to sync my Reminders and todo.txt between machines. I have an AppleScript/Swift solution that syncs my Reminders and todo.txt, I can use Todo (posh) to set a todo at work, and within five minutes it'll push to my phone (which I cannot use at work) as long as my computer at home is on. Then, when I do the reminder, my todo.txt will update. 

## Contributing
Completely welcome. As this project stands, it does what _I_ need it to do. But, I understand if it's to be used for the larger public, it'll need to be improved. If you like todo.sh and would like to use it with posh, feel free to improve what I've done and send pull requests! 

### Issues
That said, if enough people use this, I'm sure issues will be discover. Please report them to me! I will look into them and try to fix them as fast as possible. When reporting, please describe what system and version of PowerShell you are using at the minimum. 

## Disclaimer and License
MIT License

And it goes without saying, this script may cause damage to your data (notably your todo.txt, done.txt, and report.txt files). Use at your own risk. 
