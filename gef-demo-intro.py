import random
import pathlib

from typing import List

TIPS_FILEPATH = pathlib.Path(__file__).parent / "tips.txt"
TIPS = [
    x.strip()
    for x in TIPS_FILEPATH.open("r", encoding="utf-8").readlines()
    if len(x.strip())
]


@register
class TipsOfTheDayCommand(GenericCommand):
    """Template of a new command."""

    _cmdline_ = "gef-tip"
    _syntax_ = f"{_cmdline_:s}"

    def do_invoke(self, _: List[str]):
        info("Did you know?\n  " + random.choice(TIPS) + "\n")
        return


clear_screen()

gef_print("=========================================")
gef_print("Welcome to the online demo version of GEF")
gef_print("=========================================")

gef_print()
gef_print(
    """
 ________________________________________________________________________
{ To start debugging, simply type: start                                 }
{ To view the help menu, simply type: gef                                }
{ To view/modify the current GEF configuration, simply type: gef config  }
{ Want more tips: gef-tip                                                }
 -------------------------------------------------------------------------
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

"""
)

ok("Happy debugging!\n")

TipsOfTheDayCommand().do_invoke("")
