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
    
    @param   code:str            The code to parse
    @return  :list<list<↑>|str>  The root node in the tree
    '''
    @staticmethod
    def parse(code):
        raw = code.replace('\f', '\n').replace('\r\n', '\n').replace('\r', '\n').replace('\t', ' ')
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
                else
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
                stack[stackptr] = []
            elif (c == ')') and (quote is None):
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
                elif c in '\'\"':
                    quote = c
                else:
                    buf += c
        
        raise Exception('premature end of file')



'''
mane!
'''
if __name__ = '__main__':
    print('I am so sorry, this is not implement yet.')


