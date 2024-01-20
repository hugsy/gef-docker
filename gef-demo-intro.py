import random
import gdb

from typing import List

def random_tip_of_the_day():
    tips = [x.strip()
            for x in open("/gef/tips", "r").readlines() if len(x.strip())]
    return random.choice(tips)

@register
class TipsOfTheDayCommand(GenericCommand):
    """Template of a new command."""
    _cmdline_ = "gef-tip"
    _syntax_ = f"{_cmdline_:s}"
    
    def do_invoke(self, argv: List[str]):
        print("Did you know?")
        print(random_tip_of_the_day())
        print("")
        return


print("=========================================")
print("Welcome to the online demo version of GEF")
print("=========================================")

print()
print("""
 _______________________________________________________________________
{ To start debugging, simply type: start                                }
{ To view the help menu, simply type: gef                               }
{ To view/modify the current GEF configuration, simply type: gef config }
 ------------------------------------------------------------------------
 \\
  \\
     __
    /  \\
    |  |
    @  @
    |  |
    || |/
    || ||
    |\\_/|
    \\___/
""")
print("")

print()
print("Happy debugging!")
print()

gdb.execute("gef-tip")
