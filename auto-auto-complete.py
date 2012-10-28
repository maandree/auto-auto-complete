#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''
auto-auto-complete – Autogenerate shell auto-completion scripts

Copyright © 2012  Mattias Andrée (maandree@kth.se)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''
import sys


'''
Hack to enforce UTF-8 in output (in the future, if you see anypony not using utf-8 in
programs by default, report them to Princess Celestia so she can banish them to the moon)

@param  text:str  The text to print (empty string is default)
@param  end:str   The appendix to the text to print (line breaking is default)
'''
def print(text = '', end = '\n'):
    sys.stdout.buffer.write((str(text) + end).encode('utf-8'))

'''
stderr equivalent to print()

@param  text:str  The text to print (empty string is default)
@param  end:str   The appendix to the text to print (line breaking is default)
'''
def printerr(text = '', end = '\n'):
    sys.stderr.buffer.write((str(text) + end).encode('utf-8'))




'''
Bracket tree parser
'''
class Parser:
    '''
    Parse a code and return a tree
    
    @param   code:str      The code to parse
    @return  :list<↑|str>  The root node in the tree
    '''
    @staticmethod
    def parse(code):
        stack = []
        stackptr = -1
        
        comment = False
        escape = False
        quote = None
        buf = None
        
        for charindex in range(0, len(code)):
            c = code[charindex]
            if comment:
                if c in '\n\r\f':
                    comment = False
            elif escape:
                escape = False
                if   c == 'a':  buf += '\a'
                elif c == 'b':  buf += chr(8)
                elif c == 'e':  buf += '\033'
                elif c == 'f':  buf += '\f'
                elif c == 'n':  buf += '\n'
                elif c == 'r':  buf += '\r'
                elif c == 't':  buf += '\t'
                elif c == 'v':  buf += chr(11)
                elif c == '0':  buf += '\0'
                else:
                    buf += c
            elif c == quote:
                quote = None
            elif (c in ';#') and (quote is None):
                if buf is not None:
                    stack[stackptr].append(buf)
                    buf = None
                comment = True
            elif (c == '(') and (quote is None):
                if buf is not None:
                    stack[stackptr].append(buf)
                    buf = None
                stackptr += 1
                if stackptr == len(stack):
                    stack.append([])
                else:
                    stack[stackptr] = []
            elif (c == ')') and (quote is None):
                if buf is not None:
                    stack[stackptr].append(buf)
                    buf = None
                if stackptr == 0:
                    return stack[0]
                stackptr -= 1
                stack[stackptr].append(stack[stackptr + 1])
            elif (c in ' \t\n\r\f') and (quote is None):
                if buf is not None:
                    stack[stackptr].append(buf)
                    buf = None
            else:
                if buf is None:
                    buf = ''
                if c == '\\':
                    escape = True
                elif (c in '\'\"') and (quote is None):
                    quote = c
                else:
                    buf += c
        
        raise Exception('premature end of file')
    
    
    '''
    Simplifies a tree
    
    @param  tree:list<↑|str>  The tree
    '''
    @staticmethod
    def simplify(tree):
        program = tree[0]
        stack = [tree]
        while len(stack) > 0:
            node = stack.pop()
            new = []
            edited = False
            for item in node:
                if isinstance(item, list):
                    if item[0] == 'multiple':
                        master = item[1]
                        for slave in item[2:]:
                            new.append([master] + slave)
                        edited = True
                    elif item[0] == 'case':
                        for alt in item[1:]:
                            if alt[0] == program:
                                new.append(alt[1])
                                break
                        edited = True
                    else:
                        new.append(item)
                else:
                    new.append(item)
            if edited:
                node[:] = new
            for item in node:
                if isinstance(item, list):
                    stack.append(item)



'''
Completion script generator for GNU Bash
'''
class GeneratorBASH:
    '''
    Constructor
    
    @param  program:str                              The command to generate completion for
    @param  unargumented:list<dict<str, list<str>>>  Specification of unargumented options
    @param  argumented:list<dict<str, list<str>>>    Specification of argumented options
    @param  variadic:list<dict<str, list<str>>>      Specification of variadic options
    @param  suggestion:list<list<↑|str>>             Specification of argument suggestions
    '''
    def __init__(self, program, unargumented, argumented, variadic, suggestion):
        print("{bash}")



'''
mane!

@param  shell:str   Shell to generato completion for
@param  output:str  Output file
@param  source:str  Source file
'''
def main(shell, outputm source)
    with open(source, 'rb') as file:
        source = file.read().decode('utf8', 'replace')
    source = Parser.parse(source)
    Parser.simplify(source)
    
    program = source[0]
    unargumented = []
    argumented = []
    variadic = []
    suggestion = []
    
    for item in source[1:]:
        if item[0] == 'unargumented':
            unargumented.append(item[1:]);
        elif item[0] == 'argumented':
            argumented.append(item[1:]);
        elif item[0] == 'variadic':
            variadic.append(item[1:]);
        elif item[0] == 'suggestion':
            suggestion.append(item[1:]);
    
    for group in (unargumented, argumented, variadic):
        for index in range(0, len(group)):
            item = group[index]
            map = {}
            for elem in item:
                map[elem[0]] = elem[1:]
            group[index] = map
    
    generator = 'Generator' + shell.upper()
    generator = globals()[generator]
    generator = generator(program, unargumented, argumented, variadic, suggestion)



'''
mane!
'''
if __name__ == '__main__':
    if len(sys.argv) != 6:
        print("USAGE: auto-auto-complete SHELL --output OUTPUT_FILE --source SOURCE_FILE")
        exit(1)
    
    shell = sys.argv[1]
    output = None
    source = None
    
    option = None
    aliases = {'-o' : '--output',
               '-f' : '--source', '--file' : '--source',
               '-s' : '--source'}
    
    def useopt(option, arg):
        global source
        global output
        old = None
        if   option == '--output': old = output; output = arg
        elif option == '--source': old = source; source = arg
        else:
            raise Exception('Unrecognised option: ' + option)
        if old is not None:
            raise Exception('Duplicate option: ' + option)
    
    for arg in sys.argv[2:]:
        if option is not None:
            if option in aliases:
                option = aliases[option]
            useopt(option, arg)
            option = None
        else:
            if '=' in arg:
                useopt(arg[:index('=')], arg[index('=') + 1:])
            else:
                option = arg
    
    if output is None: raise Exception('Unused option: --output')
    if source is None: raise Exception('Unused option: --source')
    
    main(shell= shell, output= output, source= source)

