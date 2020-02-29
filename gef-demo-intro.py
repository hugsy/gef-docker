import random


def random_tip_of_the_day():
  tips = open("/gef/tips", "r").readlines()
  return random.choice(tips)


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

print("Did you know?")
print( random_tip_of_the_day() )

